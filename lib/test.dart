import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantrip_traveler/model/business_place_model.dart';
import 'package:plantrip_traveler/model/user_model.dart';
import 'package:plantrip_traveler/pages/home_screen/home_page.dart';
import 'package:plantrip_traveler/pages/home_screen/register_page.dart';
import 'package:plantrip_traveler/pages/user_screen/user_profile_edit_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

// final List<Map<String, dynamic>>? Places_list = [];
var user;

class _TestPageState extends State<TestPage> {
  // void loadBusinessPlace(String text_search) async {
  //   Response response = await get(
  //     Uri.parse(
  //         'http://plantrip-final-f854bbde88de.herokuapp.com/business/?search=$text_search'),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(utf8.decode(response.bodyBytes));
  //     final List<Map<String, dynamic>> Places = [];
  //     final List<dynamic> successList = data;

  //     successList.forEach((success) {
  //       final Map<String, dynamic> p = {
  //         "id": success["id"],
  //         "name": success["name"],
  //         "detail": success["detail"],
  //         "district": success["district"],
  //         "lat": success["lat"],
  //         "lng": success["lng"],
  //         "address": success["address"],
  //         "timeOpen": success["timeOpen"],
  //         "timeClose": success["timeClose"],
  //         "website": success["website"],
  //         "pic_link1": success["pic_link1"],
  //         "pic_link2": success["pic_link2"],
  //         "pic_link3": success["pic_link3"],
  //         "type": success["type"],
  //         "place_user": success["place_user"],
  //       };

  //       setState(() {
  //         Places_list!.add(p);
  //       });
  //     });

  //     print("activity_log: Place load successful.");
  //   } else {
  //     print("activity_log: Place load failed.");
  //   }
  // }

  void loadUser() async {
    try {
      String username = "admin";
      Response response = await get(
        Uri.parse(
            'https://plantrip-final-f854bbde88de.herokuapp.com/user/$username'),
      );

      if (response.statusCode == 200) {
        setState(() {
          final temp = jsonDecode(response.body.toString());
          final value = User.fromJson(temp[0]);
          // final value = User.fromJson(temp);
          // final value = temp['username'];
          // final temp = jsonDecode(response.body.toString());

          print("temp=" + temp.runtimeType.toString());
          print("temp-json=" + temp.toString());
          print("temp-test=" + value.username);

          if (value != null) {
            setState(() {
              user = value;
            });
          }

          // print("value=" + value.runtimeType.toString());
          // print("value-json=" + value.toString());
          // print("value=" + value.toString());

          print("user_log: Fetch User Success!!!");
        });
      } else {
        print("user_log: User not found.");
      }
    } catch (e) {
      print("user_error_log:" + e.toString());
    }
  }

  Widget _textViewUserDetail(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 5),
              color: Colors.grey.withOpacity(.2),
              spreadRadius: 5,
              blurRadius: 10,
            )
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
        ),
        tileColor: Colors.white,
      ),
    );
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
      onPressed: () {},
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
                // controller: _firstnameController,
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
    loadUser();
    // loadBusinessPlace("");
  }

  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rating : $rating',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            _buildRating(),
            const SizedBox(
              height: 32,
            ),
            TextButton(
                child: Text('Show Dialog'),
                onPressed: () {
                  showAlertDialog(context);
                })
          ],
        ),
      ),
    );
    //   if (user != null) {
    //     return Scaffold(
    //       body: Padding(
    //         padding: const EdgeInsets.all(40),
    //         child: Column(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(vertical: 20),
    //                     child: InkWell(
    //                       onTap: () {
    //                         Navigator.pop(context);
    //                       },
    //                       child: Icon(
    //                         Icons.arrow_back_ios,
    //                         color: Colors.grey,
    //                         size: 25,
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //             CircleAvatar(
    //               radius: 70,
    //               backgroundImage:
    //                   AssetImage("assets/images/person/girl-asia2.jpg"),
    //             ),
    //             const SizedBox(
    //               height: 40,
    //             ),
    //             _textViewUserDetail(
    //                 CupertinoIcons.person, "Username", user.username),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             _textViewUserDetail(
    //                 CupertinoIcons.person, "First Name", user.first_name),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             _textViewUserDetail(
    //                 CupertinoIcons.person, "Last Name", user.last_name),
    //             const SizedBox(
    //               height: 20,
    //             ),
    //             _textViewUserDetail(CupertinoIcons.mail, "Email", user.email),
    //             const SizedBox(
    //               height: 30,
    //             ),
    //             SizedBox(
    //               width: double.infinity,
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                         builder: (context) => UserProfileEditPage(),
    //                         settings: RouteSettings(arguments: user.username)),
    //                   );
    //                 },
    //                 style: ElevatedButton.styleFrom(
    //                     padding: const EdgeInsets.all(15),
    //                     foregroundColor: Colors.white,
    //                     backgroundColor: Colors.redAccent),
    //                 child: Text(
    //                   "แก้ไขโปรไฟล์",
    //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   } else {
    //     return Scaffold(
    //       body: Center(
    //         child: LoadingAnimationWidget.twistingDots(
    //           leftDotColor: const Color(0xFF1A1A3F),
    //           rightDotColor: const Color(0xFFEA3799),
    //           size: 100,
    //         ),
    //       ),
    //     );
    //   }
  }
}
