import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/breaks_viewmodel.dart';
import '../viewmodels/timer_viewmodel.dart';
import '../models/active_break.dart';

class BreaksListScreen extends StatelessWidget {
  const BreaksListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BreaksViewModel>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pausas Activas')),
      body: SafeArea(
        child: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: vm.categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = vm.categories[i];
                final selected = vm.selectedCategory == cat;
                return GestureDetector(
                  onTap: () => vm.filterByCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? colors.primary : colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? colors.primary
                            : Colors.white.withAlpha(38),
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.breaks.length,
              itemBuilder: (context, index) {
                return _BreakCard(activeBreak: vm.breaks[index]);
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _BreakCard extends StatelessWidget {
  final ActiveBreak activeBreak;
  const _BreakCard({required this.activeBreak});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2633),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.primary.withAlpha(38),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(activeBreak.icon, color: colors.secondary),
        ),
        title: Text(
          activeBreak.title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              activeBreak.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white.withAlpha(153), fontSize: 12),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.timer, size: 13, color: colors.tertiary),
                const SizedBox(width: 4),
                Text(
                  activeBreak.formattedDuration,
                  style: TextStyle(
                      color: colors.tertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.primary.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    activeBreak.category,
                    style: TextStyle(
                        color: colors.secondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right,
            color: Colors.white.withAlpha(128)),
        onTap: () {
          context.read<TimerViewModel>().loadBreak(activeBreak);
          Navigator.pushNamed(context, '/break-detail');
        },
      ),
    );
  }
}