import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intermediate_project/provider/get_detail_stories.dart/get_detail_provider.dart';
import 'package:intermediate_project/provider/get_detail_stories.dart/get_detail_state.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailStoryPage extends StatefulWidget {
  final String id;
  const DetailStoryPage({super.key, required this.id});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {
  late GoogleMapController mapController;
  String? _address;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetDetailProvider>().fetchDetailStory(widget.id);
    });
  }

  Future<void> _getAddress(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        });
      }
    } catch (e) {
      setState(() {
        _address = "Gagal memuat alamat";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Detail Story'),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Consumer<GetDetailProvider>(
            builder: (context, provider, child) {
              final state = provider.state;
              if (state is GetDetailLoadingState) {
                return Skeletonizer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 24,
                        width: 200,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 16,
                        width: 150,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 20,
                        width: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width * 0.9,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                );
              } else if (state is GetDetailErrorState) {
                return Center(child: Text(state.errorMessage));
              } else if (state is GetDetailSuccessState) {
                final story = state.story;
                final String waktu = story.createdAt;
                DateTime dateTime = DateTime.parse(waktu);
                String formatDateTime =
                    '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';

                if (story.lat != null && story.lon != null && _address == null) {
                  _getAddress(story.lat!, story.lon!);
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: story.id,
                        child: Image.network(
                          story.photoUrl,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        story.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatDateTime,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        "Deskripsi:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\t${story.description}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      (story.lat != null && story.lon != null)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Lokasi:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_address != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      _address!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height: 300,
                                  child: GoogleMap(
                                    markers: {
                                      Marker(
                                        markerId: MarkerId(widget.id),
                                        position: LatLng(
                                          story.lat!,
                                          story.lon!,
                                        ),
                                        onTap: () {
                                          mapController.animateCamera(
                                            CameraUpdate.newLatLngZoom(
                                              LatLng(story.lat!, story.lon!),
                                              12,
                                            ),
                                          );
                                        },
                                      ),
                                    },
                                    initialCameraPosition: CameraPosition(
                                      zoom: 12,
                                      target: LatLng(story.lat!, story.lon!),
                                    ),
                                    onMapCreated: (controller) {
                                      setState(() {
                                        mapController = controller;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          : const Icon(Icons.location_off),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
