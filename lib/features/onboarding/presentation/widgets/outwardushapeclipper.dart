import 'package:flutter/material.dart';

class OutwardUShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.moveTo(0, 40);

    // OUTWARD curve (bulging upward)
    path.quadraticBezierTo(
      size.width / 2, // control point X (center)
      120,            // control point Y (higher = bigger outward curve)
      size.width,     // end X
      40,             // end Y
    );

    // Rest of container
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
