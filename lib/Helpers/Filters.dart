class Filters {
  bool isPhysical;
  bool isComputer;
  double lat;
  double lng;
  String startDate;
  String endDate;
  double distance;
  String address;
  Filters.fromJson(Map<String, dynamic> json)
      : isPhysical = json['isPhysical'],
        isComputer = json['isComputer'],
        lat = json['lat'],
        lng = json['lng'],
        distance = json['distance'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        address = json['address'];
  Filters(
      {this.isPhysical,
      this.isComputer,
      this.lat,
      this.lng,
      this.distance,
      this.startDate,
      this.endDate,
      this.address});
  Map<String, dynamic> toJson() => {
        'isPhysical': isPhysical,
        'isComputer': isComputer,
        'lat': lat,
        'lng': lng,
        'distance': distance,
        'startDate': startDate,
        'endDate': endDate,
        'address': address,
      };
}
