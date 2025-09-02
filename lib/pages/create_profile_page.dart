// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sobrius_app/viewmodels/profile_viewmodel.dart';
import 'package:sobrius_app/features/profile_form_field.dart';
import 'package:intl/intl.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
      // Carrega o perfil existente para edição, se houver
      if (profileViewModel.currentProfile == null) {
        profileViewModel.fetchProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Perfil'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, profileViewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: InkWell(
                    onTap: profileViewModel.pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                          backgroundImage: profileViewModel.pickedImage != null
                              ? FileImage(File(profileViewModel.pickedImage!.path)) as ImageProvider
                              : (profileViewModel.currentProfile?.avatarUrl != null
                                  ? NetworkImage(profileViewModel.currentProfile!.avatarUrl!) as ImageProvider
                                  : null),
                          child: profileViewModel.pickedImage == null && profileViewModel.currentProfile?.avatarUrl == null
                              ? const Icon(Icons.camera_alt, size: 50, color: Colors.white)
                              : null,
                        ),
                        if (profileViewModel.currentProfile?.avatarUrl != null && profileViewModel.pickedImage == null)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ProfileFormField(
                  labelText: 'Nome de Usuário',
                  initialValue: profileViewModel.username,
                  onChanged: profileViewModel.setUsername,
                  icon: Icons.person,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                ProfileFormField(
                  labelText: 'Biografia',
                  initialValue: profileViewModel.bio,
                  onChanged: profileViewModel.setBio,
                  icon: Icons.edit_note,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ProfileFormField(
                  labelText: 'Razão Pessoal',
                  initialValue: profileViewModel.personalReason,
                  onChanged: profileViewModel.setPersonalReason,
                  icon: Icons.description,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                _buildSobrietyDateSelector(context, profileViewModel),
                const SizedBox(height: 20),
                Text(
                  'Meus Vícios',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    'Álcool',
                    'Tabaco',
                    'Açúcar',
                    'Jogos',
                    'Outros',
                  ].map((vice) {
                    final isSelected = profileViewModel.selectedVices.contains(vice);
                    return FilterChip(
                      label: Text(vice),
                      selected: isSelected,
                      onSelected: (selected) {
                        profileViewModel.toggleVice(vice);
                      },
                      selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                if (profileViewModel.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton.icon(
                    onPressed: () async {
                      await profileViewModel.saveProfile();
                      if (profileViewModel.successMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(profileViewModel.successMessage!)),
                        );
                        if (!context.mounted) return;
                        context.go('/home');
                      } else if (profileViewModel.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(profileViewModel.errorMessage!)),
                        );
                      }
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Perfil'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSobrietyDateSelector(BuildContext context, ProfileViewModel profileViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Início da Jornada de Sobriedade',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: profileViewModel.sobrietyStartDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              profileViewModel.setSobrietyStartDate(pickedDate);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Selecione a Data',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(
              profileViewModel.sobrietyStartDate != null
                  ? DateFormat('dd/MM/yyyy').format(profileViewModel.sobrietyStartDate!)
                  : 'Nenhuma data selecionada',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
