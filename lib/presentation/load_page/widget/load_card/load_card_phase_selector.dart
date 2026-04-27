import 'package:flutter/material.dart';

class LoadCardPhaseSelector extends StatelessWidget {
  final String? activePhase;
  final ValueChanged<String> onPhaseChanged;

  const LoadCardPhaseSelector({
    super.key,
    required this.activePhase,
    required this.onPhaseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['R', 'S', 'T', 'U'].map((phase) {
        final isSelected = activePhase?.toUpperCase() == phase;

        return InkWell(
          onTap: () => onPhaseChanged(phase),
          child: Container(
            width: 75,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1DD51D) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(),
            ),
            child: Text(
              phase,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
