import 'package:flutter/material.dart';
import 'package:spds/presentation/page_init/qr_page.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPage();
}

class _InitPage extends State<InitPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.black,
          // height: 700,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          // padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),

          child: Column(
            children: [
              const Text(
                "INIT DEVICE",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 18),
              Container(height: 1, color: Colors.white),
              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black),
                ),
              ),

              const SizedBox(height: 28),
              const Text(
                "Power Up the Device and wait untill blue\nindicator start flahsesup",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              // const SizedBox(height: 24),
              Spacer(),

              Row(
                children: [
                  Radio<bool>(
                    hoverColor: Colors.white,
                    activeColor: Colors.white,
                    focusColor: Colors.white,
                    fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    value: true,
                    groupValue: isChecked,
                    onChanged: (value) {
                      setState(() => isChecked = value!);
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Is Indicator flashes up?",
                      style: TextStyle(
                        fontSize: 18 ,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              Visibility(
                visible: isChecked,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E6FD9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QrScanPage(isForShareDevice: false),
                        ),
                      );
                    },
                    child: const Text(
                      "NEXT",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              const Text(
                "If indicator not flashes up, try hard resetting by pressing red button on left side device for 3 second",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),

        //  child: ElevatedButton(
        //    child: const Text('Open route'),
        //    onPressed: () {
        //      Navigator.push(
        //        context,
        //        MaterialPageRoute(builder: (context) =>  ),
        //      );
        //    },
        //  ),
      ),
    );
  }
}
