import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantrip_traveler/model/business_place_model.dart';
import 'package:plantrip_traveler/model/user_model.dart';
import 'package:plantrip_traveler/pages/home_screen/home_page.dart';
import 'package:plantrip_traveler/pages/home_screen/register_page.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserProfileEditPage extends StatefulWidget {
  const UserProfileEditPage({super.key});

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

var user;
bool loadFirstTime = true;
final _usernameController = TextEditingController();
final _emailController = TextEditingController();
final _firstnameController = TextEditingController();
final _lastnameController = TextEditingController();

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  void updateUserProfile(String id, String username, String email,
      String first_name, String last_name) async {

    try {
      final response = await http.put(
        Uri.parse(
            'https://plantrip-final-f854bbde88de.herokuapp.com/user/$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": username,
          "email": email,
          "first_name": first_name,
          "last_name": last_name
        }),
      );

      if (response.statusCode == 200) {
        setState(() {

          final value = jsonDecode(response.body.toString());

          // print("value_type = " + value.runtimeType.toString());
          // print(value['email']);


          if (value != null) {
            _usernameController.text = value['username'].toString();
            _emailController.text = value['email'].toString();
            _firstnameController.text = value['first_name'].toString();
            _lastnameController.text = value['last_name'].toString();
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green.shade800,
              content: const Text(
                'อัพเดทโปรไฟล์สำเร็จแล้ว.',
                style: TextStyle(color: Colors.white),
              ),
              action: SnackBarAction(
                label: 'ปิด',
                onPressed: () {},
              ),
            ),
          );

          print("user_profile_log: update User Success!!!");
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            content: const Text(
              'อัพเดทโปรไฟล์ไม่สำเร็จ.',
              style: TextStyle(color: Colors.white),
            ),
            action: SnackBarAction(
              label: 'ปิด',
              onPressed: () {},
            ),
          ),
        );
        print("user_profile_log: update User Failed!!!");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          content: const Text(
            'อัพเดทโปรไฟล์ไม่สำเร็จ.',
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            label: 'ปิด',
            onPressed: () {},
          ),
        ),
      );
      print("user_profile_error_log:" + e.toString());
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

    if (username != null && loadFirstTime != false) {
      loadUser(username);
      loadFirstTime = false;
    }

    if (user != null) {
      setState(() {
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _firstnameController.text = user.first_name;
        _lastnameController.text = user.last_name;
      });

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(40),
          child: SingleChildScrollView(
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
                const CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      AssetImage("assets/images/person/girl-asia2.jpg"),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _firstnameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      print("user_id = " + user.id.toString());
                      updateUserProfile(
                          user.id.toString(),
                          _usernameController.text.toString(),
                          _emailController.text.toString(),
                          _firstnameController.text.toString(),
                          _lastnameController.text.toString());
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent),
                    child: const Text(
                      "ยืนยันแก้ไข",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
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
