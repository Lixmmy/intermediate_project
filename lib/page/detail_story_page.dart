import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetDetailProvider>().fetchDetailStory(widget.id);
    });
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
                      Container(height: 24, width: 200, color: Colors.grey[300]),
                      const SizedBox(height: 4),
                      Container(height: 16, width: 150, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Container(height: 20, width: 100, color: Colors.grey[300]),
                      const SizedBox(height: 8),
                      Container(
                        height: 16,
                        width: double.infinity,
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
                      Divider(color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        "Deskripsi:",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '\t${story.description}',
                        style: const TextStyle(fontSize: 16),
                      ),
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
