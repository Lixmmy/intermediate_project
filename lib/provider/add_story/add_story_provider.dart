import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intermediate_project/provider/add_story/add_story_state.dart';
import 'package:intermediate_project/service/api_service.dart';
import 'package:permission_handler/permission_handler.dart';

class AddStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  AddStoryProvider(this.apiService);

  AddStoryState _state = AddStoryInitialState();
  AddStoryState get state => _state;

  Future<void> addStory(
    String description,
    List<int> photo,
    String fileName, {
    double? lat,
    double? lon,
  }) async {
    try {
      _state = AddStoryLoadingState();
      notifyListeners();
      final response = await apiService.addNewStoryWithAuth(
        description,
        photo,
        fileName,
        lat: lat?.toString(),
        lon: lon?.toString(),
      );
      if (!response.error) {
        _state = AddStorySuccessState(response.message);
      } else {
        _state = AddStoryErrorState(response.message);
      }
    } catch (e) {
      _state = AddStoryErrorState(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> pickImage(BuildContext context) async {
    try {
      bool hasPermission = await _checkPermission(context);
      if (!hasPermission) {
        return null;
      }

      ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();
        List<int> compressedBytes = await compressImage(imageBytes);

        // Kembalikan data untuk digunakan di UI
        return {'bytes': compressedBytes, 'fileName': pickedFile.name};
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
    return null;
  }

  Future<bool> _checkPermission(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.photos,
    ].request();
    bool hasPermission =
        statuses[Permission.photos]!.isGranted ||
        statuses[Permission.storage]!.isGranted;
    if (!hasPermission) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission denied. Please grant permission to access camera and photos.',
          ),
        ),
      );
    }
    return hasPermission;
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final Uint8List uint8Bytes = Uint8List.fromList(bytes);
    final img.Image image = img.decodeImage(uint8Bytes)!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      ///
      compressQuality -= 10;

      newByte = img.encodeJpg(image, quality: compressQuality);

      length = newByte.length;
    } while (length > 1000000);

    return newByte;
  }

}
