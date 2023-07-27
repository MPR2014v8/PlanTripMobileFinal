import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

final TextEditingController _usernameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _password2Controller = TextEditingController();

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

Widget _buildEmailInput() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "อีเมล",
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
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top: 14.0),
            prefixIcon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            hintText: "ระบุอีเมลผู้ใช้ของคุณ",
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

Widget _buildPassword2Input() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "รหัสผ่าน-อีกครั้ง",
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
          controller: _password2Controller,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top: 14.0),
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.white,
            ),
            hintText: "ระบุรหัสผ่านของคุณอีกครั้ง",
            hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey.shade300),
          ),
        ),
      ),
    ],
  );
}

class RegisterPageState extends State<RegisterPage> {

  Future<bool> register(
      String username, String email, String password, String password2) async {

    final SharedPreferences prefs = await _prefs;

    try {
      Response response = await post(
          Uri.parse(
              'https://plantrip-final-f854bbde88de.herokuapp.com/register/'),
          body: {
            'username': username,
            'email': email,
            'password': password,
            'password2': password2,
          });

      if (response.statusCode == 201) {

        var data = jsonDecode(response.body.toString());
        print('log_satus: Register successfully.');
        return true;
        
      } else {
        print('log_satus: Register failed');
      }
    } catch (e) {
      print("error_Register : " + e.toString());
      return false;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildEmailInput(),
                  const SizedBox(height: 10),
                  _buildPasswordInput(),
                  const SizedBox(height: 10),
                  _buildPassword2Input(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      ConstrainedBox(
                          constraints: const BoxConstraints(
                              minWidth: double.infinity, minHeight: 50),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                            ),
                            onPressed: () {
                              setState(() async {
                                final resiterResult = await register(
                                  _usernameController.text.toString(), 
                                  _emailController.text.toString(), 
                                  _passwordController.text.toString(), 
                                  _password2Controller.text.toString());

                                if (!resiterResult) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.redAccent,
                                    content: const Text(
                                      'สมัครเข้าใช้งานไม่สำหรับ. กรุณาตรวจสอบ',
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

                                Navigator.of(context).pop();
                              }
                                  
                                // Navigator.pop(context);
                              });
                            },
                            child: const Text(
                              'ยืนยันการสมัครใช้งาน',
                              style: TextStyle(fontSize: 18),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
