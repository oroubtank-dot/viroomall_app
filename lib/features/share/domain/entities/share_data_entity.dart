// lib/features/share/domain/entities/share_data_entity.dart

class ShareDataEntity {
  final String title;
  final String description;
  final String imageUrl;
  final String deepLink;
  final String? hashtags;

  ShareDataEntity({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.deepLink,
    this.hashtags,
  });
}
