import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_images.dart';

enum AttachmentType { image, pdf }

class AttachmentItem {
  final String id;
  final String title;     // e.g. "Blueprints_v2.pdf"
  final String subtitle;  // e.g. "2.4 MB"
  final AttachmentType type;

  // For images: thumbPath can be asset or network
  // For pdf: icon is shown, thumb not required
  final String? thumbPath;
  final bool isThumbNetwork;

  const AttachmentItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.thumbPath,
    this.isThumbNetwork = false,
  });

  bool get isImage => type == AttachmentType.image;
  bool get isPdf => type == AttachmentType.pdf;
}

class AttachmentsController extends GetxController {
  final RxBool isLoading = false.obs;

  // Recent uploads (top)
  final RxList<AttachmentItem> recentUploads = <AttachmentItem>[].obs;

  // All files (grid)
  final RxList<AttachmentItem> allFiles = <AttachmentItem>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy data like screenshot
    recentUploads.assignAll( [
      AttachmentItem(
        id: "r1",
        title: "Foundation_Steel.jpg",
        subtitle: "",
        type: AttachmentType.image,
        thumbPath: AppImages.SiteAttichmentPic2,
      ),
      AttachmentItem(
        id: "r2",
        title: "Excavation_update.png",
        subtitle: "",
        type: AttachmentType.image,
        thumbPath: AppImages.SiteAttichmentPic,
      ),
    ]);

    allFiles.assignAll(const [
      AttachmentItem(
        id: "p1",
        title: "Blueprints_v2.pdf",
        subtitle: "2.4 MB",
        type: AttachmentType.pdf,
      ),
      AttachmentItem(
        id: "p2",
        title: "Safety_Manual.pdf",
        subtitle: "1.4 MB",
        type: AttachmentType.pdf,
      ),
      AttachmentItem(
        id: "p3",
        title: "Blueprints_v2.pdf",
        subtitle: "2.4 MB",
        type: AttachmentType.pdf,
      ),
      AttachmentItem(
        id: "p4",
        title: "Safety_Manual.pdf",
        subtitle: "1.4 MB",
        type: AttachmentType.pdf,
      ),
    ]);
  }

  // Actions (wire with your routes / downloads)
  void onBack() => Get.back();

  void openAttachment(AttachmentItem item) {
    // if (item.isImage) Get.toNamed("/image-viewer", arguments: item);
    // else Get.toNamed("/pdf-viewer", arguments: item);
  }

  void downloadAttachment(AttachmentItem item) {
    // implement download logic
  }
}
