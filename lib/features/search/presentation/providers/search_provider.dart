// lib/features/search/presentation/providers/search_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/product_model.dart';
import '../../../admin/data/product_repository.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

class SearchNotifier extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final Ref _ref;
  String _currentQuery = '';

  SearchNotifier(this._ref) : super(const AsyncValue.loading());

  ProductRepository get _repository => _ref.read(productRepositoryProvider);

  void search(String query) {
    _currentQuery = query;
    state = const AsyncValue.loading();

    _repository.searchProducts(query).listen(
      (products) {
        if (_currentQuery == query) {
          state = AsyncValue.data(products);
        }
      },
      onError: (error) {
        state = AsyncValue.error(error, StackTrace.current);
      },
    );
  }

  void clearSearch() {
    _currentQuery = '';
    search('');
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<ProductModel>>>(
        (ref) {
  return SearchNotifier(ref);
});
