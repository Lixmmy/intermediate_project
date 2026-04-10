import 'package:flutter/material.dart';
import 'package:intermediate_project/provider/get_detail_stories.dart/get_detail_provider.dart';
import 'package:intermediate_project/provider/get_detail_stories.dart/get_detaill_state.dart';
import 'package:provider/provider.dart';

class DetailStoryPage extends StatefulWidget {
  final String storyId;
  const DetailStoryPage({super.key, required this.storyId});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetDetailProvider>().fetchDetailStory(widget.storyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Consumer<GetDetailProvider>(
        builder: (context, provider, child) {
          final state = provider.state;

          if (state is GetDetaillLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetDetaillErrorState) {
            return Center(child: Text(state.errorMessage));
          } else if (state is GetDetaillSuccessState) {
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
                  Text(
                    story.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(formatDateTime, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Image.network(story.photoUrl),
                  const SizedBox(height: 16),
                  Text(story.description, style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    ),);
  }
}