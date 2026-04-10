import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intermediate_project/page/detail_story_page.dart';
import 'package:intermediate_project/provider/get_all_stories/get_all_stories_provider.dart';
import 'package:intermediate_project/provider/get_all_stories/get_all_stories_state.dart';
import 'package:provider/provider.dart';

class ListStoryPage extends StatefulWidget {
  const ListStoryPage({super.key});

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetAllStoriesProvider>().fetchAllStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<GetAllStoriesProvider>(
          builder: (context, provider, child) {
            final state = provider.state;

            if (state is GetAllStoriesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetAllStoriesErrorState) {
              return Center(child: Text(state.errorMessage));
            } else if (state is GetAllStoriesSuccessState) {
              final stories = state.stories;
              return ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  final String waktu = story.createdAt;
                  DateTime dateTime = DateTime.parse(waktu);
                  String formatDateTime =
                      '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
                  return InkWell(
                    onTap: () {
                      context.pushNamed(
                        'detail_story',
                        pathParameters: {'id': story.id},
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: story.id,
                            child: Image.network(
                              story.photoUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            story.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(story.description),
                          const SizedBox(height: 5),
                          Text(formatDateTime),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
