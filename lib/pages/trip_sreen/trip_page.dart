import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:plantrip_traveler/pages/trip_sreen/trip_create_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

List iconImageName = [
  "ธรรมชาติ",
  "วัฒนธรรม",
  "ที่นอน",
  "คาเฟ",
  "ร้านอาหาร",
];

List iconImage = [
  "assets/images/nature.png",
  "assets/images/culture.png",
  "assets/images/bed.png",
  "assets/images/cafe.png",
  "assets/images/restaurant.png",
];

final List<String> province_udonthani = <String>[
  "เมืองอุดรธานี",
  "กุดจับ",
  "หนองวัวซอ",
  "กุมภวาปี",
  "โนนสะอาด",
  "หนองหาน",
  "ทุ่งฝน",
  "ไชยวาน",
  "ศรีธาตุ",
  "วังสามหมอ",
  "บ้านดุง",
  "บ้านผือ",
  "น้ำโสม",
  "เพ็ญ",
  "สร้างคอม",
  "หนองแสง",
  "นายูง",
  "พิบูลย์รักษ์",
  "กู่แก้ว",
  "ประจักษ์ศิลปาคม",
];

var height, width;

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class _TripPageState extends State<TripPage> {
  String startPoint = "เมืองอุดรธานี";
  String endPoint = "เมืองอุดรธานี";
  String dropdownValueProviceStart = "";
  String dropdownValueProviceEnd = "";

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
          child: ListView(
            children: [
              // Head Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'จัดทริป',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'ทริปนี้ไปที่ไหนดี?',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              // Button to show list อำเภอ
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Place Start
                      DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          showSelectedItems: true,
                          disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        items: province_udonthani,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "เดินทางจาก...",
                            hintText: "เลือกตำแหน่งต้นทาง",
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueProviceStart = newValue!;
                            startPoint = dropdownValueProviceStart;
                            print(dropdownValueProviceStart);
                          });
                        },
                        selectedItem: dropdownValueProviceStart,
                      ),

                      // Place End
                      DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          showSelectedItems: true,
                          disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        items: province_udonthani,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "จุดหมายที่จะไป...",
                            hintText: "เลือกตำแหน่งปลายทาง",
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValueProviceEnd = newValue!;
                            endPoint = dropdownValueProviceEnd;
                            print(dropdownValueProviceEnd);
                          });
                        },
                        selectedItem: dropdownValueProviceEnd,
                      ),
                    ]),
              ),

              // Create Trip Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00a5dc),
                      foregroundColor: Colors.white,
                      minimumSize: Size(100, 40)),
                  onPressed: () async {
                    final SharedPreferences prefs = await _prefs;
                    prefs.setString("start_position", dropdownValueProviceStart);
                    prefs.setString("end_position", dropdownValueProviceEnd);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TripCreatePage(),
                          settings: RouteSettings()),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "เริ่มจัดทริป",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              // Icon category
              SizedBox(
                height: height * 0.08,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: iconImage.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          print(iconImageName[index]);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: height * 0.068,
                            width: width * 0.14,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xfff0f0f0),
                            ),
                            child: Center(
                                child: Column(
                              children: [
                                Image(
                                  height: height * 0.04,
                                  image: AssetImage(iconImage[index]),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  iconImageName[index],
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            )),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
