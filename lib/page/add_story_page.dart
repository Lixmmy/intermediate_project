import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:intermediate_project/provider/add_story/add_story_provider.dart';
import 'package:intermediate_project/provider/add_story/add_story_state.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final TextEditingController _descriptionController = TextEditingController();
  List<int>? _selectedFileBytes;
  String? _selectedFileName;

  // Variabel Lokasi
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;
  final Location _locationService = Location();

  @override
  void dispose() {
    _descriptionController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // Fungsi mengambil lokasi saat ini
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Cek apakah GPS aktif
    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) return;
    }

    // Cek izin lokasi
    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Ambil data lokasi
    final locationData = await _locationService.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {
      _selectedLocation = latLng;
    });

    // Geser kamera peta ke lokasi baru
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 15),
    );
  }

  void _onPickImage() async {
    final provider = context.read<AddStoryProvider>();
    final result = await provider.pickImage(context);

    if (result != null) {
      setState(() {
        _selectedFileBytes = result['bytes'];
        _selectedFileName = result['fileName'];
      });
    }
  }

  void _onUpload() async {
    if (_selectedFileBytes == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi deskripsi dan pilih gambar dulu!")),
      );
      return;
    }

    // Mengambil nilai lat/lon jika ada
    double? lat = _selectedLocation?.latitude;
    double? lon = _selectedLocation?.longitude;

    await context.read<AddStoryProvider>().addStory(
          _descriptionController.text,
          _selectedFileBytes!,
          _selectedFileName!,
          lat: lat,
          lon: lon,
        );

    if (!mounted) return;
    final state = context.read<AddStoryProvider>().state;
    if (state is AddStorySuccessState) {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Story")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Gambar
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _selectedFileBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        Uint8List.fromList(_selectedFileBytes!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(child: Text("No Image Selected")),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _onPickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pilih Gambar"),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Deskripsi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: "Tulis deskripsi cerita Anda...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // BAGIAN LOKASI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Lokasi (Opsional)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text("Gunakan GPS"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-6.200000, 106.816666), // Jakarta default
                    zoom: 10,
                  ),
                  onTap: (LatLng location) {
                    setState(() {
                      _selectedLocation = location;
                    });
                  },
                  markers: _selectedLocation == null
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId("selected-location"),
                            position: _selectedLocation!,
                          ),
                        },
                ),
              ),
            ),
            if (_selectedLocation != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Koordinat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),

            const SizedBox(height: 30),

            // Tombol Kirim
            Consumer<AddStoryProvider>(
              builder: (context, provider, child) {
                if (provider.state is AddStoryLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _onUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "UPLOAD CERITA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
