enum AttachmentType { image, pdf }

class AttachmentModel {
  final String name;
  final String sizeText;     // e.g. "2.4 MB"
  final AttachmentType type;
  final String? thumbnailPath; // only for image preview assets (demo)

  const AttachmentModel({
    required this.name,
    required this.sizeText,
    required this.type,
    this.thumbnailPath,
  });
}
