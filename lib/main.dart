// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sobrius_app/viewmodels/auth_viewmodel.dart';
import 'package:sobrius_app/pages/login_page.dart';
import 'package:sobrius_app/pages/signup_page.dart';
import 'package:sobrius_app/pages/home_page.dart';
import 'package:sobrius_app/features/profile_repository.dart';
import 'package:sobrius_app/services/profile_service.dart';
import 'package:sobrius_app/viewmodels/profile_viewmodel.dart';
import 'package:sobrius_app/pages/create_profile_page.dart';
import 'package:sobrius_app/pages/calendar_page.dart';
import 'package:sobrius_app/services/relapse_service.dart';
import 'package:sobrius_app/features/relapse_repository.dart';
import 'package:sobrius_app/viewmodels/relapse_viewmodel.dart';
import 'package:sobrius_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Erro ao inicializar Firebase: $e');
  }

  final profileService = ProfileService();
  final profileRepository = ProfileRepository(service: profileService);
  final relapseService = RelapseService();
  final relapseRepository = RelapseRepository(service: relapseService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(profileRepository),
        ),
        ChangeNotifierProxyProvider<AuthViewModel, ProfileViewModel>(
          create: (context) => ProfileViewModel(
            profileRepository,
            FirebaseAuth.instance.currentUser?.uid ?? '',
          ),
          update: (context, authViewModel, previousProfileViewModel) {
            final userId = authViewModel.currentUser?.uid ?? '';
            if (previousProfileViewModel?.currentUserId != userId) {
              return ProfileViewModel(
                profileRepository,
                userId,
              );
            }
            return previousProfileViewModel!;
          },
        ),
        ChangeNotifierProxyProvider<AuthViewModel, RelapseViewModel>(
          create: (context) => RelapseViewModel(
            relapseRepository,
            FirebaseAuth.instance.currentUser?.uid ?? '',
          ),
          update: (context, authViewModel, previousRelapseViewModel) {
            final userId = authViewModel.currentUser?.uid ?? '';
            if (previousRelapseViewModel?.currentUserId != userId) {
              return RelapseViewModel(
                relapseRepository,
                userId,
              );
            }
            return previousRelapseViewModel!;
          },
        ),
      ],
      child: const MainApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

        await authViewModel.authReady;

        final loggedIn = authViewModel.isAuthenticated;
        final loggingIn = state.uri.path == '/login' || state.uri.path == '/signup';

        if (!loggedIn && !loggingIn) {
          return '/login';
        }

        if (loggedIn && loggingIn) {
          final profileExists = await authViewModel.doesProfileExist();
          if (profileExists) {
            return '/home';
          }
          return '/create_profile';
        }

        return null;
      },
      builder: (context, state) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/create_profile',
      builder: (context, state) => const CreateProfilePage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarPage(),
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        primaryColor: const Color(0xFF4A90E2),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A90E2)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
