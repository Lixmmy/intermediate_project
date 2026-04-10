import 'package:flutter/material.dart';
import 'package:intermediate_project/provider/get_detail_stories.dart/get_detail_state.dart';
import 'package:intermediate_project/service/api_service.dart';

class GetDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  GetDetailProvider(this.apiService);
  GetDetailState _state = GetDetailInitialState();
  GetDetailState get state => _state;

  Future<void> fetchDetailStory(String id) async {
    try {
      _state = GetDetailLoadingState();
      notifyListeners();
      final response = await apiService.getDetailStory(id);
      if (!response.error) {
        _state = GetDetailSuccessState(response.message, response.story);
        notifyListeners();
      } else {
        _state = GetDetailErrorState(response.message);
        notifyListeners();
      }
    } catch (e) {
      _state = GetDetailErrorState(e.toString());
    }
  }
}
