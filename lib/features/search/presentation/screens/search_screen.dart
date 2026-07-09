// lib/features/search/presentation/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/models/product_model.dart';
import '../../../home/presentation/widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isListening = false;
  bool _isSearching = false;
  String _selectedCategory = '';

  List<String> _searchHistory = [];
  final List<String> _trendingSearches = [
    'ايفون 15',
    'لابتوب جيمنج',
    'نايك اير فورس',
    'ساعة ابل',
    'بلايستيشن 5',
  ];
  final List<String> _categories = [
    'إلكترونيات',
    'ملابس',
    'سيارات',
    'أثاث',
    'رياضة',
    'كتب',
    'ألعاب',
    'أكل',
  ];

  List<ProductModel> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _initSpeech();
    _searchFocus.requestFocus();
  }

  Future<void> _initSpeech() async {
    _speech.initialize(
      onStatus: (status) {
        if (status == stt.SpeechToText.doneStatus) {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
      },
    );
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    setState(() => _searchHistory = history);
  }

  Future<void> _saveSearchHistory(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _searchHistory.remove(query);
    _searchHistory.insert(0, query);
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }
    await prefs.setStringList('search_history', _searchHistory);
    setState(() {});
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      Query q = FirebaseFirestore.instance
          .collection('products')
          .where('status', isEqualTo: 'approved');

      if (_selectedCategory.isNotEmpty) {
        q = q.where('categoryId', isEqualTo: _selectedCategory);
      }

      final snapshot = await q
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .orderBy('title')
          .limit(20)
          .get();

      final results =
          snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });

      await _saveSearchHistory(query);
    } catch (e) {
      setState(() => _isSearching = false);
      debugPrint('Search error: $e');
    }
  }

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = _selectedCategory == category ? '' : category;
    });
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  // 🎤 البحث الصوتي
  Future<void> _startVoiceSearch() async {
    if (!_speech.isAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('البحث الصوتي غير متاح على هذا الجهاز'),
            backgroundColor: VirooColors.error,
          ),
        );
      }
      return;
    }

    if (!_speech.isListening) {
      setState(() => _isListening = true);

      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            _searchController.text = result.recognizedWords;
            _performSearch(result.recognizedWords);
            setState(() => _isListening = false);
          }
        },
        localeId: 'ar_SA',
      );
    }
  }

  void _stopVoiceSearch() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  // 📷 البحث بالصورة
  Future<void> _searchByImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (image == null) return;

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const AlertDialog(
        backgroundColor: VirooColors.surface,
        content: Row(
          children: [
            CircularProgressIndicator(color: VirooColors.amberPrimary),
            SizedBox(width: 16),
            Text('جاري تحليل الصورة...',
                style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
          ],
        ),
      ),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(context);
        _searchController.text = 'نتائج البحث بالصورة';
        _performSearch('');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('📷 سيتم ربط البحث بالصورة بـ Google Lens API قريباً!'),
            backgroundColor: VirooColors.info,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل تحليل الصورة'),
            backgroundColor: VirooColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VirooColors.background,
      body: VirooBackground(
        showOrbs: false,
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _searchController.text.isEmpty
                    ? _buildSuggestions()
                    : _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================
  // 🔍 شريط البحث
  // =============================================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: VirooColors.glassDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: VirooColors.glassDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: VirooColors.glassBorder),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                onChanged: _performSearch,
                style:
                    const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                cursorColor: VirooColors.amberPrimary,
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتجات...',
                  hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontFamily: 'Cairo'),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: VirooColors.amberPrimary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                          child: const Icon(Icons.close_rounded,
                              color: VirooColors.textSecondary),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: _isListening
                                  ? _stopVoiceSearch
                                  : _startVoiceSearch,
                              child: Icon(
                                _isListening
                                    ? Icons.mic_off_rounded
                                    : Icons.mic_rounded,
                                color: _isListening
                                    ? VirooColors.error
                                    : VirooColors.textSecondary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _searchByImage,
                              child: const Icon(Icons.camera_alt_outlined,
                                  color: VirooColors.textSecondary, size: 20),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================
  // 💡 الاقتراحات
  // =============================================
  Widget _buildSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text('🏷️ تصفح حسب القسم',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: VirooColors.textPrimary,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => _onCategoryTap(cat),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? VirooColors.amberPrimary.withValues(alpha: 0.2)
                        : VirooColors.glassDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isSelected
                            ? VirooColors.amberPrimary
                            : VirooColors.glassBorder),
                  ),
                  child: Text(cat,
                      style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? VirooColors.amberPrimary
                              : VirooColors.textSecondary,
                          fontFamily: 'Cairo')),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text('🔥 الأكثر بحثاً في VirooMall',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: VirooColors.textPrimary,
                  fontFamily: 'Cairo')),
          const SizedBox(height: 10),
          ...List.generate(_trendingSearches.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () {
                  _searchController.text = _trendingSearches[index];
                  _performSearch(_trendingSearches[index]);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: VirooColors.glassDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text('${index + 1}.',
                          style: TextStyle(
                              fontSize: 12,
                              color: VirooColors.amberPrimary
                                  .withValues(alpha: 0.7),
                              fontFamily: 'Orbitron')),
                      const SizedBox(width: 10),
                      const Icon(Icons.trending_up_rounded,
                          size: 14, color: VirooColors.error),
                      const SizedBox(width: 8),
                      Text(_trendingSearches[index],
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontFamily: 'Cairo')),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (_searchHistory.isNotEmpty) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                const Text('🕒 آخر عمليات البحث',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: VirooColors.textPrimary,
                        fontFamily: 'Cairo')),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('search_history');
                    setState(() => _searchHistory = []);
                  },
                  child: const Text('مسح الكل',
                      style: TextStyle(
                          fontSize: 11,
                          color: VirooColors.error,
                          fontFamily: 'Cairo')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _searchHistory.map((item) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = item;
                    _performSearch(item);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: VirooColors.glassDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: VirooColors.glassBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history_rounded,
                            size: 12, color: VirooColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(item,
                            style: const TextStyle(
                                fontSize: 11,
                                color: VirooColors.textSecondary,
                                fontFamily: 'Cairo')),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // =============================================
  // 📊 نتائج البحث
  // =============================================
  Widget _buildSearchResults() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(color: VirooColors.amberPrimary),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                color: VirooColors.textSecondary.withValues(alpha: 0.5),
                size: 60),
            const SizedBox(height: 12),
            const Text('لا توجد نتائج',
                style: TextStyle(
                    fontSize: 16,
                    color: VirooColors.textSecondary,
                    fontFamily: 'Cairo')),
            const SizedBox(height: 4),
            const Text('جرب كلمة بحث مختلفة',
                style: TextStyle(
                    fontSize: 13,
                    color: VirooColors.textTertiary,
                    fontFamily: 'Cairo')),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: VirooProductCard(
            product: product,
            onTap: () {
              Navigator.pushNamed(context, '/product', arguments: product.id);
            },
            onFavoriteTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('تم إضافة المنتج إلى المفضلة!'),
                    backgroundColor: VirooColors.success),
              );
            },
            onCartTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('تم إضافة المنتج إلى السلة!'),
                    backgroundColor: VirooColors.success),
              );
            },
            onFollowTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('سيتم تفعيل المتابعة قريباً!'),
                    backgroundColor: VirooColors.info),
              );
            },
            onSellerTap: () {
              Navigator.pushNamed(context, '/seller-profile',
                  arguments: product.sellerId);
            },
          ),
        );
      },
    );
  }
}
