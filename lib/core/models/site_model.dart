enum SiteStatus { active, completed }

class SiteModel {
  final String title;
  final String subTitle;
  final String imagePath;

  /// "In Progress" / "Completed" text (screenshot wali line)
  final String progressText;

  final SiteStatus status;

  const SiteModel({
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.progressText,
    required this.status,
  });
}
