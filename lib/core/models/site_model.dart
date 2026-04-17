import 'package:cloud_firestore/cloud_firestore.dart';

class SitesModel {
  final String siteId;
  final String siteName;
  final String siteAddress;
  final String siteStatus;
  final String? siteNote;


  final String? siteDescription;

  final String? sitePhoto;
  final String? siteStartDate;

  final double? lat;
  final double? lng;

  final List<String> assignedEmployeeIds;

  final Map<String, dynamic> employeeRoles;

  final List<Map<String, dynamic>> siteAttachments;

  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  SitesModel({
    required this.siteId,
    required this.siteName,
    required this.siteAddress,
    required this.siteStatus,
    this.siteStartDate,
    this.siteNote,

    /// ✅ NEW FIELD
    this.siteDescription,

    this.sitePhoto,
    this.lat,
    this.lng,
    this.assignedEmployeeIds = const [],
    this.employeeRoles = const {},
    this.siteAttachments = const [],
    this.createdAt,
    this.updatedAt,
  });

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }

  factory SitesModel.fromJson(Map<String, dynamic> json) {
    final latVal = json.containsKey("lat") ? json["lat"] : json["siteLatitude"];
    final lngVal = json.containsKey("lng") ? json["lng"] : json["siteLongitude"];

    return SitesModel(
      siteId: (json["siteId"] ?? "").toString(),
      siteName: (json["siteName"] ?? "").toString(),
      siteAddress: (json["siteAddress"] ?? "").toString(),
      siteStatus: (json["siteStatus"] ?? "").toString(),
      siteNote: json["siteNote"]?.toString(),

      /// ✅ NEW FIELD
      siteDescription: json["siteDescription"]?.toString(),

      sitePhoto: json["sitePhoto"]?.toString(),
      siteStartDate: json["siteStartDate"]?.toString(),
      lat: _toDouble(latVal),
      lng: _toDouble(lngVal),
      assignedEmployeeIds: (json["assignedEmployeeIds"] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      employeeRoles: json["employeeRoles"] is Map
          ? Map<String, dynamic>.from(json["employeeRoles"])
          : <String, dynamic>{},
      siteAttachments: (json["siteAttachments"] as List?)
          ?.map((e) => Map<String, dynamic>.from(e as Map))
          .toList() ??
          [],
      createdAt:
      json["createdAt"] is Timestamp ? json["createdAt"] as Timestamp : null,
      updatedAt:
      json["updatedAt"] is Timestamp ? json["updatedAt"] as Timestamp : null,
    );
  }

  Map<String, dynamic> toJson(
      {bool withTimestamps = true, bool includeLegacyLatLngKeys = false}) {
    final json = <String, dynamic>{
      "siteName": siteName,
      "siteAddress": siteAddress,
      "siteStatus": siteStatus,
      "siteNote": siteNote,

      /// ✅ NEW FIELD
      "siteDescription": siteDescription,

      "sitePhoto": sitePhoto,
      "lat": lat,
      "lng": lng,
      "assignedEmployeeIds": assignedEmployeeIds,
      "employeeRoles": employeeRoles,
      "siteAttachments": siteAttachments,
      "siteStartDate": siteStartDate,
    };

    if (includeLegacyLatLngKeys) {
      json["siteLatitude"] = lat?.toString() ?? "";
      json["siteLongitude"] = lng?.toString() ?? "";
    }

    if (withTimestamps) {
      json["createdAt"] = createdAt ?? FieldValue.serverTimestamp();
      json["updatedAt"] = FieldValue.serverTimestamp();
    }

    return json;
  }
}