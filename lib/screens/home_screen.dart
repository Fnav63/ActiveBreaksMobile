import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProfileViewModel>().refreshHistory();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final profile = context.watch<ProfileViewModel>();

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
                  profile.hasProfile
                      ? 'Bienvenido, ${profile.userName}'
                      : 'Bienvenido a Active Breaks',
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
                const SizedBox(height: 8),
                Text(
                  'Pausas completadas: ${profile.totalBreaksCount}',
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/breaks');
                  },
                  child: const Text('Ver Pausas Activas'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const Text('Perfil'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
                  child: const Text('Historial'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: const Text('Configuracion'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/beta-testing');
                  },
                  child: const Text('Evaluar la App'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/about');
                  },
                  child: const Text('Ayuda y Acerca de'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}