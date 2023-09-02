import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: const Color(0xFF222222),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'M A T H',
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
            ),
          ),
        ),
        const Text(
          ' H E A D S',
          style: TextStyle(
            fontSize: 35,
          ),
        )
      ],
    );
  }
}
