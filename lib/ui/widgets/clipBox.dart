import 'package:flutter/material.dart';

// create a small box with 3 lines in it
Widget buildBox() {
  return Container(
    // round shope
    width: 20,
    height: 23,
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(5),
    ),
    // color: Colors.grey[300],
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
              height: 2,
              // circular
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 10,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 10,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ]),
    ),
  );
}
