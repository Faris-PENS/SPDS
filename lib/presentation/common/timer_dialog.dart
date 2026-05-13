import 'package:flutter/material.dart';

class TimerDialog {
  static Future<void> timerdialog({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color iconColor,

    required int durasi,
    Duration? duration,
    VoidCallback? onClosed,
  }) async {
    duration ??= Duration(seconds: durasi);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 48),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await Future.delayed(duration);

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      onClosed?.call();
    }
  }
}
