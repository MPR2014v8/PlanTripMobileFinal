import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:plantrip_traveler/pages/home_screen/home_page.dart';
import 'package:plantrip_traveler/pages/home_screen/register_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

bool isLoginStatus = false;

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void checkLogin() async {
    final SharedPreferences prefs = await _prefs;
    final temp1 = prefs.getString("username");
    final temp2 = prefs.getString("password");
    if (temp1 != null && temp1 != "") {
      if (temp2 != null && temp2 != "") {
        login(temp1, temp2);
      }
    }
  }

  Future<bool> login(String username, password) async {
    final SharedPreferences prefs = await _prefs;

    try {
      Response response = await post(
          Uri.parse('https://plantrip-final-f854bbde88de.herokuapp.com/login/'),
          body: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('log_satus: Login successfully.');

        setState(() {
          final value = data['token'];
          prefs.setString("user_token", value);
          prefs.setString("username", username);
          prefs.setString("password", password);
        });

        return true;
      } else {
        print('log_satus: Login failed');
      }
    } catch (e) {
      print("error_login : " + e.toString());
      return false;
    }

    return false;
  }

  Widget _buildUsernameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ชื่อผู้ใช้",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                5.0,
              ),
            ),
          ),
          height: 60,
          child: TextField(
            controller: _usernameController,
            keyboardType: TextInputType.name,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: "ระบุชื่อผู้ใช้ของคุณ",
              hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "รหัสผ่าน",
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(
                5.0,
              ),
            ),
          ),
          height: 60,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: "ระบุรหัสผ่านของคุณ",
              hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if (isLoginStatus == false) {
      
      return Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color.fromARGB(255, 68, 135, 216),
                  Color.fromARGB(255, 56, 133, 222),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              )),
            ),
            Container(
              height: double.infinity,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Plan Trip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'ทุกประสบการณ์รอให้คุณออกไปตามหา',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 100.0,
                    ),
                    _buildUsernameInput(),
                    const SizedBox(height: 10),
                    _buildPasswordInput(),
                    const SizedBox(height: 10),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                            constraints: const BoxConstraints(
                                minWidth: double.infinity, minHeight: 50),
                            child: ElevatedButton(
                              onPressed: () async {
                                bool loginResult = await login(
                                    _usernameController.text.toString(),
                                    _passwordController.text.toString());
                                if (!loginResult) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.redAccent,
                                      content: const Text(
                                        'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง. กรุณาตรวจสอบ',
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
                                      backgroundColor: Colors.green.shade800,
                                      content: const Text(
                                        'ยินดีต้อนรับ',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      action: SnackBarAction(
                                        label: 'ปิด',
                                        onPressed: () {},
                                      ),
                                    ),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()),
                                  );
                                }
                              },
                              child: const Text(
                                'ลงชื่อเข้าสู่ระบบ',
                                style: TextStyle(fontSize: 18),
                              ),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                              minWidth: double.infinity, minHeight: 50),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                              );
                            },
                            child: const Text(
                              'สมัครเข้าใช้งาน',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return HomePage();
    }
  }
}
