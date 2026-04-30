import 'package:flutter/material.dart';

class AppDialog {
 
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String message,
    required bool isForover,
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
              Icon(
               Icons.error_outline,
                color: Colors.red ,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (!isForover) {
      await Future.delayed(duration);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        onClosed?.call();
      }
    }
  }
}
