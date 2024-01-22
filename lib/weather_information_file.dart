import 'package:flutter/material.dart';

class MiniCards extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const MiniCards({super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(23))),
      margin: const EdgeInsets.all(8),
      // shadowColor: Colors.white,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              temp,
            )
          ],
        ),
      ),
    );
  }
}
