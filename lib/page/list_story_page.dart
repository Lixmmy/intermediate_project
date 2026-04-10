import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intermediate_project/provider/get_all_stories/get_all_stories_provider.dart';
import 'package:intermediate_project/provider/get_all_stories/get_all_stories_state.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('List Story')),
        body: Consumer<GetAllStoriesProvider>(
          builder: (context, provider, child) {
            final state = provider.state;

            if (state is GetAllStoriesLoadingState) {
              return Skeletonizer(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 20,
                          width: 150,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 15,
                          width: double.infinity,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 15,
                          width: 100,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
              );
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
                      '${dateTime.day}/${dateTime.month}/${dateTime.year}\n${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
                  return InkWell(
                    onTap: () {
                      context.pushNamed(
                        'detail_story',
                        pathParameters: {'id': story.id},
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
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
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(formatDateTime),
                          ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final isUploaded = await context.pushNamed<bool>('add_story');

            // 2. Jika isUploaded bernilai true, maka refresh list
            if (isUploaded == true) {
              if (mounted) {
                // ignore: use_build_context_synchronously
                context.read<GetAllStoriesProvider>().fetchAllStories();
              }
            }
          },
          child: const Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}
