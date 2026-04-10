import 'package:intermediate_project/model/story.dart';

sealed class GetDetailState {}

class GetDetailInitialState extends GetDetailState {}

class GetDetailLoadingState extends GetDetailState {}

class GetDetailSuccessState extends GetDetailState {
  final String message;
  final Story story;
  GetDetailSuccessState(this.message, this.story);
}

class GetDetailErrorState extends GetDetailState {
  final String errorMessage;
  GetDetailErrorState(this.errorMessage);
}
