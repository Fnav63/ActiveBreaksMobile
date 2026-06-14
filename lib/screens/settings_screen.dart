import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/preferences_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreferencesViewModel>().loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final profileVm = context.watch<ProfileViewModel>();
    final prefVm = context.watch<PreferencesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notificaciones',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Activar recordatorios',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.onSurface,
                    ),
                  ),
                  Switch(
                    value: profileVm.notifEnabled,
                    onChanged: (val) => profileVm.toggleNotifications(val),
                    activeThumbColor: colors.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButton<int>(
                value: profileVm.notifIntervalMinutes,
                dropdownColor: colors.surface,
                style: TextStyle(color: colors.onSurface),
                items: ProfileViewModel.intervalOptions
                    .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text('$m minutos'),
                        ))
                    .toList(),
                onChanged: profileVm.notifEnabled
                    ? (val) {
                        if (val != null) profileVm.setNotifInterval(val);
                      }
                    : null,
              ),
              const SizedBox(height: 32),
              Text(
                'Mis Preferencias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Selecciona las categorias que te interesan',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.onSurface.withAlpha(179),
                ),
              ),
              const SizedBox(height: 16),
              ...PreferencesViewModel.allCategories.map((category) {
                final isSelected = prefVm.selectedCategories.contains(category);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => prefVm.toggleCategory(category),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : colors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? colors.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSelected
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isSelected
                                ? Colors.white
                                : colors.onSurface.withAlpha(128),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}