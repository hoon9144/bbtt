import 'package:json_annotation/json_annotation.dart';

part 'meeting.g.dart';

@JsonSerializable(nullable: false)
class Meeting {
  final int id;
  final int uId;
  final String uEmail;
  final String title;
  final String description;
  final String meetingLocation;
  final String category;
  final int ParticipantsCount;

  Meeting({this.id, this.uId, this.uEmail , this.title ,this.description, this.meetingLocation,this.category ,this.ParticipantsCount});
  factory Meeting.fromJson(Map<String, dynamic> json) => _$MeetingFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}