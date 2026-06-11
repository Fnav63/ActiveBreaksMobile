class BetaQuestion {
  final String titulo;
  final String min;
  final String max;
  int valor;

  BetaQuestion({
    required this.titulo,
    required this.min,
    required this.max,
    this.valor = 0,
  });

  factory BetaQuestion.fromJson(Map<String, dynamic> json) {
    return BetaQuestion(
      titulo: json['titulo'] as String,
      min: json['min'] as String,
      max: json['max'] as String,
      valor: json['valor'] as int? ?? 0,
    );
  }
}

class BetaCategory {
  final String nombre;
  final List<BetaQuestion> preguntas;

  BetaCategory({
    required this.nombre,
    required this.preguntas,
  });

  factory BetaCategory.fromJson(Map<String, dynamic> json) {
    return BetaCategory(
      nombre: json['nombre'] as String,
      preguntas: (json['preguntas'] as List)
          .map((q) => BetaQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}