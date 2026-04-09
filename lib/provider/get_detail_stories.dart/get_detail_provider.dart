import 'package:flutter/material.dart';
import 'package:intermediate_project/provider/get_detail_stories.dart/get_detaill_state.dart';
import 'package:intermediate_project/service/api_service.dart';

class GetDetailProvider extends ChangeNotifier {
  final ApiService apiService;
  GetDetailProvider(this.apiService);
  GetDetaillState _state = GetDetaillInitialState();
  GetDetaillState get state => _state;

  Future<void> fetchDetailStory(String id) async {
    try {
      _state = GetDetaillLoadingState();
      notifyListeners();
      final response = await apiService.getDetailStory(id);
      if (response.error == 'false') {
        _state = GetDetaillSuccessState(response.message, response.story);
        notifyListeners();
      } else {
        _state = GetDetaillErrorState(response.message);
        notifyListeners();
      }
    } catch (e) {
      _state = GetDetaillErrorState(e.toString());
    }
  }
}
