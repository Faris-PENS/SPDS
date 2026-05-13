import 'package:flutter/material.dart';

class CurrentSummary extends StatelessWidget {
  final double totalCurrent;
  final String averageCurrent;
  final double averageLoad;

  const CurrentSummary({
    super.key,
    required this.totalCurrent,
    required this.averageCurrent,
    required this.averageLoad,
  });

  Widget _summaryCard({
    required String title,
    required String value,
    double fontSize = 26,
  }) {
    return Container(
      // width: 12
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(25, 24, 24, 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: _summaryCard(
              title: 'Total Current',
              value: '${totalCurrent.toStringAsFixed(0)} A',
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: _summaryCard(
              title: 'Status',
              value: '$averageCurrent',
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: _summaryCard(
              title: 'Average Amps',
              value: '${averageLoad.toStringAsFixed(0)} A',
            ),
          ),
        ],
      ),
    );
  }
}
