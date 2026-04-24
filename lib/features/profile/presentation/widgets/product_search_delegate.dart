// Product Search Delegate
// lib/features/profile/presentation/widgets/product_search_delegate.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../models/seller_product.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<SellerProduct> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _buildSearchResults(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _buildSearchResults(suggestions);
  }

  Widget _buildSearchResults(List<SellerProduct> results) {
    return VirooBackground(
      showOrbs: true,
      themeColor: VirooColors.primary,
      child: results.isEmpty
          ? const Center(
              child: Text('لا توجد نتائج',
                  style: TextStyle(color: Colors.white, fontFamily: 'Cairo')))
          : ListView.builder(
              itemCount: results.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final product = results[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(product.imageUrl,
                        width: 50, height: 50, fit: BoxFit.cover),
                  ),
                  title: Text(product.title,
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'Cairo')),
                  subtitle: Text('${product.price} ج.م',
                      style: const TextStyle(
                          color: VirooColors.primary, fontFamily: 'Orbitron')),
                  onTap: () => close(context, product.id),
                );
              },
            ),
    );
  }
}
