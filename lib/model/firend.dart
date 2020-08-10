import 'package:json_annotation/json_annotation.dart';

part 'firend.g.dart';

@JsonSerializable(nullable: false)
class Friend {
  final int id;
  final String uid;
  final String location;
  final String locationCode;
  final String email;
  final String name;
  final String age;
  final String introduce;

  Friend({
    this.id,
    this.uid,
    this.location,
    this.locationCode,
    this.email,
    this.name,
    this.age,
    this.introduce,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
