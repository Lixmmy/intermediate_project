import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story extends Equatable {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final String createdAt;
  final double? lat;
  final double? lon;

  const Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return _$StoryFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$StoryToJson(this);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    photoUrl,
    createdAt,
    lat,
    lon,
  ];
}
