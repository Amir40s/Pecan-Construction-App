class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? avatarUrl;
  final List<AssignedSite>? assignedSites;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
    this.assignedSites,
  });
  factory EmployeeModel.fromMap(Map<String, dynamic> map, String docId) {
    final rawSites = map['assignedSites'];

    List<AssignedSite>? parsedSites;

    if (rawSites is List) {
      parsedSites = [];
      for (var e in rawSites) {
        if (e is Map<String, dynamic>) {
          parsedSites.add(AssignedSite.fromMap(e));
        }
      }
    }

    return EmployeeModel(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map["password"] ?? '',
      avatarUrl: map['avatarUrl'],
      assignedSites: parsedSites,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      "password" : password,
      'avatarUrl': avatarUrl,
      'assignedSites': assignedSites?.map((e) => e.toMap()).toList(),
    };
  }

  ///  copyWith
  EmployeeModel copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? password,
    List<AssignedSite>? assignedSites,
  }) {
    return EmployeeModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      assignedSites: assignedSites ?? this.assignedSites,
    );
  }
}

class AssignedSite {
  final String siteId;
  final String siteName;
  final String siteRole;

  const AssignedSite({
    required this.siteId,
    required this.siteName,
    required this.siteRole,
  });

  factory AssignedSite.fromMap(Map<String, dynamic> map) {
    return AssignedSite(
      siteId: map['site_id'] ?? '',
      siteName: map['site_name'] ?? '',
      siteRole: map['site_role'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'site_id': siteId, 'site_name': siteName, 'site_role': siteRole};
  }

  ///  copyWith
  AssignedSite copyWith({String? siteId, String? siteName, String? siteRole}) {
    return AssignedSite(
      siteId: siteId ?? this.siteId,
      siteName: siteName ?? this.siteName,
      siteRole: siteRole ?? this.siteRole,
    );
  }
}
