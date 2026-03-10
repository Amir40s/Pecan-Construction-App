import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pecan_construction/core/repo/site_repository.dart';
import '../../../core/models/site_model.dart';
import '../components/employeeSiteDetails_components.dart';
import 'package:pecan_construction/core/models/attaichment_model.dart';
import 'employee_site_details_controller.dart' show FullScreenImagePreview;

class AttachmentItem {
  final String id;
  final String title;     // e.g. "Blueprints_v2.pdf"
  final String subtitle;  // e.g. "2.4 MB"
  final AttachmentType type;

  // For images: thumbPath can be asset or network
  // For pdf: icon is shown, thumb not required
  final String? thumbPath;
  final bool isThumbNetwork;
  final String? url;

  const AttachmentItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.thumbPath,
    this.isThumbNetwork = false,
    this.url,
  });

  bool get isImage => type == AttachmentType.image;
  bool get isPdf => type == AttachmentType.pdf;
}

class AttachmentsController extends GetxController {
  SitesRepository repository = SitesRepository();
  final RxBool isLoading = false.obs;

  // Recent uploads (top)
  final RxList<AttachmentItem> recentUploads = <AttachmentItem>[].obs;
  final RxList<String> employeePhotos = <String>[].obs;

  // All files (grid)
  final RxList<AttachmentItem> allFiles = <AttachmentItem>[].obs;

   String? siteId;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args != null && args["siteId"] != null) {
      siteId = args["siteId"];
      listenSiteAttachments(siteId!);
      fetchEmployeePhotos(siteId!);
    } else {
      Get.snackbar("Error", "Site ID not found");
    }
  }


  Future<void> captureAndUploadPhoto(String siteId) async {
    try {
      final picker = ImagePicker();

      final XFile? photo = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo == null) return;

      isLoading.value = true;
      final file = File(photo.path);

      final result = await repository.uploadEmployeePhoto(
        siteId: siteId,
        file: file,
      );

      result.fold(
            (l) => Get.snackbar("Error", l.message),
            (_) => Get.snackbar("Success", "Photo uploaded"),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  // Actions (wire with your routes / downloads)
  void onBack() => Get.back();


  void openAttachment(AttachmentItem item) {

    if (item.url == null || item.url!.isEmpty) {
      Get.snackbar("Error", "File not available");
      return;
    }

    if (item.isImage) {

      Get.to(() => FullScreenImagePreview(
        att: SiteAttachment(
          id: item.id,
          title: item.title,
          subtitle: item.subtitle,
          type: item.type,
          thumbPathOrUrl: item.thumbPath,
          isThumbNetwork: item.isThumbNetwork,
          url: item.url,
        ),
      ));

    } else {

      downloadAndOpenFile(
        item.url!,
        item.title,
      );

    }
  }


  void listenSiteAttachments(String siteId) {

    FirebaseFirestore.instance
        .collection("sites")
        .doc(siteId)
        .snapshots()
        .listen((doc) {

      if (!doc.exists) return;

      final site = SitesModel.fromJson(doc.data()!);

      final attachments = site.siteAttachments;

      final mapped = attachments.map((e) {

        final url = (e["url"] ?? "").toString().trim();
        final name = (e["name"] ?? "file").toString();
        final ext = (e["ext"] ?? "").toString().toLowerCase();
        final mime = (e["mimeType"] ?? "").toString().toLowerCase();

        AttachmentType type = AttachmentType.file;

        if (["jpg", "jpeg", "png", "webp"].contains(ext) ||
            mime.contains("image")) {
          type = AttachmentType.image;
        }
        else if (ext == "pdf" || mime.contains("pdf")) {
          type = AttachmentType.pdf;
        }
        else if (["doc", "docx"].contains(ext)) {
          type = AttachmentType.word;
        }
        else if (["xls", "xlsx"].contains(ext)) {
          type = AttachmentType.excel;
        }
        else if (["ppt", "pptx"].contains(ext)) {
          type = AttachmentType.ppt;
        }
        else if (["zip", "rar"].contains(ext)) {
          type = AttachmentType.zip;
        }

        return AttachmentItem(
          id: url,
          title: name,
          subtitle: ext.isEmpty ? "FILE" : ext.toUpperCase(),
          type: type,
          thumbPath: type == AttachmentType.image ? url : null,
          isThumbNetwork: type == AttachmentType.image,
          url: url,
        );

      }).toList();

      // latest upload top
      mapped.sort((a, b) => b.id.compareTo(a.id));

      recentUploads.assignAll(
        mapped.where((e) => e.isImage).toList(),
      );

      allFiles.assignAll(mapped);

    });
  }

  Future<void> downloadAndOpenFile(String url, String fileName) async {
    try {

      final dir = await getApplicationDocumentsDirectory();

      final safeName = fileName.replaceAll(" ", "_");

      final filePath = "${dir.path}/$safeName";

      final file = File(filePath);

      /// file already exists
      if (await file.exists()) {
        await OpenFilex.open(filePath);
        return;
      }

      Get.snackbar(
        "Downloading",
        "Please wait...",
        showProgressIndicator: true,
        snackPosition: SnackPosition.BOTTOM,
      );

      await Dio().download(url, filePath);

      await OpenFilex.open(filePath);

    } catch (e) {
      Get.snackbar("Error", "Unable to open file");
    }
  }

  void downloadAttachment(AttachmentItem item) {
    // We can call download logic here or in UI
  }
  // 🔹 Fetch employee photos from Firestore
  void fetchEmployeePhotos(String siteId) {
    FirebaseFirestore.instance
        .collection("sites")
        .doc(siteId)
        .snapshots()
        .listen((doc) {
      if (!doc.exists) return;

      final data = doc.data();
      if (data != null && data["employeePhotos"] != null) {
        final List<dynamic> photos = data["employeePhotos"];
        employeePhotos.assignAll(photos.map((e) => e.toString()).toList());
      }
    });
  }

  }

