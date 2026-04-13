import 'package:flutter/material.dart';
import 'package:intermediate_project/model/story.dart';
import 'package:intermediate_project/provider/get_all_stories/get_all_stories_state.dart';
import 'package:intermediate_project/service/api_service.dart';

class GetAllStoriesProvider extends ChangeNotifier {
  final ApiService apiService;
  GetAllStoriesProvider(this.apiService);

  GetAllStoriesState _state = GetAllStoriesInitialState();
  GetAllStoriesState get state => _state;

  int? pageItems = 1;
  int sizeItems = 10;

  Future<void> fetchAllStories() async {
    try {
      if (pageItems == 1) {
        _state = GetAllStoriesLoadingState();
        notifyListeners();
      }

      if (pageItems == null) return;

      apiService.page = pageItems;
      apiService.size = sizeItems;

      final response = await apiService.getAllStories();

      List<Story> currentStories = [];
      if (_state is GetAllStoriesSuccessState && pageItems! > 1) {
        currentStories = List.from((_state as GetAllStoriesSuccessState).stories);
      }

      currentStories.addAll(response.stories);

      if (response.stories.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }

      _state = GetAllStoriesSuccessState(response.message, currentStories);
      notifyListeners();
    } catch (e) {
      _state = GetAllStoriesErrorState(e.toString());
      notifyListeners();
    }
  }

  void resetPagination() {
    pageItems = 1;
  }
}
