import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/routes/routes_name.dart';
import '../../../core/models/attaichment_model.dart';
import '../../../core/models/site_model.dart';
import '../components/employeeSiteDetails_components.dart';


class EmployeeSiteDetailsController extends GetxController {
  final _db = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;

  final RxString siteTitle = "".obs;
  final RxString openInMapsText = "Open in Maps".obs;

  final RxBool isMapNetwork = false.obs;

  final RxList<String> assignedStaff = <String>[].obs;
  final RxString siteDescription = "".obs;
  final RxString siteNote = "".obs;
  final RxString siteStatus = "".obs;
  final RxString siteAddress = "".obs;
  final RxDouble lat = 0.0.obs;
  final RxDouble long = 0.0.obs;

  final RxList<SiteAttachment> attachments = <SiteAttachment>[].obs;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _siteSub;
  final _empSubs = <StreamSubscription>[];

  late final String siteId;
  late final AttachmentType type;
  bool get isImage => type == AttachmentType.image;
  bool get isPdf => type == AttachmentType.pdf;

  @override
  void onInit() {
    super.onInit();

    final arg = Get.arguments;
    String id = "";

    if (arg is String) {
      id = arg.trim();
    } else if (arg is Map && arg.containsKey("siteId")) {
      id = (arg["siteId"] ?? "").toString().trim();
    }

    if (id.isEmpty) {
      Get.snackbar("Error", "Missing siteId");
      return;
    }

    siteId = id;
    _listenSite(siteId);
  }

  @override
  void onClose() {
    _siteSub?.cancel();
    for (final s in _empSubs) {
      s.cancel();
    }
    _empSubs.clear();
    super.onClose();
  }

  void _listenSite(String id) {
    isLoading.value = true;

    _siteSub?.cancel();
    _siteSub = _db.collection("sites").doc(id).snapshots().listen(
          (doc) async {
        if (!doc.exists) {
          isLoading.value = false;
          Get.snackbar("Error", "Site not found");
          return;
        }

        final data = doc.data();
        if (data == null) {
          isLoading.value = false;
          Get.snackbar("Error", "Empty site data");
          return;
        }

        final map = {...data, "siteId": doc.id};
        final site = SitesModel.fromJson(map);

        //  set UI fields
        siteTitle.value = site.siteName;
        siteDescription.value = site.siteDescription ?? "";
        siteNote.value = site.siteNote ?? "";
        siteStatus.value = site.siteStatus ?? "";
        lat.value = site.lat!;
        long.value = site.lng!;
        siteAddress.value = site.siteAddress;
        isMapNetwork.value = false;

        attachments.assignAll(_mapAttachments(site.siteAttachments));

        await _bindAssignedEmployees(
          ids: site.assignedEmployeeIds,
          roleMap: site.employeeRoles,
        );

        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
        Get.snackbar("Error", e.toString());
      },
    );
  }

  List<SiteAttachment> _mapAttachments(List<Map<String, dynamic>> raw) {
    final out = <SiteAttachment>[];

    for (final a in raw) {
      final url = (a["url"] ?? "").toString().trim();
      if (url.isEmpty) continue;

      final name = (a["name"] ?? "Untitled").toString();

      final ext = (a["ext"] ?? "").toString().toLowerCase();
      final mime = (a["mimeType"] ?? "").toString().toLowerCase();

      AttachmentType type;

      if (ext == "pdf" || mime.contains("pdf")) {
        type = AttachmentType.pdf;
      }
      else if (["jpg", "jpeg", "png", "webp"].contains(ext) ||
          mime.contains("image")) {
        type = AttachmentType.image;
      }
      else if (["doc", "docx"].contains(ext)) {
        type = AttachmentType.doc;
      }
      else if (["xls", "xlsx"].contains(ext)) {
        type = AttachmentType.excel;
      }
      else {
        type = AttachmentType.file;
      }

      out.add(
        SiteAttachment(
          id: url,
          title: name,
          subtitle: ext.toUpperCase(),
          type: type,
          url: url,

          thumbPathOrUrl: type == AttachmentType.image ? url : null,
          isThumbNetwork: type == AttachmentType.image,
        ),
      );
    }

    return out;
  }

