import 'package:flutter/foundation.dart';
import '../models/active_break.dart';

class BreaksViewModel extends ChangeNotifier {

  final List<ActiveBreak> _breaks = const [
    ActiveBreak(
      title: 'Estiramiento de cuello',
      description:
          'Reduce la tensión acumulada en el cuello por largas horas frente al computador. '
          'Inclina suavemente la cabeza hacia cada lado y mantén la posición.',
      instructions: [
        'Siéntate erguido con los hombros relajados.',
        'Inclina la cabeza hacia la derecha, llevando la oreja al hombro.',
        'Mantén 15 segundos y regresa al centro.',
        'Repite hacia la izquierda.',
        'Realiza rotaciones lentas hacia adelante y atrás.',
      ],
      durationSeconds: 30,
      imagePath: 'assets/images/neck_stretch.jpg',
      category: 'Cuello',
    ),
    ActiveBreak(
      title: 'Pausa para hombros',
      description:
          'Ejercicio suave para relajar los hombros y mejorar la postura. '
          'Ideal para quienes pasan horas con el teclado.',
      instructions: [
        'De pie o sentado, relaja los brazos a los costados.',
        'Eleva ambos hombros hacia las orejas.',
        'Mantén 3 segundos y suelta bruscamente.',
        'Realiza círculos hacia adelante con los hombros.',
        'Repite los círculos hacia atrás.',
      ],
      durationSeconds: 45,
      imagePath: 'assets/images/shoulder_pause.jpg',
      category: 'Hombros',
    ),
    ActiveBreak(
      title: 'Relajación de espalda',
      description:
          'Movimiento controlado para aliviar la tensión en la zona lumbar. '
          'Perfecto para quienes trabajan sentados por períodos prolongados.',
      instructions: [
        'Siéntate al borde de la silla.',
        'Coloca las manos sobre las rodillas.',
        'Arquea la espalda hacia adelante (postura gato).',
        'Luego arquea hacia atrás abriendo el pecho.',
        'Alterna lentamente 5 veces.',
      ],
      durationSeconds: 45,
      imagePath: 'assets/images/back_relax2.png',
      category: 'Espalda',
    ),
    ActiveBreak(
      title: 'Descanso visual',
      description:
          'Técnica 20-20-20 para reducir la fatiga ocular causada por el uso '
          'prolongado de pantallas.',
      instructions: [
        'Aparta la vista de la pantalla.',
        'Enfoca un objeto a 6 metros de distancia.',
        'Mantén la vista ahí durante 20 segundos.',
        'Parpadea conscientemente varias veces.',
        'Repite cada 20 minutos de uso de pantalla.',
      ],
      durationSeconds: 20,
      imagePath: 'assets/images/neck_stretch.jpg',
      category: 'Visual',
    ),
    ActiveBreak(
      title: 'Estiramiento de muñecas',
      description:
          'Previene lesiones como el síndrome del túnel carpiano, muy común '
          'en personas que usan el teclado y mouse extensivamente.',
      instructions: [
        'Extiende un brazo hacia adelante con la palma hacia arriba.',
        'Con la otra mano, jala suavemente los dedos hacia abajo.',
        'Mantén 10 segundos y cambia de posición.',
        'Repite con la palma hacia abajo.',
        'Alterna ambas manos.',
      ],
      durationSeconds: 40,
      imagePath: 'assets/images/shoulder_pause.jpg',
      category: 'Muñecas',
    ),
  ];

  String _selectedCategory = 'Todas';

  List<ActiveBreak> get breaks => _selectedCategory == 'Todas'
      ? List.unmodifiable(_breaks)
      : _breaks.where((b) => b.category == _selectedCategory).toList();

  List<String> get categories => [
        'Todas',
        ..._breaks.map((b) => b.category).toSet(),
      ];

  String get selectedCategory => _selectedCategory;

  void filterByCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  ActiveBreak getBreakById(int index) => _breaks[index];
}