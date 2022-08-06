class Model {
  double? latitude;
  double? longitude;

  Model({
    this.latitude,
    this.longitude,
  });

  Model.fromJson(dynamic json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    return map;
  }
}
