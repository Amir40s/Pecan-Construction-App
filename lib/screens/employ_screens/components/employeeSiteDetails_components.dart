import '../../../core/models/attaichment_model.dart';

class SiteAttachment {
  final String id;
  final String title;
  final String subtitle;
  final AttachmentType type;

  final String? thumbPathOrUrl;
  final bool isThumbNetwork;

  final String? url; //  original url (open/download)

  const SiteAttachment({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.thumbPathOrUrl,
    this.isThumbNetwork = false,
    this.url,
  });

  bool get isImage => type == AttachmentType.image;
  bool get isPdf => type == AttachmentType.pdf;
}