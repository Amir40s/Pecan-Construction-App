import 'package:get/get.dart';
import 'package:pecan_construction/core/constant/app_images.dart';
import '../../../core/models/attaichment_model.dart';

class AddAttachmentController extends GetxController {
  final attachments = <AttachmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Demo attachments (replace with real picked files)
    attachments.assignAll([
      AttachmentModel(
        name: "Foundation_Steel.jpg",
        sizeText: "1.4 MB",
        type: AttachmentType.image,
        thumbnailPath: AppImages.SiteAttichmentPic, // replace with real preview image asset
      ),
      AttachmentModel(
        name: "Blueprints_V2.pdf",
        sizeText: "2.4 MB",
        type: AttachmentType.pdf,
      ),
      AttachmentModel(
        name: "Excavation_Update.png",
        sizeText: "1.8 MB",
        type: AttachmentType.image,
        thumbnailPath: AppImages.SiteAttichmentPic2, // replace with real preview image asset
      ),
      AttachmentModel(
        name: "Safety_Manual.pdf",
        sizeText: "1.4 MB",
        type: AttachmentType.pdf,
      ),
    ]);
  }

  // Actions (connect with image_picker/file_picker later)
  void takePhoto() {
    // TODO: open camera and add to attachments
  }

  void uploadFromGallery() {
    // TODO: pick images and add to attachments
  }

  void uploadFilePdf() {
    // TODO: pick file (pdf) and add to attachments
  }

  void removeAt(int index) {
    attachments.removeAt(index);
  }

  void onSaveSite() {
    // TODO: submit attachments to backend / firestore
    Get.snackbar("Saved", "Site saved with ${attachments.length} attachments (demo)");
  }
}
