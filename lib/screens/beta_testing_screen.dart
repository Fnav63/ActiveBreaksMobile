import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/beta_testing_viewmodel.dart';
import '../models/beta_question.dart';

class BetaTestingScreen extends StatefulWidget {
  const BetaTestingScreen({super.key});

  @override
  State<BetaTestingScreen> createState() => _BetaTestingScreenState();
}

class _BetaTestingScreenState extends State<BetaTestingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BetaTestingViewModel>().loadQuestions();
    });
  }

  Future<void> _sendEmail(BuildContext context, BetaTestingViewModel vm) async {
    final body = vm.generateEmailBody();
    final uri = Uri(
      scheme: 'mailto',
      path: 'fnavarrete20@alumnos.utalca.cl',
      query: 'subject=${Uri.encodeComponent('Beta Testing ActiveBreaks')}&body=${Uri.encodeComponent(body)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontro una app de correo configurada.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final vm = context.watch<BetaTestingViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluar la App'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Su opinion nos ayuda a mejorar. '
                'Por favor responda todas las preguntas y envie sus resultados.',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.onSurface.withAlpha(179),
                ),
              ),
              const SizedBox(height: 24),
              ...vm.categories.map((cat) => _CategorySection(
                    category: cat,
                    colors: colors,
                    vm: vm,
                  )),
              
              DropdownButtonFormField<String>(
                initialValue: vm.userType.isEmpty ? null : vm.userType,
                hint: Text(
                  'Selecciona tu tipo de usuario',
                  style: TextStyle(color: colors.onSurface.withAlpha(153)),
                ),
                dropdownColor: colors.surface,
                style: TextStyle(color: colors.onSurface),
                items: BetaTestingViewModel.userTypeOptions
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) vm.setUserType(val);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: vm.allAnswered
                      ? () => _sendEmail(context, vm)
                      : null,
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Enviar por correo'),
                ),
              ),

              if (!vm.allAnswered) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Responda todas las preguntas para enviar.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurface.withAlpha(128),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: vm.reset,
                  child: const Text('Reiniciar respuestas'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final dynamic category;
  final ColorScheme colors;
  final BetaTestingViewModel vm;

  const _CategorySection({
    required this.category,
    required this.colors,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.nombre,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        ...category.preguntas.map<Widget>((q) => _QuestionCard(
              question: q,
              colors: colors,
              onRating: (val) => vm.setAnswer(category, q, val),
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final BetaQuestion question;
  final ColorScheme colors;
  final void Function(int) onRating;

  const _QuestionCard({
    required this.question,
    required this.colors,
    required this.onRating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.titulo,
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              question.min,
              style: TextStyle(
                fontSize: 11,
                color: colors.onSurface.withAlpha(128),
              ),
            ),
            Text(
              question.max,
              style: TextStyle(
                fontSize: 11,
                color: colors.onSurface.withAlpha(128),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final starValue = i + 1;
                return IconButton(
                  onPressed: () => onRating(starValue),
                  icon: Icon(
                    starValue <= question.valor
                        ? Icons.star
                        : Icons.star_border,
                    color: starValue <= question.valor
                        ? Colors.amber
                        : colors.onSurface.withAlpha(128),
                    size: 32,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}