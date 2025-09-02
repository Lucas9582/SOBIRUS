// lib/features/home/presentation/pages/home_page.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Importado para usar o Timer
import 'package:sobrius_app/viewmodels/auth_viewmodel.dart';
import 'package:sobrius_app/viewmodels/profile_viewmodel.dart';
import 'package:sobrius_app/viewmodels/relapse_viewmodel.dart'; // Importado para registrar recaídas
//import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer; // Variável para o timer

  @override
  void initState() {
    super.initState();
    // Inicia a busca pelo perfil assim que o widget é construído
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      // Assegura que o perfil é carregado ao entrar na página
      if (profileViewModel.currentProfile == null) {
        profileViewModel.fetchProfile();
      }
    });

    // Inicia um timer que atualiza o estado a cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // A chamada a setState() aqui força a reconstrução do widget e a atualização do timer
      });
    });
  }

  // É fundamental cancelar o timer quando o widget é descartado para evitar vazamento de memória
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _calculateDuration(DateTime startDate) {
    final now = DateTime.now();
    final difference = now.difference(startDate);
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobrius'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.signOut();
              if (!context.mounted) return;
              context.go('/');
            },
          ),
        ],
      ),
      body: profileViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProfileCard(context, profileViewModel),
                    const SizedBox(height: 30),
                    _buildQuickActions(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileCard(BuildContext context, ProfileViewModel viewModel) {
    final profile = viewModel.currentProfile;
    final username = profile?.username ?? 'Usuário';
    final bio = profile?.bio ?? 'Sua biografia ainda não foi definida.';
    final avatarUrl = profile?.avatarUrl;

    final sobrietyDuration = profile?.sobrietyStartDate != null
        ? _calculateDuration(profile!.sobrietyStartDate!)
        : null;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) as ImageProvider<Object>? : null,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: avatarUrl == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
            ),
            const SizedBox(height: 15),
            Text(
              'Bem-vindo(a), $username!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              bio,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (sobrietyDuration != null)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Seu tempo de sobriedade:',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        sobrietyDuration,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Text(
          'Funcionalidades',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildActionCard(
              context,
              icon: Icons.calendar_month,
              label: 'Calendário',
              onTap: () {
                context.go('/calendar');
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.analytics,
              label: 'Relatórios',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidade de Relatórios em desenvolvimento!')),
                );
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.person,
              label: 'Editar Perfil',
              onTap: () {
                context.go('/create_profile');
              },
            ),
            _buildActionCard(
              context,
              icon: Icons.group,
              label: 'Comunidade',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidade de Comunidade em desenvolvimento!')),
                );
              },
            ),
            _buildRelapseButton(context), // Novo botão de recaída
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelapseButton(BuildContext context) {
    final relapseViewModel = Provider.of<RelapseViewModel>(context, listen: false);
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);

    return Card(
      color: Colors.red.shade400,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () async {
          // Lógica para registrar uma nova recaída
          try {
            await relapseViewModel.addRelapse();
            await profileViewModel.resetSobrietyStartDate();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Recaída registrada e timer resetado!'),
                backgroundColor: Colors.red,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Falha ao registrar recaída: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, size: 50, color: Colors.white),
            SizedBox(height: 8),
            Text(
              'Registrar Recaída',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
