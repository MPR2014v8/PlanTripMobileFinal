class BusinessPlace {
  final int id;
  final String name;
  final String detaill;
  final String district;
  final String lat;
  final String lng;
  final String address;
  final String timeOpen;
  final String timeClose;
  final String website;
  final String pic_link1;
  final String pic_link2;
  final String pic_link3;
  final int type;
  final int place_user;

  BusinessPlace({
    required this.id,
    required this.name,
    required this.detaill,
    required this.district,
    required this.lat,
    required this.lng,
    required this.address,
    required this.timeOpen,
    required this.timeClose,
    required this.website,
    required this.pic_link1,
    required this.pic_link2,
    required this.pic_link3,
    required this.type,
    required this.place_user,
  });

  BusinessPlace.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? 0,
      name = json['name'] ?? "",
      detaill = json['detaill'] ?? "",
      district = json['district'] ?? "",
      lat = json['lat'] ?? "",
      lng = json['lng'] ?? "",
      address = json['address'] ?? "",
      timeOpen = json['timeOpen'] ?? "",
      timeClose = json['timeClose'] ?? "",
      website = json['website'] ?? "",
      pic_link1 = json['pic_link1'] ?? "",
      pic_link2 = json['pic_link2'] ?? "",
      pic_link3 = json['pic_link3'] ?? "",
      type = json['type'] ?? 0,
      place_user = json['place_user'] ?? 0;
}
