import 'package:go_router/go_router.dart';
import 'package:intermediate_project/page/detail_story_page.dart';
import 'package:intermediate_project/page/list_story_page.dart';
import 'package:intermediate_project/page/login_page.dart';
import 'package:intermediate_project/page/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRouter myRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    
    final bool loggedIn = token != null && token.isNotEmpty;
    final bool isLoggingIn = state.matchedLocation == '/';
    final bool isRegistering = state.matchedLocation == '/register';
    
    if (!loggedIn) {
      return isLoggingIn || isRegistering ? null : '/';
    }

    if (loggedIn && (isLoggingIn || isRegistering)) {
      return '/list_story';
    }
    if(isRegistering){
      return '/register';
    }else if(isLoggingIn){
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/list_story',
      name: 'list_story',
      builder: (context, state) => const ListStoryPage(),
    ),
    GoRoute(
      path: '/detail_story/:id',
      name: 'detail_story',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailStoryPage(storyId: id);
      },
    ),
  ],
);
