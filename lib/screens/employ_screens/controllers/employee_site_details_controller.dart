import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_images.dart';

import '../../../config/routes/routes_name.dart';

enum AttachmentType { image, pdf }

class SiteAttachment {
  final String id;
  final String title;     // "Blueprints_v2.pdf" / "Foundation_Steel.jpg"
  final String subtitle;  // "2.4 MB" (pdf) / "" (image optional)
  final AttachmentType type;

  /// For image thumbnails or preview assets/urls
  final String? thumbPathOrUrl;
  final bool isThumbNetwork;

  const SiteAttachment({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.thumbPathOrUrl,
    this.isThumbNetwork = false,
  });

  bool get isImage => type == AttachmentType.image;
  bool get isPdf => type == AttachmentType.pdf;
}

class EmployeeSiteDetailsController extends GetxController {
  // Screen state
  final RxBool isLoading = false.obs;

  // Header / site info
  final RxString siteTitle = "123B Construction".obs;
  final RxString openInMapsText = "Open in Maps".obs;

  /// Map image / static preview (asset or network)
  final RxString mapPreviewPathOrUrl = "assets/images/google_map.png".obs;
  final RxBool isMapNetwork = false.obs;

  // Assigned staff chips
  final RxList<String> assignedStaff = <String>[].obs;

  // Description
  final RxString siteDescription = "".obs;

  // Attachments
  final RxList<SiteAttachment> attachments = <SiteAttachment>[].obs;

  // Convenience computed lists
  List<SiteAttachment> get imageAttachments =>
      attachments.where((a) => a.isImage).toList();

  List<SiteAttachment> get pdfAttachments =>
      attachments.where((a) => a.isPdf).toList();

  // -------- lifecycle --------
  @override
  void onInit() {
    super.onInit();

    // If you pass siteId via Get.arguments:
    // final siteId = Get.arguments as String?;
    // if (siteId != null) loadSite(siteId);

    // For now demo data:
    seedDemoData();
  }

  // -------- actions --------
  void onTapOpenInMaps() {
    // open google maps with lat/lng or address
    // launchUrl(...)
  }

  void onTapSeeAllAttachments() {
    print("working");
    Get.toNamed(RoutesName.AttachmentsScreen,);
  }

  void onTapAttachment(SiteAttachment att) {
    // if (att.isPdf) open pdf viewer
    // else open image viewer
  }

  void onTapDownload(SiteAttachment att) {
    // start download
  }

  // -------- data loading --------
  Future<void> loadSite(String siteId) async {
    try {
      isLoading.value = true;

      // TODO: fetch from API/Firestore
      // siteTitle.value = ...
      // mapPreviewPathOrUrl.value = ...
      // assignedStaff.assignAll(...)
      // siteDescription.value = ...
      // attachments.assignAll(...)

    } catch (e) {
      // handle error (snackbar if needed)
    } finally {
      isLoading.value = false;
    }
  }

  // -------- demo (remove later) --------
  void seedDemoData() {
    siteTitle.value = "123B Construction";
    mapPreviewPathOrUrl.value = "assets/images/google_map.png";
    isMapNetwork.value = false;

    assignedStaff.assignAll([
      "John Doe (PM)",
      "Sarah Smith",
      "Mike Ross",
      "Harvey Specter",
    ]);

    siteDescription.value =
    "Main logistics terminal with 24 bay loading docks Foundations completed. Currently in steel framing phase Ensure all safety equipment is inspected by EOD Friday.";

    attachments.assignAll( [
      SiteAttachment(
        id: "img1",
        title: "Foundation_Steel.jpg",
        subtitle: "",
        type: AttachmentType.image,
        thumbPathOrUrl: AppImages.SiteAttichmentPic2,
        isThumbNetwork: false,
      ),
      SiteAttachment(
        id: "pdf1",
        title: "Blueprints_V2.pdf",
        subtitle: "2.4 MB",
        type: AttachmentType.pdf,
      ),
      SiteAttachment(
        id: "img2",
        title: "Excavation_update.png",
        subtitle: "",
        type: AttachmentType.image,
        thumbPathOrUrl: AppImages.SiteAttichmentPic,
        isThumbNetwork: false,
      ),
      SiteAttachment(
        id: "pdf2",
        title: "Safety_Manual.pdf",
        subtitle: "1.4 MB",
        type: AttachmentType.pdf,
      ),
    ]);
  }
}
