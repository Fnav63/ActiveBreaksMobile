import 'package:flutter/material.dart';

class ActiveBreak {
  final String title;
  final String description;
  final List<String> instructions;
  final int durationSeconds;
  final String imagePath;
  final String category;

  const ActiveBreak({
    required this.title,
    required this.description,
    required this.instructions,
    required this.durationSeconds,
    required this.imagePath,
    required this.category,
  });

  String get formattedDuration {
    if (durationSeconds < 60) return '$durationSeconds segundos';
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    return s == 0 ? '$m min' : '$m min $s seg';
  }

  IconData get icon {
    switch (category) {
      case 'Cuello':
        return Icons.accessibility_new;
      case 'Hombros':
        return Icons.fitness_center;
      case 'Espalda':
        return Icons.self_improvement;
      case 'Visual':
        return Icons.visibility;
      case 'Muñecas':
        return Icons.pan_tool;
      default:
        return Icons.directions_walk;
    }
  }
}