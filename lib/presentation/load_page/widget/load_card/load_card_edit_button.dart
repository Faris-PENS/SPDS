import 'package:flutter/material.dart';

class LoadCardEditButton extends StatelessWidget {
  final VoidCallback onRename;

  const LoadCardEditButton({
    super.key,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        fixedSize: const Size(140, 50),
      ),
      onPressed: onRename,
      child: const Text(
        'Edit Load',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
