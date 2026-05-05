import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: Center(
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
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Marcos Faúndez',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Estudiante / Trabajador',
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 30),

                _profileInfo(
                  label: 'Objetivo',
                  value: 'Reducir el sedentarismo',
                  colors: colors,
                ),

                _profileInfo(
                  label: 'Frecuencia recomendada',
                  value: '1 pausa activa cada 60 minutos',
                  colors: colors,
                ),

                _profileInfo(
                  label: 'Estado',
                  value: 'Activo',
                  colors: colors,
                ),
              ],
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
              style: TextStyle(
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}