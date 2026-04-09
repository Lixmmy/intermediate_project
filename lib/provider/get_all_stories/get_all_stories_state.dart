import 'package:intermediate_project/model/story.dart';

sealed class GetAllStoriesState {}

class GetAllStoriesInitialState extends GetAllStoriesState {}

class GetAllStoriesLoadingState extends GetAllStoriesState {}

class GetAllStoriesSuccessState extends GetAllStoriesState {
  final String message;
  final List<Story> stories;
  GetAllStoriesSuccessState(this.message, this.stories);
}

class GetAllStoriesErrorState extends GetAllStoriesState {
  final String errorMessage;
  GetAllStoriesErrorState(this.errorMessage);
}