import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _editing = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final vm = context.watch<ProfileViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit),
            onPressed: () async {
              if (_editing) {
                await vm.saveUserName(_nameController.text);
              } else {
                _nameController.text = vm.userName;
              }
              setState(() => _editing = !_editing);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    CircleAvatar(
                      radius: 50,
                      backgroundColor: colors.primary,
                      child: Text(
                        vm.hasProfile ? vm.userName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    if (_editing)
                      TextField(
                        controller: _nameController,
                        autofocus: true,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Nombre',
                          hintStyle: TextStyle(
                              color: colors.onSurface.withAlpha(102)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.primary),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: colors.secondary, width: 2),
                          ),
                        ),
                      )
                    else
                      Text(
                        vm.hasProfile ? vm.userName : 'Sin nombre',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),

                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: vm.userRole.isEmpty ? null : vm.userRole,
                      hint: Text(
                        'Selecciona tu rol',
                        style: TextStyle(color: colors.onSurface.withAlpha(153)),
                      ),
                      dropdownColor: colors.surface,
                      style: TextStyle(color: colors.onSurface),
                      items: ProfileViewModel.roleOptions
                          .map((r) => DropdownMenuItem(
                                value: r,
                                child: Text(r),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) vm.saveUserRole(val);
                      },
                    ),

                    const SizedBox(height: 30),

                    _profileInfo(
                      label: 'Pausas completadas',
                      value: '${vm.totalBreaksCount}',
                      colors: colors,
                    ),

                    _profileInfo(
                      label: 'Frecuencia recomendada',
                      value: '1 pausa activa cada 60 minutos',
                      colors: colors,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileInfo({
    required String label,
    required String value,
    required ColorScheme colors,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: colors.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}