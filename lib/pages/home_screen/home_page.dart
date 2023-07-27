import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:plantrip_traveler/pages/activity_screen/activity_page.dart';
import 'package:plantrip_traveler/pages/trip_sreen/trip_page.dart';
import 'package:plantrip_traveler/pages/user_screen/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class _HomePageState extends State<HomePage> {
  late String user_token = "";

  int index = 0;
  final List<Widget> pages = const [
    TripPage(),
    ActivityPage(),
    UserPage(),
  ];

  void loadUser() async {
    final SharedPreferences prefs = await _prefs;
    String? temp = prefs.getString("user_token");
    user_token = temp ?? "NOT_FOUND";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: pages[index],
        bottomNavigationBar: Container(
          color: const Color(0xffeff2f3),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20,
            ),
            child: GNav(
              backgroundColor: const Color(0xffeff2f3),
              activeColor: const Color(0xff4a8594),
              tabBackgroundColor: const Color(0xffdbe0e3),
              gap: 8,
              selectedIndex: index,
              // onTabChange: (index) => setState(() => this.index = index),
              onTabChange: (index) {
                setState(() {
                  this.index = index;
                });
              },
              padding: const EdgeInsets.all(14),
              tabs: const [
                GButton(
                  icon: FontAwesomeIcons.calendar,
                  text: "จัดทริป",
                ),
                GButton(
                  icon: Icons.search,
                  text: "ค้นหา",
                ),
                GButton(
                  icon: Icons.person_2,
                  text: "ผู้ใช้",
                ),

                // GButton(
                //   icon: FontAwesomeIcons.smile,
                //   text: "ทดสอบ",
                // ),
              ],
            ),
          ),
        ),
      );
}
