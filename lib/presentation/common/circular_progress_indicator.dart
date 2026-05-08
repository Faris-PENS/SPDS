import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class EngganoCircularProgressIndicator extends StatefulWidget {
  const EngganoCircularProgressIndicator({
    super.key,
    this.color,
    this.size = 36,
    this.strokeWidth = 6,
  });

  final Color? color;
  final double size;
  final double strokeWidth;

  @override
  State<EngganoCircularProgressIndicator> createState() =>
      _EngganoCircularProgressIndicatorState();
}

class _EngganoCircularProgressIndicatorState
    extends State<EngganoCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController linearAnimationController;
  late Animation<double> linearAnimation;
  double animationValue = 0;

  @override
  void initState() {
    super.initState();
    linearAnimationController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    linearAnimation =
        CurvedAnimation(parent: linearAnimationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {
              animationValue = linearAnimation.value * 360;
            });
          });
    linearAnimationController.repeat();
  }
  
  @override
  void dispose() {
    linearAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: animationValue,
            endAngle: animationValue + 350,
            canScaleToFit: true,
            axisLineStyle: AxisLineStyle(
              thickness: widget.strokeWidth,
              cornerStyle: CornerStyle.endCurve,
              color: widget.color ?? Theme.of(context).primaryColor,
              gradient: SweepGradient(
                colors: <Color>[
                  Colors.transparent,
                  widget.color ?? Theme.of(context).primaryColor,
                ],
                stops: const <double>[0.1, 0.8],
              ),
              thicknessUnit: GaugeSizeUnit.logicalPixel,
            ),
          )
        ],
      ),
    );
  }
}
