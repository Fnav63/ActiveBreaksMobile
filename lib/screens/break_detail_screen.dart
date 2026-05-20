import 'package:flutter/material.dart';
import '../models/active_break.dart';
import '../controllers/break_timer_controller.dart';

class BreakDetailScreen extends StatefulWidget {
  final ActiveBreak activeBreak;

  const BreakDetailScreen({
    super.key,
    required this.activeBreak,
  });

  @override
  State<BreakDetailScreen> createState() => _BreakDetailScreenState();
}

class _BreakDetailScreenState extends State<BreakDetailScreen> {
  late BreakTimerController _timerController;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();

    _remainingSeconds = widget.activeBreak.durationSeconds;

    _timerController = BreakTimerController(
      totalSeconds: _remainingSeconds,
      onTick: (seconds) {
        setState(() {
          _remainingSeconds = seconds;
        });
      },
      onFinished: _showFinishedDialog,
    );
  }

  @override
  void dispose() {
    _timerController.stop();
    super.dispose();
  }

  void _showFinishedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pausa completada'),
        content: const Text(
          'Has finalizado la pausa activa. ¡Buen trabajo!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remaining.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activeBreak.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset(
              widget.activeBreak.imagePath,
              height: 200,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 16),

            Text(
              widget.activeBreak.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_timerController.isRunning && !_timerController.isPaused)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _timerController.start();
                      });
                    },
                    child: const Text('Iniciar'),
                  ),

                if (_timerController.isPaused)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _timerController.start(); // reanuda
                      });
                    },
                    child: const Text('Reanudar'),
                  ),

                if (_timerController.isRunning)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _timerController.pause();
                      });
                    },
                    child: const Text('Pausar'),
                  ),

                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _timerController.reset(
                        widget.activeBreak.durationSeconds,
                      );
                    });
                  },
                  child: const Text('Reiniciar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}