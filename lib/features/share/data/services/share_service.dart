// lib/features/share/data/services/share_service.dart
import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareProduct({
    required String title,
    required String price,
    required String deepLink,
  }) async {
    final message = '''
🛍️ *$title*
💰 السعر: $price ج.م

📱 شوف المنتج ده على VirooMall!
🔗 $deepLink

#VirooMall #تسوق_أونلاين
''';
    await Share.share(message, subject: title);
  }

  Future<void> shareProfile({
    required String sellerName,
    required String deepLink,
  }) async {
    final message = '''
👤 $sellerName
📱 شوف منتجاتي على VirooMall!
🔗 $deepLink

#VirooMall #تسوق_أونلاين
''';
    await Share.share(message, subject: sellerName);
  }

  Future<void> shareApp() async {
    const message = '''
🛍️ *VirooMall - سوق فيرو مول*
📱 تسوق، جملة، مستعمل، فرز إنتاج
💰 عروض وخصومات يومية
🔗 حمل التطبيق: https://viroomall.eg/app

#VirooMall #تسوق_أونلاين
''';
    await Share.share(message, subject: 'VirooMall');
  }
}
