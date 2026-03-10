enum AttachmentType {
  image,
  pdf,
  doc,
  excel,
  file, word, zip,ppt
}

class AttachmentModel {
  final String name;
  final String sizeText;
  final AttachmentType type;
  final String? thumbnailPath;

  const AttachmentModel({
    required this.name,
    required this.sizeText,
    required this.type,
    this.thumbnailPath,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    final ext = (json['ext'] ?? '').toString().toLowerCase();
    final mimeType = (json['mimeType'] ?? '').toString().toLowerCase();
    final rawSize = json['size'];

    AttachmentType attachmentType = AttachmentType.file;

    if (mimeType.startsWith('image/') ||
        ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext)) {
      attachmentType = AttachmentType.image;
    } else if (mimeType.contains('pdf') || ext == 'pdf') {
      attachmentType = AttachmentType.pdf;
    }

    return AttachmentModel(
      name: (json['name'] ?? '').toString(),
      sizeText: _formatSize(rawSize),
      type: attachmentType,
      thumbnailPath: json['thumbnailPath']?.toString(),
    );
  }

  static String _formatSize(dynamic size) {
    final bytes = size is int ? size : int.tryParse('${size ?? 0}') ?? 0;

    if (bytes <= 0) return '0 KB';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}