import 'dart:convert';

class HouseModel {
  final int? id;
  final String? lat;
  final String? let;
  final String? address;
  HouseModel({
    this.id,
    this.lat,
    this.let,
    this.address,
  });

  HouseModel copyWith({
    int? id,
    String? lat,
    String? let,
    String? address,
  }) {
    return HouseModel(
      id: id ?? this.id,
      lat: lat ?? this.lat,
      let: let ?? this.let,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'let': let,
      'address': address,
    };
  }

  factory HouseModel.fromMap(Map<String, dynamic> map) {
    return HouseModel(
      id: map['id']?.toInt(),
      lat: map['lat'],
      let: map['let'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HouseModel.fromJson(String source) =>
      HouseModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HouseModel(id: $id, lat: $lat, let: $let, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HouseModel &&
        other.id == id &&
        other.lat == lat &&
        other.let == let &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^ lat.hashCode ^ let.hashCode ^ address.hashCode;
  }
}
