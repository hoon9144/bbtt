// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meeting _$MeetingFromJson(Map<String, dynamic> json) {
  return Meeting(
    id: json['id'] as int,
    uId: json['uId'] as int,
    uEmail: json['uEmail'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    meetingLocation: json['meetingLocation'] as String,
    category: json['category'] as String,
    ParticipantsCount: json['ParticipantsCount'] as int,
  );
}

Map<String, dynamic> _$MeetingToJson(Meeting instance) => <String, dynamic>{
      'id': instance.id,
      'uId': instance.uId,
      'uEmail': instance.uEmail,
      'title': instance.title,
      'description': instance.description,
      'meetingLocation': instance.meetingLocation,
      'category': instance.category,
      'ParticipantsCount': instance.ParticipantsCount,
    };
