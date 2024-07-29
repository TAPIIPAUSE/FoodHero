import 'dart:math';

import 'package:flutter/material.dart';

class Segment {
  final double value;
  final Color color;
  final String label;

  Segment({required this.value, required this.color, required this.label});
}

class PrimerCircularProgressBar extends StatelessWidget {
  final List<Segment> segments;

  const PrimerCircularProgressBar({super.key, required this.segments});

  @override
  Widget build(BuildContext context) {
    double totalValue = segments.fold(0, (sum, segment) => sum + segment.value);

    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: screenWidth * 0.2,
          height: screenWidth * 0.2,
          child: CustomPaint(
            painter: CircularProgressPainter(
                segments: segments, totalValue: totalValue),
          ),
        ),
        const SizedBox(width: 50),
        Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: segments.map((segment) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: segment.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${segment.label}: ${segment.value.toStringAsFixed(0)}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final List<Segment> segments;
  final double totalValue;

  CircularProgressPainter({required this.segments, required this.totalValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    double startAngle = -pi / 2;

    for (var segment in segments) {
      final sweepAngle = 2 * pi * (segment.value / totalValue);
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 15;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
