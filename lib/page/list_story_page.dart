import 'package:flutter/material.dart';
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
    return SafeArea(child: Scaffold(
      body: Consumer<GetAllStoriesProvider>(builder: (context, provider, child) {
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
              return Row(
                children: [
                  Image.network(story.photoUrl, width: 100, height: 100, fit: BoxFit.cover),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(story.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(story.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    ));
  }
}