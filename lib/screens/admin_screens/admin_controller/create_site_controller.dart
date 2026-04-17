import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/core/models/site_model.dart';

import '../../../core/models/attaichment_model.dart';

class CreateSiteController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  final siteNameC = TextEditingController();
  final siteAddressC = TextEditingController();
  final siteNoteC = TextEditingController();

  final  selectedStatus = TextEditingController();
  final  selectedStartDate = TextEditingController();

  final Rx<File?> selectedSiteImage = Rx<File?>(null);

  final RxnDouble lat = RxnDouble();
  final RxnDouble lng = RxnDouble();


  final RxList<String> assignedEmployeeIds = <String>[].obs;
  final RxMap<String, dynamic> employeeRoles = <String, dynamic>{}.obs;

  final RxList<Map<String, dynamic>> assignedEmployeesPreview =
      <Map<String, dynamic>>[].obs;


  final RxList<File> pendingImageAttachments = <File>[].obs;
  final RxList<PlatformFile> pendingFileAttachments = <PlatformFile>[].obs;

  final RxList<Map<String, dynamic>> siteAttachments =
      <Map<String, dynamic>>[].obs;

  final RxBool isSaving = false.obs;
  final RxBool isPickingMainImage = false.obs;
  final RxBool isPickingAttachments = false.obs;
  final RxDouble uploadProgress = 0.0.obs;


  void setStatus(String value) {
    selectedStatus.text = value.trim();
  }

  void setStartDate(String value) {
    selectedStartDate.text = value.trim();
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      selectedStartDate.text = formattedDate;
    }
  }

  void setCoordinates({
    double? latitude,
    double? longitude,
  }) {
    lat.value = latitude;
    lng.value = longitude;
  }


  Future<void> pickMainImageFromGallery() async {
    try {
      isPickingMainImage.value = true;

      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );

      if (file != null) {
        selectedSiteImage.value = File(file.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick site image: $e");
    } finally {
      isPickingMainImage.value = false;
    }
  }

  Future<void> captureMainImageFromCamera() async {
    try {
      isPickingMainImage.value = true;

      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );

      if (file != null) {
        selectedSiteImage.value = File(file.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to capture site image: $e");
    } finally {
      isPickingMainImage.value = false;
    }
  }

  void removeMainImage() {
    selectedSiteImage.value = null;
  }


  void addAssignedEmployee({
    required String employeeId,
    required String name,
    required String email,
    required String role,
  }) {
    final cleanId = employeeId.trim();
    if (cleanId.isEmpty) return;

    if (!assignedEmployeeIds.contains(cleanId)) {
      assignedEmployeeIds.add(cleanId);
    }

    employeeRoles[cleanId] = role.trim();

    final index = assignedEmployeesPreview.indexWhere(
          (e) => (e['id'] ?? '').toString() == cleanId,
    );

    final item = {
      "id": cleanId,
      "name": name.trim(),
      "email": email.trim(),
      "role": role.trim(),
    };

    if (index == -1) {
      assignedEmployeesPreview.add(item);
    } else {
      assignedEmployeesPreview[index] = item;
      assignedEmployeesPreview.refresh();
    }
  }

  void removeAssignedEmployee(String employeeId) {
    assignedEmployeeIds.remove(employeeId);
    employeeRoles.remove(employeeId);
    assignedEmployeesPreview.removeWhere(
          (e) => (e['id'] ?? '').toString() == employeeId,
    );
  }


  Future<void> pickAttachmentImagesFromGallery() async {
    try {
      isPickingAttachments.value = true;

      final List<XFile> files = await _imagePicker.pickMultiImage(
        imageQuality: 75,
      );

      if (files.isNotEmpty) {
        pendingImageAttachments.addAll(files.map((e) => File(e.path)));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick gallery images: $e");
    } finally {
      isPickingAttachments.value = false;
    }
  }

  Future<void> captureAttachmentFromCamera() async {
    try {
      isPickingAttachments.value = true;

      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
      );

      if (file != null) {
        pendingImageAttachments.add(File(file.path));
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to capture image: $e");
    } finally {
      isPickingAttachments.value = false;
    }
  }

  Future<void> pickFiles() async {
    try {
      isPickingAttachments.value = true;

      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withData: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final onlyValid = result.files.where((f) => (f.path ?? '').isNotEmpty);
        pendingFileAttachments.addAll(onlyValid);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick files: $e");
    } finally {
      isPickingAttachments.value = false;
    }
  }

  List<AttachmentModel> get attachmentPreviewList {
    final List<AttachmentModel> items = [];

    for (final file in pendingImageAttachments) {
      final bytes = file.existsSync() ? file.lengthSync() : 0;

      items.add(
        AttachmentModel(
          name: p.basename(file.path),
          sizeText: _formatBytes(bytes),
          type: AttachmentType.image,
          thumbnailPath: file.path,
        ),
      );
    }

    for (final file in pendingFileAttachments) {
      final ext = p.extension(file.name).replaceFirst('.', '').toLowerCase();

      AttachmentType type = AttachmentType.file;
      if (ext == 'pdf') {
        type = AttachmentType.pdf;
      }

      items.add(
        AttachmentModel(
          name: file.name,
          sizeText: _formatBytes(file.size),
          type: type,
          thumbnailPath: null,
        ),
      );
    }

    /// uploaded attachments bhi show kar do
    for (final item in siteAttachments) {
      items.add(AttachmentModel.fromJson(item));
    }

    return items;
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 KB';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  void removeAttachmentAt(int index) {
    final imageCount = pendingImageAttachments.length;
    final fileCount = pendingFileAttachments.length;
    final uploadedCount = siteAttachments.length;

    if (index < imageCount) {
      pendingImageAttachments.removeAt(index);
      return;
    }

    if (index < imageCount + fileCount) {
      final fileIndex = index - imageCount;
      pendingFileAttachments.removeAt(fileIndex);
      return;
    }

    if (index < imageCount + fileCount + uploadedCount) {
      final uploadedIndex = index - imageCount - fileCount;
      siteAttachments.removeAt(uploadedIndex);
    }
  }


  void removePendingImageAt(int index) {
    if (index >= 0 && index < pendingImageAttachments.length) {
      pendingImageAttachments.removeAt(index);
    }
  }

  void removePendingFileAt(int index) {
    if (index >= 0 && index < pendingFileAttachments.length) {
      pendingFileAttachments.removeAt(index);
    }
  }


  bool validateStepOne() {
    if (siteNameC.text.trim().isEmpty) {
      Get.snackbar("Error", "Site name is required");
      return false;
    }

    if (siteAddressC.text.trim().isEmpty) {
      Get.snackbar("Error", "Site address is required");
      return false;
    }

    if (selectedStartDate.text.trim().isEmpty) {
      Get.snackbar("Error", "Start date is required");
      return false;
    }

    if (selectedStatus.text.trim().isEmpty) {
      Get.snackbar("Error", "Site status is required");
      return false;
    }

    return true;
  }

  bool validateBeforeSave() {
    if (!validateStepOne()) return false;
    return true;
  }

  String _safeFileName(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'[^\w\s.-]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
  }

  Future<String> _uploadFileToStorage({
    required File file,
    required String storagePath,
    String? mimeType,
  }) async {
    final ref = _storage.ref().child(storagePath);

    final metadata = mimeType != null && mimeType.isNotEmpty
        ? SettableMetadata(contentType: mimeType)
        : null;

    final uploadTask = metadata != null
        ? ref.putFile(file, metadata)
        : ref.putFile(file);

    await uploadTask;
    return ref.getDownloadURL();
  }

  Future<String> _uploadPlatformFileToStorage({
    required PlatformFile file,
    required String storagePath,
  }) async {
    if (file.path == null || file.path!.isEmpty) {
      throw Exception("Invalid file path");
    }

    final ref = _storage.ref().child(storagePath);

    final mimeType = lookupMimeType(file.path!);
    final metadata = mimeType != null
        ? SettableMetadata(contentType: mimeType)
        : null;

    final uploadTask = metadata != null
        ? ref.putFile(File(file.path!), metadata)
        : ref.putFile(File(file.path!));

    await uploadTask;
    return ref.getDownloadURL();
  }

  Future<String?> uploadMainSiteImageIfNeeded(String siteId) async {
    if (selectedSiteImage.value == null) return null;

    final file = selectedSiteImage.value!;
    final ext = p.extension(file.path).replaceFirst('.', '');
    final fileName =
        "main_${DateTime.now().millisecondsSinceEpoch}.${ext.isEmpty ? 'jpg' : ext}";

    final storagePath = "sites/$siteId/main/$fileName";

    return _uploadFileToStorage(
      file: file,
      storagePath: storagePath,
      mimeType: lookupMimeType(file.path),
    );
  }

  Future<List<Map<String, dynamic>>> uploadAllAttachments(String siteId) async {
    final List<Map<String, dynamic>> uploaded = [];

    final totalCount =
        pendingImageAttachments.length + pendingFileAttachments.length;

    if (totalCount == 0) return uploaded;

    int done = 0;

    Future<void> tickProgress() async {
      done++;
      uploadProgress.value = done / totalCount;
    }

    for (final file in pendingImageAttachments) {
      final name = p.basename(file.path);
      final ext = p.extension(file.path).replaceFirst('.', '').toLowerCase();
      final mimeType =
          lookupMimeType(file.path) ?? "image/${ext.isEmpty ? 'jpeg' : ext}";
      final storageName =
          "${DateTime.now().millisecondsSinceEpoch}_${_safeFileName(name)}";
      final storagePath = "sites/$siteId/attachments/images/$storageName";

      final url = await _uploadFileToStorage(
        file: file,
        storagePath: storagePath,
        mimeType: mimeType,
      );

      uploaded.add({
        "name": name,
        "ext": ext,
        "mimeType": mimeType,
        "url": url,
        "size": await file.length(),
      });

      await tickProgress();
    }

    for (final file in pendingFileAttachments) {
      final originalName = file.name;
      final ext = p.extension(originalName).replaceFirst('.', '').toLowerCase();
      final mimeType = file.path != null
          ? (lookupMimeType(file.path!) ?? "application/octet-stream")
          : "application/octet-stream";
      final storageName =
          "${DateTime.now().millisecondsSinceEpoch}_${_safeFileName(originalName)}";
      final storagePath = "sites/$siteId/attachments/files/$storageName";

      final url = await _uploadPlatformFileToStorage(
        file: file,
        storagePath: storagePath,
      );

      uploaded.add({
        "name": originalName,
        "ext": ext,
        "mimeType": mimeType,
        "url": url,
        if (file.size > 0) "size": file.size,
      });

      await tickProgress();
    }

    return uploaded;
  }


  SitesModel buildSiteModel({
    required String docId,
    String? uploadedSitePhotoUrl,
    List<Map<String, dynamic>> attachments = const [],
  }) {
    return SitesModel(
      siteId: docId,
      siteName: siteNameC.text.trim(),
      siteAddress: siteAddressC.text.trim(),
      siteStatus: selectedStatus.text.trim(),
      siteNote: siteNoteC.text.trim().isEmpty ? null : siteNoteC.text.trim(),
      sitePhoto: uploadedSitePhotoUrl,
      siteStartDate: selectedStartDate.text.trim(),
      lat: lat.value,
      lng: lng.value,
      siteDescription: "",
      assignedEmployeeIds: assignedEmployeeIds.toList(),
      employeeRoles: Map<String, dynamic>.from(employeeRoles),
      siteAttachments: attachments,
      createdAt: null,
      updatedAt: null,
    );
  }

  Future<void> saveSite() async {
    if (!validateBeforeSave()) return;

    try {
      isSaving.value = true;
      uploadProgress.value = 0.0;

      final docRef = _firestore.collection('sites').doc();
      final siteId = docRef.id;

      final uploadedSitePhotoUrl = await uploadMainSiteImageIfNeeded(siteId);

      final uploadedAttachments = await uploadAllAttachments(siteId);
      siteAttachments.assignAll(uploadedAttachments);

      final siteModel = buildSiteModel(
        docId: siteId,
        uploadedSitePhotoUrl: uploadedSitePhotoUrl,
        attachments: uploadedAttachments,
      );

      await docRef.set({
        "siteId": siteId,
        ...siteModel.toJson(),
      });

      Get.snackbar("Success", "Site created successfully");
      clearAllFields();
      Get.offAllNamed(RoutesName.BottomNavScreen);
    } catch (e) {
      Get.snackbar("Error", "Failed to save site: $e");
    } finally {
      isSaving.value = false;
      uploadProgress.value = 0.0;
    }
  }

  void clearAllFields() {
    siteNameC.clear();
    siteAddressC.clear();
    siteNoteC.clear();

    selectedSiteImage.value = null;

    lat.value = null;
    lng.value = null;

    assignedEmployeeIds.clear();
    employeeRoles.clear();
    assignedEmployeesPreview.clear();

    pendingImageAttachments.clear();
    pendingFileAttachments.clear();
    siteAttachments.clear();
  }

  @override
  void onClose() {
    siteNameC.dispose();
    siteAddressC.dispose();
    siteNoteC.dispose();
    selectedStatus.dispose();
    selectedStartDate.dispose();
    super.onClose();
  }
}