import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda y Acerca de'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('¿Qué es Active Breaks?', colors),
            _sectionText(
              'Active Breaks es una aplicación móvil diseñada para promover el bienestar físico durante la jornada laboral o de estudio, mediante la realización de pausas activas simples y guiadas.',
              colors,
            ),

            const SizedBox(height: 20),

            _sectionTitle('¿Cómo usar la aplicación?', colors),
            _sectionText(
              'Desde la pantalla principal, el usuario puede acceder a una lista de pausas activas. '
              'Cada pausa incluye una breve descripción, duración o repeticiones sugeridas, y una imagen de referencia.',
              colors,
            ),

            const SizedBox(height: 20),

            _sectionTitle('¿Por qué realizar pausas activas?', colors),
            _sectionText(
              'Las pausas activas ayudan a reducir la tensión muscular, mejorar la postura y prevenir molestias físicas '
              'asociadas a largas horas frente al computador, contribuyendo a una mejor salud y productividad.',
              colors,
            ),

            const SizedBox(height: 30),

            _sectionTitle('Autor', colors),
            _sectionText(
              'Proyecto desarrollado por:\n'
              'Franko Navarrete\n'
              'Programación para dispositivos móviles\n'
              '2026',
              colors,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, ColorScheme colors) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colors.onSurface,
      ),
    );
  }

  Widget _sectionText(String text, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: colors.onSurface,
          height: 1.4,
        ),
      ),
    );
  }
}