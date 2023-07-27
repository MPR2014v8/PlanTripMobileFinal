import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantrip_traveler/model/user_model.dart';
import 'package:plantrip_traveler/pages/user_screen/user_profile_page.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => UserPageState();
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

late String user_token = "";
late String email = "";
late String username = "";
late String firstName = "";
late String lastName = "";
var user;

class UserPageState extends State<UserPage> {
  void loadUser() async {
    final SharedPreferences prefs = await _prefs;

    try {
      final temp = prefs.getString("username");
      username = temp ?? "not_found";

      Response response = await get(
        Uri.parse(
            'https://plantrip-final-f854bbde88de.herokuapp.com/user/$username'),
      );

      if (response.statusCode == 200) {
        setState(() {
          final temp = jsonDecode(response.body.toString());
          final value = User.fromJson(temp[0]);

          if (value != null) {
            setState(() {
              user = value;
              username = user.username;
            });
          }

          print("user_log: Fetch User Success!!!");
        });
      } else {
        print("user_log: User not found.");
      }
    } catch (e) {
      print("user_error_log:" + e.toString());
    }
  }

  void logout() async {
    final SharedPreferences prefs = await _prefs;

    try {
      final temp = prefs.getString("user_token");
      user_token = temp ?? "not_found";

      Response response = await post(
          Uri.parse(
              'https://plantrip-final-f854bbde88de.herokuapp.com/logout/'),
          headers: {'Authorization': 'Token ' + user_token});
      prefs.clear();
      print("Logout Success!!!");

      setState(() {
        Restart.restartApp();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget userTitle() {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage("assets/images/person/girl-asia2.jpg"),
      ),
      title: Text(
        ("Hi, $username"),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "Traveler",
      ),
    );
  }

  Widget diverder() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  Widget colorTitles() {
    return Column(
      children: [
        colorTitle(Icons.list_outlined, Colors.blue, "จัดการทริป"),
        colorTitle(Icons.payment_outlined, Colors.pink, "จัดการบทความ"),
        colorTitle(Icons.qr_code, Colors.orange, "ช่องทางการชำระ"),
      ],
    );
  }

  Widget colorTitle(IconData icon, Color color, String text,
      {bool blackAndWhite = false}) {
    return ListTile(
      leading: Container(
        child: Icon(
          icon,
          color: color,
        ),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: blackAndWhite
                ? const Color(0xfff3f4fe)
                : color.withOpacity(0.09),
            borderRadius: BorderRadius.circular(18)),
      ),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  Widget bwTitles() {
    return Column(
      children: [
        bwTitle(Icons.settings, "ตั้งค่าแอพพลิเคชั่น"),
        bwTitle(Icons.help, "คำถามที่พบบ่อย"),
        bwTitle(Icons.textsms_outlined, "ติดต่อเรา"),
      ],
    );
  }

  Widget bwTitle(IconData icon, String text) {
    return colorTitle(icon, Colors.black, text, blackAndWhite: true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return Scaffold(
          body: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              userTitle(),
              diverder(),
              ListTile(
                leading: Container(
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.deepPurple,
                  ),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xfff3f4fe),
                      borderRadius: BorderRadius.circular(18)),
                ),
                title: const Text(
                  "จัดการโปรไฟล์",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfilePage(),
                          settings: RouteSettings(arguments: username)),
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                  color: Colors.black,
                  iconSize: 24,
                ),
              ),
              colorTitles(),
              diverder(),
              bwTitles(),
              ListTile(
                onTap: () {
                  setState(() {
                    logout();
                  });
                },
                leading: Container(
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.redAccent,
                  ),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: const Color(0xfff3f4fe),
                      borderRadius: BorderRadius.circular(18)),
                ),
                title: Text(
                  "ออกจากระบบ",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.redAccent,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ));
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
