import 'package:flutter/material.dart';


class CurrentCard extends StatelessWidget {
  final String phase;
  final double ampere;
  final double maxAmpere;

  const CurrentCard({
    super.key,
    required this.phase,
    required this.ampere,
    required this.maxAmpere,
  });

 double get loadPercent {
  if (maxAmpere <= 0) return 0;
  return (ampere / maxAmpere) * 100;
}
  String get status {
    if (loadPercent <= 50) return 'Normal';
    if (loadPercent <= 70) return 'Medium Load';
    return 'High Load';
  }

  Color get statusColor {
    if (loadPercent <= 50) return Colors.green;
    if (loadPercent <= 70) return Colors.orange;
    return Colors.red;
  }

  Color get progressColor {
    if (loadPercent <= 50) return Colors.green;
    if (loadPercent <= 70) return Colors.orange;
    return Colors.red;
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(25, 24, 24, 1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.flash_on, color: progressColor, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                phase == 'UPS' ? 'UPS' : 'Phase $phase',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Center(
            child: Column(
              children: [
                Text(
                  ampere.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
                const Text(
                  'Amperes',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white  )),
              const SizedBox(width: 6),
              Text(
                '${loadPercent.toStringAsFixed(1)} %',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                ' / ${maxAmpere.toStringAsFixed(0)} A',
                style: const TextStyle(color: Colors.white,),
              )
            ],
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: loadPercent / 100,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}