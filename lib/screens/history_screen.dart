import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().refreshHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Pausas'),
        actions: [
          if (vm.completedBreaks.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Limpiar historial',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Limpiar historial'),
                    content: const Text(
                        '¿Estas seguro que deseas eliminar todo el historial?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await vm.clearHistory();
                }
              },
            ),
        ],
      ),
      body: SafeArea(
        child: vm.completedBreaks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: colors.onSurface.withAlpha(77),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay pausas completadas aun.',
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.completedBreaks.length,
              itemBuilder: (context, index) {
                final entry = vm.completedBreaks[index].split('|');
                final title = entry[0];
                final date = entry.length > 1
                    ? DateTime.tryParse(entry[1])
                    : null;

                return ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: colors.secondary,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(color: colors.onSurface),
                  ),
                  subtitle: date != null
                      ? Text(
                          '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: colors.onSurface.withAlpha(153),
                            fontSize: 12,
                          ),
                        )
                      : null,
                );
              },
            ),
      ),
    );
  }
}