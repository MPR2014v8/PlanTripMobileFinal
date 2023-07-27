import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantrip_traveler/model/business_place_model.dart';
import 'package:plantrip_traveler/model/rac_model.dart';
import 'package:plantrip_traveler/model/user_model.dart';
import 'package:plantrip_traveler/pages/activity_screen/gallery_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailPage extends StatefulWidget {
  const PlaceDetailPage({
    super.key,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

// ignore: non_constant_identifier_names
final List<Map<String, dynamic>> Rac_list = [];
// ignore: unused_element
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

var _commentController = TextEditingController();

String score = "";
String comment = "";
String placeID = "";
String userID = "";

String placeId = "";
bool isRacFisrtTime = true;
var user;

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  double rating = 0;
  final Uri urlVr = Uri.parse(
      'https://webobook.com/tour/8IIz9O11unB2n6XS--1LIr7xLZlUJ3Ju/RWY-z8IWKCKMOGx9uP8HcXt6l2Io-4Ez');
  final url404_img =
      "https://raw.githubusercontent.com/MPR2014v8/PlanTripFinal/main/static/media/404.jpg";

  Text _buildRatingStart(int rating) {
    String starts = '';
    for (int i = 0; i < rating; i++) {
      starts += '⭐';
    }
    starts.trim();
    return Text(starts);
  }

  Future<void> _launchUrl(String urlStr) async {
    final Uri _urlStr = Uri.parse(urlStr);
    if (!await launchUrl(_urlStr)) {
      throw Exception('Could not launch $_urlStr');
    }
  }

  void loadRac() async {
    Response response = await get(
      Uri.parse(
          'https://plantrip-final-f854bbde88de.herokuapp.com/business/rac-all/'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> successList = data;

      successList.forEach((success) {
        final Map<String, dynamic> rac = {
          "id": success["id"],
          "score": success["score"],
          "comment": success["comment"],
          "place": success["place"],
          "user": success["user"],
        };

        setState(() {
          Rac_list.add(rac);
        });
      });

      print("rac_log: Place load successful.");
    } else {
      print("rac_log: Place load failed.");
    }
  }

  void loadUser(String username) async {
    try {
      Response response = await get(
        Uri.parse(
            'https://plantrip-final-f854bbde88de.herokuapp.com/user/$username'),
      );

      if (response.statusCode == 200) {
        setState(() {
          final temp = jsonDecode(response.body.toString());
          print("username=" + username);
          final value = User.fromJson(temp[0]);

          if (value != null) {
            setState(() {
              user = value;
            });
          }
          print("user_profile_log: Fetch User Success!!!");
        });
      } else {
        print("user_profile_log: User not found.");
      }
    } catch (e) {
      print("user_profile_error_log:" + e.toString());
    }
  }

  void addRac(String score, String comment, String place, String user) async {
    final response = await http.post(
      Uri.parse(
          'https://plantrip-final-f854bbde88de.herokuapp.com/business/rac-all/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'score': score,
        'comment': comment,
        'place': place,
        'user': user,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade800,
          content: const Text(
            'บันทึกการให้คะแนนและรีวืวแล้ว.',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'ปิด',
            onPressed: () {},
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          content: const Text(
            'การให้คะแนนและรีวืวไม่สำเร็จ.',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'ปิด',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  Widget _buildRating() {
    return RatingBar.builder(
      minRating: 1,
      itemSize: 40,
      itemPadding: EdgeInsets.symmetric(horizontal: 4),
      updateOnDrag: true,
      itemBuilder: (context, _) => Icon(
        Icons.star_outlined,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) => setState(
        () {
          this.rating = rating;
        },
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade800),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      child: Text(
        "ปิด",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );

    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10),
          foregroundColor: Colors.white,
          backgroundColor: Colors.redAccent),
      onPressed: () async {
        final SharedPreferences prefs = await _prefs;
        final temp = prefs.getString("username");
        setState(() {
          if (temp != null) {
            loadUser(temp);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.redAccent,
                content: const Text(
                  'เกิดข้อผิดพลาดในการบันทึกข้อมูล. กรุณาลองใหม่อีกครั้ง',
                  style: TextStyle(color: Colors.white),
                ),
                action: SnackBarAction(
                  label: 'ปิด',
                  onPressed: () {},
                ),
              ),
            );
            return;
          }

          userID = user.id.toString();
          score = rating.toString();
          comment = _commentController.text.toString();
          addRac(score, comment, placeID, userID);
          Navigator.of(context, rootNavigator: true).pop('dialog');
        });
      },
      child: Text(
        "บันทึก",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ให้คะแนนและรีวิวสถานที่นี้"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRating(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextFormField(
                controller: _commentController,
                maxLines: 5,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'เพิ่มข้อความ',
                  prefixIcon: Icon(Icons.record_voice_over),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
        const SizedBox(
          width: 5,
        ),
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Rac_list.clear();
    loadRac();
  }

  @override
  Widget build(BuildContext context) {
    final pl = ModalRoute.of(context)?.settings.arguments as BusinessPlace?;

    // setState(() {
    //   Rac_list.clear();
    //   loadRac();
    // });

    if (pl != null) {
      // บัคที่เอาคอมเมนต์มาโชว์ อาจจะต้องดึง rac มาทั้งหมด แล้วมากรองในนี้

      final List<String> imgList = [pl.pic_link1, pl.pic_link2, pl.pic_link3];

      return Scaffold(
        backgroundColor: const Color(0xfff3f4f7),
        body: ListView(children: [
          Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    pl.pic_link1,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.46,
                  ),
                  SafeArea(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      // Text
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                pl.name,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(
                                    width: 1,
                                  ),
                                  Text(
                                    pl.district,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  _buildRatingStart(5),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  pl.timeOpen == "" ? "ไม่ระบุ" : pl.timeOpen,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Divider(color: Colors.grey.shade600),
                              const Text(
                                '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum''',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Divider(color: Colors.grey.shade600),
                              const SizedBox(
                                height: 10,
                              ),

                              // Place Picture
                              Container(
                                child: CarouselSlider(
                                    options: CarouselOptions(
                                        aspectRatio: 2.0,
                                        enlargeCenterPage: true),
                                    items: imgList
                                        .map((item) => Container(
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(5.0),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        InkWell(
                                                          onTap: () {
                                                            // open galler
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        GalleryView(
                                                                          urlImages:
                                                                              imgList,
                                                                          indexStart:
                                                                              imgList.indexOf(item),
                                                                        )));
                                                          },
                                                          child: Image(
                                                              image:
                                                                  NetworkImage(
                                                                      item),
                                                              fit: BoxFit.cover,
                                                              width: 1000.0),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ))
                                        .toList()),
                              ),

                              Divider(color: Colors.grey.shade600),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _launchUrl(
                                      "https://webobook.com/tour/8IIz9O11unB2n6XS--1LIr7xLZlUJ3Ju/RWY-z8IWKCKMOGx9uP8HcXt6l2Io-4Ez");
                                },
                                icon: const Icon(FontAwesomeIcons.eye),
                                label: const Text(
                                  "ทัวร์สเมือนจริง",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("เว็บไซต์ : ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        _launchUrl(pl.website);
                                      },
                                      child: Text(
                                        pl.website,
                                        style:
                                            const TextStyle(color: Colors.blue),
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              // Google map
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  width: double.infinity,
                                  height: 300,
                                  child: Stack(children: [
                                    GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(double.parse(pl.lat),
                                            double.parse(pl.lng)),
                                        zoom: 8,
                                      ),
                                      markers: {
                                        Marker(
                                          markerId: const MarkerId("source"),
                                          position: LatLng(double.parse(pl.lat),
                                              double.parse(pl.lng)),
                                        ),
                                      },
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
              Divider(color: Colors.grey.shade600),
              const SizedBox(
                height: 10,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                          onPressed: () async {
                            showAlertDialog(context);

                            // if (pl != null) {
                            //   var chkFirstTime =
                            //       await loadRac(pl.id.toString());
                            //   if (!chkFirstTime) {
                            //     // ignore: use_build_context_synchronously
                            //     showAlertDialog(context);
                            //   } else {
                            //     // ignore: use_build_context_synchronously
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //         behavior: SnackBarBehavior.floating,
                            //         backgroundColor: Colors.orange.shade800,
                            //         content: const Text(
                            //           'คุณได้ให้คะแนนและรีวืวแล้ว.',
                            //           style: TextStyle(color: Colors.white),
                            //         ),
                            //         action: SnackBarAction(
                            //           label: 'ปิด',
                            //           onPressed: () {},
                            //         ),isLoginStatusRac_list
                            //       ),
                            //     );
                            //   }
                            // }
                          },
                          icon: const Icon(Icons.record_voice_over),
                          label: const Text("ให้คะแนนและรีวิว")),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: Rac_list.length,
                          itemBuilder: (context, index) {
                            var rac = Rac_list[index];
                            print("rac_list_lenght=" +
                                Rac_list.length.toString());
                            print(rac);

                            return Card(
                              child: ListTile(
                                title: Text("user: " + rac['user'].toString()),
                                subtitle: Column(
                                  children: [
                                    _buildRatingStart(
                                        int.parse(rac['score'].toString())),
                                    Text(
                                        "comment:" + rac['comment'].toString()),
                                  ],
                                ),
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        "assets/images/person/girl-asia2.jpg"),
                                    radius: 22,
                                  ),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
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
