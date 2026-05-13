import 'package:flutter/material.dart';

class LoadCardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String location;
  final String subtit;
  final String assetNum;
  final bool isOn;
  final bool isActive;
  final ValueChanged<bool> onToggle;

  const LoadCardHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.location,
    required this.subtit,
    required this.assetNum,
    required this.isOn,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 45, color: Colors.white),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title - $location',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$subtit\n$assetNum',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        Switch(value: isOn, onChanged: isActive ? onToggle : null),
      ],
    );
  }
}
