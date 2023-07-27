import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantrip_traveler/model/business_place_model.dart';
import 'package:plantrip_traveler/pages/activity_screen/place_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

final List<Map<String, dynamic>> Places_list = [];

class _ActivityPageState extends State<ActivityPage> {
  
  void loadBusinessPlace(String text_search) async {
    Response response = await get(
      Uri.parse(
          'http://plantrip-final-f854bbde88de.herokuapp.com/business/?search=$text_search'),
    );

    if (response.statusCode == 200) {
      // final data = json.decode(response.body);
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final List<Map<String, dynamic>> Places = [];
      final List<dynamic> successList = data;

      successList.forEach((success) {
        final Map<String, dynamic> p = {
          "id": success["id"],
          "name": success["name"],
          "detail": success["detail"],
          "district": success["district"],
          "lat": success["lat"],
          "lng": success["lng"],
          "address": success["address"],
          "timeOpen": success["timeOpen"],
          "timeClose": success["timeClose"],
          "website": success["website"],
          "pic_link1": success["pic_link1"],
          "pic_link2": success["pic_link2"],
          "pic_link3": success["pic_link3"],
          "type": success["type"],
          "place_user": success["place_user"],
        };

        // final Map<String, dynamic> p = {
        //   "id": success["id"],
        //   "name": success["name"],
        //   "detail": success["detail"],
        //   "lat": success["lat"],
        //   "lng": success["lng"],
        //   "address": success["address"],
        //   "timeOpen": success["timeOpen"],
        //   "timeClose": success["timeClose"],
        //   "website": success["website"],
        //   "pic1": success["pic1"],
        //   "pic2": success["pic2"],
        //   "pic3": success["pic3"],
        //   "pic_link1": success["pic_link1"],
        //   "pic_link2": success["pic_link2"],
        //   "pic_link3": success["pic_link3"],
        //   "vr": success["vr"],
        //   "created_datetime": success["created_datetime"],
        //   "change_datetime": success["change_datetime"],
        //   "type": success["type"],
        //   "place_user": success["place_user"],
        // };

        //Places.add(p);

        setState(() {
          Places_list.add(p);
        });
      });

      print("activity_log: Place load successful.");
    } else {
      print("activity_log: Place load failed.");
    }
  }

  Text _buildRatingStart(int rating) {
    String starts = '';
    for (int i = 0; i < rating; i++) {
      starts += '⭐';
    }
    starts.trim();
    return Text(starts);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBusinessPlace("");
  }

  @override
  Widget build(BuildContext context) {
    if (Places_list != null) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                onSubmitted: (value) {
                  setState(() {
                    Places_list.clear();
                    loadBusinessPlace(value);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ค้นหาสถานที่',
                  suffixIcon: Icon(
                    Icons.search,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                      itemCount: Places_list.length,
                      itemBuilder: (context, index) {
                        final pl = Places_list[index];

                        print("pl_type = " + pl.runtimeType.toString());

                        return InkWell(
                            onTap: () {
                              var temp = BusinessPlace.fromJson(pl);
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlaceDetailPage(),
                                    settings: RouteSettings(arguments: temp,)),
                              );
                            },
                            child: Container(
                              height: 250,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image:
                                      NetworkImage(pl['pic_link1'].toString()),
                                  fit: BoxFit.cover,
                                  opacity: 0.7,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pl['name'].toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                            child: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_pin,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              pl['district'].toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            _buildRatingStart(5)
                                          ],
                                        )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: 75,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.blue[700],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Text(
                                            pl['timeOpen'].toString() == "null"
                                                ? "ไม่ระบุ"
                                                : pl['timeOpen'].toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: LoadingAnimationWidget.twistingDots(
            leftDotColor: const Color(0xFF1A1A3F),
            rightDotColor: const Color(0xFFEA3799),
            size: 100,
          ),
        ),
      );
    }
  }
}
