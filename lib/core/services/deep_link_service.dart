// lib/core/services/deep_link_service.dart
import 'package:flutter/material.dart';

class DeepLinkService {
  static const String baseUrl = 'https://viroomall.eg';

  static String getProductLink(String productId) =>
      '$baseUrl/product/$productId';

  static String getProfileLink(String userId) => '$baseUrl/profile/$userId';

  static void navigateToProduct(BuildContext context, String productId) {
    Navigator.pushNamed(context, '/product', arguments: productId);
  }

  static void navigateToProfile(BuildContext context, String userId) {
    Navigator.pushNamed(context, '/profile/$userId');
  }
}
