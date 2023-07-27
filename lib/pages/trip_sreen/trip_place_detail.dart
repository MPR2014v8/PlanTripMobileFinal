import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantrip_traveler/pages/home_screen/home_page.dart';

class TripPlaceDetail extends StatefulWidget {
  const TripPlaceDetail({super.key});

  @override
  State<TripPlaceDetail> createState() => _TripPlaceDetailState();
}


class _TripPlaceDetailState extends State<TripPlaceDetail> {
  void appTrip(String name, String detail, String position_start,
      String position_end, String budget, String userId) async {
    final response = await http.post(
      Uri.parse('https://plantrip-final-f854bbde88de.herokuapp.com/trip-all/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'detail': detail,
        'position_start': position_start,
        'position_end': position_end,
        'budget': budget,
        'user': userId,
      }),
    );

    if (response.statusCode == 201) {

      //addTripPlaceDetail();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade800,
          content: const Text(
            'บันทึกการทริปแล้ว.',
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
            'บันทึกทริปไม่สำเร็จ',
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

  void addTripPlaceDetail(String placeId, String tripId) async {
    final response = await http.post(
      Uri.parse('https://plantrip-final-f854bbde88de.herokuapp.com/trip-all/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'place': placeId,
        'trip': tripId,
      }),
    );

    if (response.statusCode == 201) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade800,
          content: const Text(
            'บันทึกการสถานที่ทริปแล้ว.',
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
            'บันทึกสถานที่ทริปไม่สำเร็จ',
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

  @override
  Widget build(BuildContext context) {
    final cartItem = ModalRoute.of(context)?.settings.arguments as Set?;
    if (cartItem != null) {
      print(cartItem);
      return Scaffold(
        body: ListView.builder(
            itemCount: cartItem.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("PlaceId: " + cartItem.elementAt(index)),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // cartPlaceId
            // appTrip();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route route) => false);
          },
          child: Text("สถานที่ที่เลือก"),
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
