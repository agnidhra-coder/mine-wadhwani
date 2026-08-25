// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:mine_wadhwani/data/models/drone_analysis_result.dart';

// class BoundingBoxPainter extends CustomPainter {
//   final List<Detection> detections;
//   final double imageWidth;
//   final double imageHeight;

//   BoundingBoxPainter({
//     required this.detections,
//     required this.imageWidth,
//     required this.imageHeight,
//   });

//   Color _colorFor(String label) {
//     final l = label.toLowerCase();
//     if (l.contains('helmet')) return Colors.greenAccent;
//     if (l == 'person') return Colors.lightBlueAccent;
//     return Colors.orangeAccent;
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (imageWidth == 0 || imageHeight == 0) return;

//     final scaleX = size.width / imageWidth;
//     final scaleY = size.height / imageHeight;

//     for (final d in detections) {
//       final color = _colorFor(d.label);
//       final left = (d.x - d.width / 2) * scaleX;
//       final top = (d.y - d.height / 2) * scaleY;
//       final w = d.width * scaleX;
//       final h = d.height * scaleY;

//       final rect = Rect.fromLTWH(left, top, w, h);
//       final paint = Paint()
//         ..color = color
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2;
//       canvas.drawRect(rect, paint);

//       final label = '${d.label} ${(d.confidence * 100).toStringAsFixed(0)}%';
//       final textPainter = TextPainter(
//         text: TextSpan(
//           text: label,
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//             backgroundColor: color,
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//       )..layout();
//       textPainter.paint(canvas, Offset(left, top - textPainter.height < 0 ? top : top - textPainter.height));
//     }
//   }

//   @override
//   bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) =>
//       oldDelegate.detections != detections;
// }

// class AnnotatedImage extends StatelessWidget {
//   final File imageFile;
//   final DroneAnalysisResult result;
//   final double height;

//   const AnnotatedImage({
//     super.key,
//     required this.imageFile,
//     required this.result,
//     this.height = 160,
//   });

//   void _openFullView(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) => Scaffold(
//           backgroundColor: Colors.black,
//           appBar: AppBar(
//             backgroundColor: Colors.black,
//             iconTheme: const IconThemeData(color: Colors.white),
//           ),
//           body: Center(
//             child: InteractiveViewer(
//               minScale: 0.5,
//               maxScale: 4,
//               child: _buildStack(context),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStack(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return AspectRatio(
//           aspectRatio: result.imageWidth > 0 && result.imageHeight > 0
//               ? result.imageWidth / result.imageHeight
//               : 16 / 9,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               Image.file(imageFile, fit: BoxFit.contain),
//               CustomPaint(
//                 painter: BoundingBoxPainter(
//                   detections: result.detections,
//                   imageWidth: result.imageWidth,
//                   imageHeight: result.imageHeight,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _openFullView(context),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: SizedBox(
//           height: height,
//           width: double.infinity,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               _buildStack(context),
//               Positioned(
//                 bottom: 6,
//                 right: 6,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.zoom_in_rounded, color: Colors.white, size: 14),
//                       SizedBox(width: 4),
//                       Text('Tap to zoom', style: TextStyle(color: Colors.white, fontSize: 10)),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mine_wadhwani/data/models/drone_analysis_result.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Detection> detections;
  final double imageWidth;
  final double imageHeight;

  BoundingBoxPainter({
    required this.detections,
    required this.imageWidth,
    required this.imageHeight,
  });

  Color _colorFor(String label) {
    final l = label.toLowerCase();
    if (l.contains('helmet')) return Colors.greenAccent;
    if (l == 'person') return Colors.lightBlueAccent;
    return Colors.orangeAccent;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (imageWidth == 0 || imageHeight == 0) return;

    final scaleX = size.width / imageWidth;
    final scaleY = size.height / imageHeight;

    for (final d in detections) {
      final color = _colorFor(d.label);
      final left = (d.x - d.width / 2) * scaleX;
      final top = (d.y - d.height / 2) * scaleY;
      final w = d.width * scaleX;
      final h = d.height * scaleY;

      final rect = Rect.fromLTWH(left, top, w, h);
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(rect, paint);

      final label = '${d.label} ${(d.confidence * 100).toStringAsFixed(0)}%';
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            backgroundColor: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(left, top - textPainter.height < 0 ? top : top - textPainter.height));
    }
  }

  @override
  bool shouldRepaint(covariant BoundingBoxPainter oldDelegate) =>
      oldDelegate.detections != detections;
}

class AnnotatedImage extends StatelessWidget {
  final Uint8List imageBytes;
  final DroneAnalysisResult result;
  final double height;

  const AnnotatedImage({
    super.key,
    required this.imageBytes,
    required this.result,
    this.height = 160,
  });

  void _openFullView(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: _buildStack(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStack() {
    return AspectRatio(
      aspectRatio: result.imageWidth > 0 && result.imageHeight > 0
          ? result.imageWidth / result.imageHeight
          : 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(imageBytes, fit: BoxFit.contain),
          CustomPaint(
            painter: BoundingBoxPainter(
              detections: result.detections,
              imageWidth: result.imageWidth,
              imageHeight: result.imageHeight,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullView(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildStack(),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.zoom_in_rounded, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('Tap to zoom', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}