// lib/features/reviews/presentation/widgets/rating_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../providers/reviews_provider.dart';
import '../../data/reviews_service.dart';
import '../../domain/models/review_model.dart';
import 'rating_stars.dart';

class RatingDialog extends ConsumerStatefulWidget {
  final String productId;
  final String productTitle;
  final VoidCallback onRated;

  const RatingDialog({
    super.key,
    required this.productId,
    required this.productTitle,
    required this.onRated,
  });

  @override
  ConsumerState<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends ConsumerState<RatingDialog> {
  double _rating = 5;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    setState(() => _isSubmitting = true);

    final review = ReviewModel(
      id: '',
      productId: widget.productId,
      userId: 'user_123',
      userName: 'مستخدم VirooMall',
      rating: _rating,
      comment: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    final service = ref.read(reviewsServiceProvider);
    await service.addReview(review);

    if (!mounted) return;

    setState(() => _isSubmitting = false);
    widget.onRated();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ تم إضافة تقييمك بنجاح! ⭐',
            style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: VirooColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: VirooColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('⭐ قيم المنتج',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.productTitle,
              style: const TextStyle(
                  color: VirooColors.textSecondary, fontFamily: 'Cairo'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 16),
          RatingStars(
            rating: _rating,
            size: 36,
            interactive: true,
            onRatingChanged: (val) => setState(() => _rating = val),
          ),
          const SizedBox(height: 4),
          Text(
            _getRatingLabel(_rating),
            style: const TextStyle(
                color: Color(0xFFFFB800),
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            decoration: InputDecoration(
              hintText: 'اكتب تعليقك... (اختياري)',
              hintStyle: TextStyle(
                  color: VirooColors.textSecondary.withAlpha(150),
                  fontFamily: 'Cairo'),
              filled: true,
              fillColor: VirooColors.glassDark,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء',
              style: TextStyle(
                  fontFamily: 'Cairo', color: VirooColors.textSecondary)),
        ),
        GlowingButton(
          onPressed: _isSubmitting ? () {} : _submitReview,
          text: _isSubmitting ? 'جاري...' : '✅ إرسال التقييم',
          width: 140,
          height: 40,
          backgroundColor: const Color(0xFFFFB800),
        ),
      ],
    );
  }

  String _getRatingLabel(double rating) {
    if (rating >= 5) return '⭐ ممتاز';
    if (rating >= 4) return '👍 جيد جداً';
    if (rating >= 3) return '👌 جيد';
    if (rating >= 2) return '😐 مقبول';
    return '👎 سيء';
  }
}
