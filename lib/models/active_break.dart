import 'package:flutter/material.dart';

class ActiveBreak {
  final String title;
  final String description;
  final String duration;
  final String imagePath;
  final IconData icon;

  const ActiveBreak({
    required this.title,
    required this.description,
    required this.duration,
    required this.imagePath,
    required this.icon,
  });
}