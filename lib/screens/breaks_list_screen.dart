import 'package:flutter/material.dart';
import '../models/active_break.dart';

class BreaksListScreen extends StatelessWidget {
  const BreaksListScreen({super.key});

  static const List<ActiveBreak> breaks = [
    ActiveBreak(
      title: 'Estiramiento de cuello',
      icon: Icons.accessibility_new,
    ),
    ActiveBreak(
      title: 'Pausa para hombros',
      icon: Icons.accessibility_new,
    ),
    ActiveBreak(
      title: 'Relajación de espalda',
      icon: Icons.accessibility_new,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pausas Activas'),
      ),
      body: ListView.builder(
        itemCount: breaks.length,
        itemBuilder: (context, index) {
          final item = breaks[index];
          return _BreakItem(
            title: item.title,
            icon: item.icon,
          );
        },
      ),
    );
  }
}

class _BreakItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const _BreakItem({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.green,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white54,
      ),
    );
  }
}