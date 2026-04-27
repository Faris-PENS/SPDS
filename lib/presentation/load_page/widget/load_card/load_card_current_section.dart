import 'package:flutter/material.dart';

class LoadCardCurrentSection extends StatelessWidget {
  final double arus;
  final int maxAmps;

  const LoadCardCurrentSection({
    super.key,
    required this.arus,
    required this.maxAmps,
  });

  @override
  Widget build(BuildContext context) {
    final invalidMax = maxAmps <= 0;
    final percent = invalidMax ? 0.0 : (arus / maxAmps);
    final clamped = percent.clamp(0.0, 1.0);

    final Color color;
    if (invalidMax) {
      color = Colors.grey;
    } else if (clamped <= 0.5) {
      color = const Color(0xFF1DD51D);
    } else if (clamped <= 0.8) {
      color = Colors.amber;
    } else {
      color = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ARUS: ${arus.toStringAsFixed(1)} A / $maxAmps A',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: 12,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
