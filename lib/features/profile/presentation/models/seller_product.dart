// Seller Product Model
// lib/features/profile/presentation/models/seller_product.dart
class SellerProduct {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final int views;
  final int clicks;
  final int sales;
  final String status;
  final int daysLeft;

  SellerProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.views,
    required this.clicks,
    required this.sales,
    required this.status,
    required this.daysLeft,
  });

  static List<SellerProduct> mockProducts() {
    return [
      SellerProduct(
        id: '1',
        title: 'آيفون 15 برو ماكس',
        price: 45999,
        imageUrl: 'https://picsum.photos/200/200?random=1',
        views: 1250,
        clicks: 342,
        sales: 15,
        status: 'active',
        daysLeft: 22,
      ),
      SellerProduct(
        id: '2',
        title: 'لابتوب ديل XPS 15',
        price: 32999,
        imageUrl: 'https://picsum.photos/200/200?random=2',
        views: 3420,
        clicks: 1205,
        sales: 42,
        status: 'active',
        daysLeft: 18,
      ),
      SellerProduct(
        id: '3',
        title: 'ساعة ابل ووتش SE',
        price: 3999,
        imageUrl: 'https://picsum.photos/200/200?random=3',
        views: 856,
        clicks: 234,
        sales: 8,
        status: 'expiring',
        daysLeft: 5,
      ),
      SellerProduct(
        id: '4',
        title: 'سماعات ايربودز برو',
        price: 2499,
        imageUrl: 'https://picsum.photos/200/200?random=4',
        views: 2100,
        clicks: 876,
        sales: 28,
        status: 'expiring',
        daysLeft: 3,
      ),
      SellerProduct(
        id: '5',
        title: 'شاحن لاسلكي',
        price: 599,
        imageUrl: 'https://picsum.photos/200/200?random=5',
        views: 234,
        clicks: 45,
        sales: 2,
        status: 'expired',
        daysLeft: -2,
      ),
      SellerProduct(
        id: '6',
        title: 'جراب آيفون سيليكون',
        price: 299,
        imageUrl: 'https://picsum.photos/200/200?random=6',
        views: 156,
        clicks: 23,
        sales: 1,
        status: 'expired',
        daysLeft: -5,
      ),
    ];
  }
}
