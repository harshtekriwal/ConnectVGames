class Filters {
  bool isPhysical;
  bool isComputer;
  double lat;
  double lng;
  String gameDate;
  double distance;
  String address;
  Filters.fromJson(Map<String, dynamic> json)
      : isPhysical = json['isPhysical'],
        isComputer = json['isComputer'],
        lat = json['lat'],
        lng = json['lng'],
        distance = json['distance'],
        gameDate = json['gameDate'],
        address = json['address'];
  Filters(
      {this.isPhysical,
      this.isComputer,
      this.lat,
      this.lng,
      this.distance,
      this.gameDate,
      this.address});
  Map<String, dynamic> toJson() => {
        'isPhysical': isPhysical,
        'isComputer': isComputer,
        'lat': lat,
        'lng': lng,
        'distance': distance,
        'gameDate': gameDate,
        'address': address,
      };
}
