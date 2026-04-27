import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int page;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black,
        // border: Border.all(color: Colors.white),
        border: const Border(top: BorderSide(color: Colors.white,width: 0.5)),        // borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            icon: Icons.home_outlined,
            label: 'Home',
            active: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          if (page == 1)
            _navItem(
              icon: Icons.pie_chart_outline,
              label: 'Analytics',
              active: currentIndex == 1,
              onTap: () => onTap(1),
            )
          else
            _navItem(
              icon: Icons.person,
              label: 'Profile',
              active: currentIndex == 1,
              onTap: () => onTap(1),
            ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final color = active ? Colors.blue : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40, ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 3,
            width: active ? 30 : 0,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