  Future<void> _bindAssignedEmployees({
    required List<String> ids,
    required Map<String, dynamic> roleMap,
  }) async {
    // clear old
    for (final s in _empSubs) {
      s.cancel();
    }
    _empSubs.clear();
    assignedStaff.clear();

    final cleanIds = ids.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
    if (cleanIds.isEmpty) return;

    const chunkSize = 10;
    final merged = <String, Map<String, dynamic>>{};

    void emit() {
      final list = <String>[];
      for (final id in cleanIds) {
        final emp = merged[id];
        final name = (emp?["name"] ?? "Unknown").toString().trim();
        final role = (roleMap[id] ?? "").toString().trim();
        list.add(role.isEmpty ? name : "$name ($role)");
      }
      assignedStaff.assignAll(list);
    }

    for (int i = 0; i < cleanIds.length; i += chunkSize) {
      final chunk = cleanIds.sublist(i, (i + chunkSize).clamp(0, cleanIds.length));

      final q = _db
          .collection("employees")
          .where(FieldPath.documentId, whereIn: chunk);

      final sub = q.snapshots().listen((snap) {
        for (final d in snap.docs) {
          merged[d.id] = {...d.data(), "id": d.id};
        }

        // missing employees
        for (final id in chunk) {
          if (!snap.docs.any((x) => x.id == id)) {
            merged[id] = {"name": "Unknown"};
          }
        }

        emit();
      });

      _empSubs.add(sub);
    }
  }


  Future<void> onTapOpenInMaps() async {
    try {
      final latitude = lat.value;
      final longitude = long.value;

      if (latitude == 0.0 && longitude == 0.0) {
        Get.snackbar("Error", "Location not found");
        return;
      }

      Uri googleMapsUrl;

      if (GetPlatform.isAndroid) {
        googleMapsUrl = Uri.parse(
          "geo:$latitude,$longitude?q=$latitude,$longitude",
        );
      }

      else if (GetPlatform.isIOS) {
        googleMapsUrl = Uri.parse(
          "comgooglemaps://?q=$latitude,$longitude",
        );
      }

      else {
        googleMapsUrl = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
        );
      }

      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        final webUrl = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
        );

        await launchUrl(
          webUrl,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void onTapSeeAllAttachments() {
    Get.toNamed(RoutesName.AttachmentsScreen);
  }

  void onTapAttachment(SiteAttachment att) {
    if (att.isImage) {
      Get.to(() => FullScreenImagePreview(att: att));
    } else {
      onTapDownload(att);
    }
  }

  Future<void> onTapDownload(SiteAttachment att) async {
    final url = att.url;

    if (url == null || url.isEmpty) {
      Get.snackbar("Error", "Invalid attachment URL");
      return;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();

      final fileName =
          "${att.title}.${att.isPdf ? "pdf" : "jpg"}";

      final filePath = "${dir.path}/$fileName";

      final file = File(filePath);

      ///  If already downloaded → open directly
      if (await file.exists()) {
        await OpenFilex.open(filePath);
        return;
      }

      /// Show downloading snackbar
      Get.snackbar(
        "Downloading",
        "Downloading ${att.title}...",
        snackPosition: SnackPosition.BOTTOM,
        showProgressIndicator: true,
      );

      final dio = Dio();

      await dio.download(url, filePath);

      /// Open file after download
      await OpenFilex.open(filePath);

    } catch (e) {
      Get.snackbar("Error", "Failed to open file");
    }
  }
}

class FullScreenImagePreview extends StatelessWidget {
  final SiteAttachment att;
  const FullScreenImagePreview({super.key, required this.att});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: att.isThumbNetwork
                  ? CachedNetworkImage(
                      imageUrl: att.url ?? "",
                      placeholder: (context, url) => const CircularProgressIndicator(color: Colors.white),
                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
                      fit: BoxFit.contain,
                    )
                  : Image.asset(att.thumbPathOrUrl ?? "", fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  att.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}