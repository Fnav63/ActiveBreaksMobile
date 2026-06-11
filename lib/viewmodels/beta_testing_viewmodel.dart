import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/beta_question.dart';

/// ViewModel para la gestión del instrumento de Beta Testing.
/// Carga las preguntas desde el JSON, gestiona las respuestas
/// y genera el contenido del correo de envío.
class BetaTestingViewModel extends ChangeNotifier {
  List<BetaCategory> _categories = [];
  bool _isLoading = true;
  bool _submitted = false;
  String _userType = '';

  List<BetaCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get submitted => _submitted;
  String get userType => _userType;

  static const List<String> userTypeOptions = [
    'Participante de la iniciativa',
    'Conocedor de la industria',
    'Externo a la industria',
  ];

  bool get allAnswered =>
      _userType.isNotEmpty &&
      _categories.every(
        (cat) => cat.preguntas.every((q) => q.valor > 0),
      );

  Future<void> loadQuestions() async {
    _isLoading = true;
    notifyListeners();

    final jsonString =
        await rootBundle.loadString('assets/data/beta_testing.json');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    _categories = (jsonData['categorias'] as List)
        .map((c) => BetaCategory.fromJson(c as Map<String, dynamic>))
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  void setUserType(String type) {
    _userType = type;
    notifyListeners();
  }

  void setAnswer(BetaCategory category, BetaQuestion question, int valor) {
    question.valor = valor;
    notifyListeners();
  }

  void reset() {
    for (final cat in _categories) {
      for (final q in cat.preguntas) {
        q.valor = 0;
      }
    }
    _userType = '';
    _submitted = false;
    notifyListeners();
  }

  String generateEmailBody() {
    final buffer = StringBuffer();
    buffer.writeln('Resultados Beta Testing - ActiveBreaks');
    buffer.writeln('======================================');
    buffer.writeln('Tipo de usuario: $_userType');
    buffer.writeln();

    for (final cat in _categories) {
      buffer.writeln('[ ${cat.nombre} ]');
      for (final q in cat.preguntas) {
        buffer.writeln(q.titulo);
        buffer.writeln('Respuesta: ${q.valor} / 5 estrellas');
        buffer.writeln();
      }
    }

    final total = _categories
        .expand((cat) => cat.preguntas)
        .map((q) => q.valor)
        .reduce((a, b) => a + b);
    final count = _categories.expand((cat) => cat.preguntas).length;

    buffer.writeln('======================================');
    buffer.writeln(
        'Promedio general: ${(total / count).toStringAsFixed(1)} / 5');

    return buffer.toString();
  }
}