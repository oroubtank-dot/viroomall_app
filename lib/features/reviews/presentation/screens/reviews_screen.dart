// lib/features/reviews/presentation/screens/reviews_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../providers/reviews_provider.dart';
import '../widgets/review_card.dart';
import '../widgets/rating_stars.dart';
import '../widgets/rating_dialog.dart';

class ReviewsScreen extends ConsumerWidget {
  final String productId;
  final String productTitle;

  const ReviewsScreen({
    super.key,
    required this.productId,
    required this.productTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(productReviewsProvider(productId));
    final ratingAsync = ref.watch(productRatingProvider(productId));
    final countAsync = ref.watch(productReviewCountProvider(productId));

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('⭐ التقييمات والمراجعات',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: const Color(0xFFFFB800),
        child: Column(
          children: [
            // ملخص التقييم
            GlassContainer(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  ratingAsync.when(
                    data: (rating) => Column(
                      children: [
                        Text('${rating.toStringAsFixed(1)}',
                            style: const TextStyle(
                                color: Color(0xFFFFB800),
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Orbitron')),
                        RatingStars(rating: rating, size: 16),
                        const SizedBox(height: 4),
                        countAsync.when(
                          data: (count) => Text('$count تقييم',
                              style: const TextStyle(
                                  color: VirooColors.textSecondary,
                                  fontSize: 12,
                                  fontFamily: 'Cairo')),
                          loading: () => const SizedBox(),
                          error: (_, __) => const SizedBox(),
                        ),
                      ],
                    ),
                    loading: () => const CircularProgressIndicator(
                        color: Color(0xFFFFB800)),
                    error: (_, __) => const Text('خطأ',
                        style: TextStyle(color: VirooColors.error)),
                  ),
                  const Spacer(),
                  GlowingButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => RatingDialog(
                          productId: productId,
                          productTitle: productTitle,
                          onRated: () {},
                        ),
                      );
                    },
                    text: '✍️ اكتب تقييم',
                    width: 140,
                    height: 44,
                    backgroundColor: const Color(0xFFFFB800),
                  ),
                ],
              ),
            ),
            // قائمة التقييمات
            Expanded(
              child: reviewsAsync.when(
                data: (reviews) => reviews.isEmpty
                    ? const Center(
                        child: EmptyState(
                          icon: Icons.rate_review_outlined,
                          title: 'لا توجد تقييمات',
                          subtitle: 'كن أول من يقيم هذا المنتج',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          return ReviewCard(review: reviews[index]);
                        },
                      ),
                loading: () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFFB800))),
                error: (_, __) => const Center(
                    child: Text('❌ حدث خطأ',
                        style: TextStyle(
                            color: VirooColors.error, fontFamily: 'Cairo'))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
