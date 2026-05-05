import 'package:flutter/material.dart';
import 'breaks_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Breaks'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.self_improvement,
                  size: 100,
                  color: colors.onSurface,
                ),
                const SizedBox(height: 20),
                Text(
                  'Bienvenido a Active Breaks',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Garantizando su bienestar con pausas activas.',
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BreaksListScreen(),
                      ),
                    );
                  },
                  child: const Text('Ver Pausas Activas'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}