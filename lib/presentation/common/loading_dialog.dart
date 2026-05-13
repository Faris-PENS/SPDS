import 'package:flutter/material.dart';
import 'package:spds/core/style/colors.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, required this.bgColor});

  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showLoadingDialog(
  BuildContext context, {
  Color bgColor = AppColors.grey800,
  Color? barrierColor = Colors.transparent,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: barrierColor,
    builder: (_) => LoadingDialog(bgColor: bgColor),
  );
}
