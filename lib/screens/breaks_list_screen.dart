import 'package:flutter/material.dart';
import '../models/active_break.dart';
import 'break_detail_screen.dart';

class BreaksListScreen extends StatelessWidget {
  const BreaksListScreen({super.key});

  // Lista de pausas activas (maqueta)
  static const List<ActiveBreak> breaks = [
    ActiveBreak(
      title: 'Estiramiento de cuello',
      description:
          'Ayuda a reducir la tensión acumulada en el cuello por largas horas frente al computador.',
      duration: '30 segundos',
      imagePath: 'assets/images/neck_stretch.jpg',
      icon: Icons.accessibility_new,
    ),
    ActiveBreak(
      title: 'Pausa para hombros',
      description:
          'Ejercicio suave para relajar los hombros y mejorar la postura.',
      duration: '10 repeticiones',
      imagePath: 'assets/images/shoulder_pause.jpg',
      icon: Icons.accessibility_new,
    ),
    ActiveBreak(
      title: 'Relajación de espalda',
      description:
          'Movimiento controlado para aliviar la tensión en la zona lumbar.',
      duration: '45 segundos',
      imagePath: 'assets/images/back_relax2.png',
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
            activeBreak: item,
          );
        },
      ),
    );
  }
}

class _BreakItem extends StatelessWidget {
  final ActiveBreak activeBreak;

  const _BreakItem({
    required this.activeBreak,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        activeBreak.icon,
        color: Colors.green,
      ),
      title: Text(
        activeBreak.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white54,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BreakDetailScreen(activeBreak: activeBreak),
          ),
        );
      },
    );
  }
}