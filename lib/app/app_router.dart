// lib/app/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:sobrius_app/viewmodels/auth_viewmodel.dart';
import 'package:sobrius_app/pages/login_page.dart';
import 'package:sobrius_app/pages/signup_page.dart';
import 'package:sobrius_app/pages/welcome_page.dart';
import 'package:sobrius_app/pages/create_profile_page.dart';
import 'package:sobrius_app/pages/home_page.dart';
import 'package:provider/provider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomePage(),
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
  ],
  redirect: (context, state) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final bool loggedIn = authViewModel.currentUser != null;

    // Caminhos para as telas de autenticação/inicial
    final bool goingToAuthPages = state.matchedLocation == '/' ||
                                  state.matchedLocation == '/login' ||
                                  state.matchedLocation == '/signup';

    // Se o usuário NÃO está logado
    if (!loggedIn) {
      // Se está tentando acessar uma página de autenticação, permite
      // Caso contrário (tentando acessar /home ou /create_profile sem login), redireciona para a tela inicial
      return goingToAuthPages ? null : '/';
    }

    // Se o usuário ESTÁ logado
    if (loggedIn) {
      // Verifica se o perfil do usuário existe no Firestore
      final bool profileExists = await authViewModel.doesProfileExist();

      // Se o perfil NÃO existe e o usuário NÃO está na tela de criação de perfil, redireciona para lá
      if (!profileExists && state.matchedLocation != '/create_profile') {
        return '/create_profile';
      }

      // Se o perfil EXISTE e o usuário está em uma página de autenticação/inicial, redireciona para a home
      if (profileExists && goingToAuthPages) {
        return '/home';
      }
    }

    // Para todas as outras situações (usuário logado, perfil existe, e não está em página de auth/inicial),
    // ou usuário não logado mas em página de auth/inicial, permite a navegação normal.
    return null;
  },
);