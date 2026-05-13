import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'load_card/load_card_current_section.dart';
import 'load_card/load_card_edit_button.dart';
import 'load_card/load_card_header.dart';
import 'load_card/load_card_phase_selector.dart';

class LoadCard extends StatelessWidget {
  final String subtit;
  final String assetNum;
  final int deviceType;
  final String location;
  final bool isOn;
  final bool isActive;
  final String? activePhase;
  final double arus;
  final int maxAmps;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onPhaseChanged;
  final VoidCallback onRename;

  const LoadCard({
    super.key,
    required this.subtit,
    required this.assetNum,
    required this.deviceType,
    required this.location,
    required this.isOn,
    required this.isActive,
    required this.activePhase,
    required this.onToggle,
    required this.onPhaseChanged,
    required this.onRename,
    required this.arus,
    required this.maxAmps,
  });

  IconData get icon {
    switch (deviceType) {
      case 1:
        return Icons.lightbulb;
      case 2:
        return Icons.ac_unit;
      case 3:
        return Icons.power;
      case 4:
        return Symbols.water_pump;
      case 5:
        return Icons.kitchen;
      default:
        return Icons.electric_bolt;
    }
  }

  String get title {
    switch (deviceType) {
      case 1:
        return 'Lampu';
      case 2:
        return 'AC';
      case 3:
        return 'Stop Kontak';
      case 4:
        return 'Pompa';
      case 5:
        return 'Kulkas';
      default:
        return 'Load';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(25, 24, 24, 1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          LoadCardHeader(
            icon: icon,
            title: title,
            location: location,
            subtit: subtit,
            assetNum: assetNum,
            isOn: isOn,
            isActive: isActive,
            onToggle: onToggle,
          ),

          const SizedBox(height: 10),

          LoadCardCurrentSection( arus: arus, maxAmps: maxAmps),

          const SizedBox(height: 10),

          LoadCardPhaseSelector(
            activePhase: activePhase,
            onPhaseChanged: onPhaseChanged,
          ),

          const SizedBox(height: 12),

          LoadCardEditButton(onRename: onRename),
        ],
      ),
    );
  }
}
