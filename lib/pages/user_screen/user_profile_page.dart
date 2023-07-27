import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantrip_traveler/model/business_place_model.dart';
import 'package:plantrip_traveler/model/user_model.dart';
import 'package:plantrip_traveler/pages/home_screen/home_page.dart';
import 'package:plantrip_traveler/pages/home_screen/register_page.dart';
import 'package:plantrip_traveler/pages/user_screen/user_profile_edit_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

var user;

class _UserProfilePageState extends State<UserProfilePage> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final username = ModalRoute.of(context)?.settings.arguments as String?;

    if (username != null) {
      loadUser(username);
    }

    if (user != null) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.grey,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              CircleAvatar(
                radius: 70,
                backgroundImage:
                    AssetImage("assets/images/person/girl-asia2.jpg"),
              ),
              const SizedBox(
                height: 40,
              ),
              _textViewUserDetail(
                  CupertinoIcons.person, "Username", user.username),
              const SizedBox(
                height: 20,
              ),
              _textViewUserDetail(
                  CupertinoIcons.person, "First Name", user.first_name),
              const SizedBox(
                height: 20,
              ),
              _textViewUserDetail(
                  CupertinoIcons.person, "Last Name", user.last_name),
              const SizedBox(
                height: 20,
              ),
              _textViewUserDetail(CupertinoIcons.mail, "Email", user.email),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileEditPage(),
                          settings: RouteSettings(arguments: user.username)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent),
                  child: Text(
                    "แก้ไขโปรไฟล์",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
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
