import 'dart:typed_data';

/// Holds a picked image's file path (for upload) and bytes (for display).
/// This approach works on both mobile and web platforms.
class PendingImage {
  final String filePath;
  final Uint8List bytes;

  const PendingImage({required this.filePath, required this.bytes});
}
