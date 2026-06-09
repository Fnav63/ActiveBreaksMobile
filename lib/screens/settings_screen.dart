import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion'),
      ),
      body: Padding(
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
                    fontSize: 16,
                    color: colors.onSurface,
                  ),
                ),
                Switch(
                  value: vm.notifEnabled,
                  onChanged: (val) => vm.toggleNotifications(val),
                  activeThumbColor: colors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Recordar cada:',
              style: TextStyle(
                fontSize: 16,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: vm.notifIntervalMinutes,
              dropdownColor: colors.surface,
              style: TextStyle(color: colors.onSurface),
              items: ProfileViewModel.intervalOptions
                  .map((m) => DropdownMenuItem(
                        value: m,
                        child: Text('$m minutos'),
                      ))
                  .toList(),
              onChanged: vm.notifEnabled
                  ? (val) {
                      if (val != null) vm.setNotifInterval(val);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}