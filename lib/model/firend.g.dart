// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend(
    id: json['id'] == null ? '' : json['id'] as int,
    uid: json['uid'] == null ? '' :  json['uid'] as String,
    location: json['location'] == null ? '' :  json['location'] as String,
    locationCode: json['locationCode'] == null ? '' :  json['locationCode'] as String,
    email: json['email'] == null ? '' :  json['email'] as String,
    name: json['name'] == null ? '' :  json['name'] as String,
    age: json['age'] == null ? '' :  json['age'] as String,
    introduce: json['introduce'] == null ? '' :  json['introduce'] as String,
  );
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'location': instance.location,
      'locationCode': instance.locationCode,
      'email': instance.email,
      'name': instance.name,
      'age': instance.age,
      'introduce': instance.introduce,
    };
