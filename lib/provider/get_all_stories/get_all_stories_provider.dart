import 'package:flutter/material.dart';
import 'package:intermediate_project/provider/get_all_stories/get_all_stories_state.dart';
import 'package:intermediate_project/service/api_service.dart';

class GetAllStoriesProvider extends ChangeNotifier {
  final ApiService apiService;
  GetAllStoriesProvider(this.apiService);

  GetAllStoriesState _state = GetAllStoriesInitialState();
  GetAllStoriesState get state => _state;

  Future<void> fetchAllStories() async {
    try {
      _state = GetAllStoriesLoadingState();
      notifyListeners();
      final response = await apiService.getAllStories();
      if (!response.error) {
        _state = GetAllStoriesSuccessState(response.message, response.stories);
      } else {
        _state = GetAllStoriesErrorState(response.message);
      }
    } catch (e) {
      _state = GetAllStoriesErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }
}