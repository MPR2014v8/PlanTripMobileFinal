import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plantrip_traveler/pages/trip_sreen/trip_cart_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripCreatePage extends StatefulWidget {
  const TripCreatePage({super.key});

  @override
  State<TripCreatePage> createState() => _TripCreatePageState();
}

var _startpositionController = TextEditingController();
var _endpositionController = TextEditingController();
var _nameController = TextEditingController();
var _detailController = TextEditingController();
var _budgetController = TextEditingController();

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class _TripCreatePageState extends State<TripCreatePage> {
  void loadPostition() async {
    final SharedPreferences prefs = await _prefs;
    final temp1 = prefs.getString('start_position') ?? '';
    final temp2 = prefs.getString('end_position') ?? '';

    if (temp1 != null && temp2 != null) {
      setState(() {
        _startpositionController.text = temp1;
        _endpositionController.text = temp2;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPostition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  TextFormField(
                    readOnly: true,
                    controller: _startpositionController,
                    decoration: const InputDecoration(
                      labelText: 'เดินทางจาก',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: _endpositionController,
                    decoration: const InputDecoration(
                      labelText: 'จุดหมายที่จะไป',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'ชื่อทริป',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    maxLines: 5,
                    maxLength: 100,
                    controller: _detailController,
                    decoration: const InputDecoration(
                      labelText: 'หมายเหตุ',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _budgetController,
                    decoration: const InputDecoration(
                      labelText: 'งบประมาณ',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
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
                      onPressed: () async {
                        
                        final SharedPreferences prefs = await _prefs;

                        if (_startpositionController.text == "" ||
                            _endpositionController.text == "" ||
                            _nameController.text == "" ||
                            _detailController.text == "" ||
                            _budgetController == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green.shade800,
                              content: const Text(
                                'ยังไม่ได้กรอกข้อมูลที่สำคัญกรุณาตรวจสอบ.',
                                style: TextStyle(color: Colors.white),
                              ),
                              action: SnackBarAction(
                                label: 'ปิด',
                                onPressed: () {},
                              ),
                            ),
                          );
                        } else {
                          prefs.setString(
                              "start_position", _startpositionController.text);
                          prefs.setString(
                              "end_position", _endpositionController.text);
                          prefs.setString("name_trip", _nameController.text);
                          prefs.setString(
                              "detail_trip", _detailController.text);
                          prefs.setString(
                              "budget_trip", _budgetController.text);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TripCartPage(),
                                settings: RouteSettings()),
                          );
                        }
                      },
                      child: const Text(
                        'บันทึกข้อมูล',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
