import 'package:go_router/go_router.dart';
import 'package:intermediate_project/page/login_page.dart';
import 'package:intermediate_project/page/register_page.dart';

GoRouter myRouter = GoRouter(
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
  ],
);