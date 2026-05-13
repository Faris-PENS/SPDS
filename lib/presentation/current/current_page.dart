import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spds/presentation/current/provider/provider.dart';
import 'package:spds/presentation/current/widget/current_sumarry.dart';
import 'package:spds/presentation/current/widget/phase_summary.dart';
import 'package:spds/presentation/header/header.dart';

class CurrentPage extends ConsumerStatefulWidget {
  const CurrentPage({super.key});

  @override
  ConsumerState<CurrentPage> createState() => _CurrentPageState();
}

class _CurrentPageState extends ConsumerState<CurrentPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(maxArusProvider.notifier).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final phases = ref.watch(phaseCurrentProvider);
    final isBalanceable = ref.watch(balanceableProvider);
    final maxMap = ref.watch(maxArusProvider);

    final values = phases.map((e) => e.arus).toList();

    final totalCurrent = values.isEmpty ? 0.0 : values.reduce((a, b) => a + b);

    final averageLoad = values.isEmpty
        ? 0.0
        : (totalCurrent / values.length / 100) * 100;

    final statusText = isBalanceable ? 'Unbalance' : 'Balance';

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Column(
        children: [
          const HeaderWidget(),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    spacing: 5,
                    runSpacing: 8,
                    children: phases.map((item) {
                      final maxAmp = maxMap[item.phase] ?? 1;

                      return CurrentCard(
                        phase: item.phase,
                        ampere: item.arus,
                        maxAmpere: maxAmp,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 5),
                  CurrentSummary(
                    totalCurrent: totalCurrent,
                    averageLoad: averageLoad,
                    averageCurrent: statusText,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
