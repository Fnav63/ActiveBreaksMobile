import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodels/timer_viewmodel.dart';

class BreakDetailScreen extends StatelessWidget {
  const BreakDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimerViewModel>();
    final colors = Theme.of(context).colorScheme;

    if (vm.currentBreak == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final activeBreak = vm.currentBreak!;

    return Scaffold(
      appBar: AppBar(
        title: Text(activeBreak.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Compartir pausa',
            onPressed: () {
              Share.share(
                'Realice la pausa activa "${activeBreak.title}" con ActiveBreaks. '
                'Duracion: ${activeBreak.formattedDuration}. '
                'Cuida tu bienestar con pausas activas.',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                activeBreak.imagePath,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeBreak.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withAlpha(204),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Instrucciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...activeBreak.instructions.asMap().entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${e.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              e.value,
                              style: TextStyle(
                                color: Colors.white.withAlpha(204),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 28),
                  Center(child: _TimerDisplay(vm: vm, colors: colors)),
                  const SizedBox(height: 24),
                  _TimerControls(vm: vm),

                  if (vm.isFinished) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.primary.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.primary),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.greenAccent),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Pausa completada. Se guardo en tu historial.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final TimerViewModel vm;
  final ColorScheme colors;
  const _TimerDisplay({required this.vm, required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: CircularProgressIndicator(
              value: vm.progress,
              strokeWidth: 8,
              backgroundColor: Colors.white.withAlpha(38),
              valueColor: AlwaysStoppedAnimation<Color>(
                vm.isFinished ? Colors.greenAccent : colors.tertiary,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vm.formattedTime,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                vm.isFinished
                    ? 'Completado'
                    : vm.isRunning
                        ? 'En curso'
                        : vm.isPaused
                            ? 'Pausado'
                            : 'Listo',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withAlpha(153),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerControls extends StatelessWidget {
  final TimerViewModel vm;
  const _TimerControls({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (vm.isIdle)
          ElevatedButton.icon(
            onPressed: vm.start,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Iniciar'),
          ),
        if (vm.isRunning)
          ElevatedButton.icon(
            onPressed: vm.pause,
            icon: const Icon(Icons.pause),
            label: const Text('Pausar'),
          ),
        if (vm.isPaused)
          ElevatedButton.icon(
            onPressed: vm.resume,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Reanudar'),
          ),
        if (!vm.isIdle) ...[
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: vm.reset,
            icon: const Icon(Icons.refresh, color: Colors.white70),
            label: const Text(
              'Reiniciar',
              style: TextStyle(color: Colors.white70),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withAlpha(77)),
            ),
          ),
        ],
      ],
    );
  }
}