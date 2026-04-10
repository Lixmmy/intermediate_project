import 'package:flutter/material.dart';
import 'package:intermediate_project/provider/add_story/add_story_provider.dart';
import 'package:intermediate_project/provider/get_all_stories/get_all_stories_provider.dart';
import 'package:intermediate_project/provider/get_detail_stories.dart/get_detail_provider.dart';
import 'package:intermediate_project/provider/login/login_provider.dart';
import 'package:intermediate_project/provider/register/register_provider.dart';
import 'package:intermediate_project/routes/my_router.dart';
import 'package:intermediate_project/service/api_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RegisterProvider(apiService: context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              GetAllStoriesProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => GetDetailProvider(context.read<ApiService>()),
        ),

        ChangeNotifierProvider(
          create: (context) => AddStoryProvider(context.read<ApiService>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      routerConfig: myRouter,
    );
  }
}
