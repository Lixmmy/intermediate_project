// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_stories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllStoriesResponse _$GetAllStoriesResponseFromJson(
  Map<String, dynamic> json,
) => GetAllStoriesResponse(
  error: json['error'] as bool,
  message: json['message'] as String,
  stories: (json['listStory'] as List<dynamic>)
      .map((e) => Story.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetAllStoriesResponseToJson(
  GetAllStoriesResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'message': instance.message,
  'listStory': instance.stories,
};
