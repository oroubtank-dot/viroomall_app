// lib/features/orders/presentation/widgets/rating_dialog.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';

class VirooRatingDialog extends StatefulWidget {
  final Function(int rating, String? comment) onConfirm;

  const VirooRatingDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<VirooRatingDialog> createState() => _VirooRatingDialogState();
}

class _VirooRatingDialogState extends State<VirooRatingDialog> {
  int _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (_rating == 0) return;

    if (_rating < 4 && _commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك اكتب تعليق للتقييم الأقل من 4 نجوم'),
          backgroundColor: VirooColors.error,
        ),
      );
      return;
    }

    widget.onConfirm(
        _rating,
        _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: BorderRadius.circular(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'تقييم المنتج',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 40,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            if (_rating > 0 && _rating < 4)
              TextField(
                controller: _commentController,
                style:
                    const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'اكتب تعليقك (إجباري للتقييم الأقل من 4 نجوم)',
                  hintStyle: TextStyle(
                      color: VirooColors.textSecondary.withOpacity(0.5),
                      fontFamily: 'Cairo'),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              )
            else if (_rating >= 4)
              TextField(
                controller: _commentController,
                style:
                    const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'اكتب تعليقك (اختياري)',
                  hintStyle: TextStyle(
                      color: VirooColors.textSecondary.withOpacity(0.5),
                      fontFamily: 'Cairo'),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'إلغاء',
                      style: TextStyle(
                          color: VirooColors.textSecondary,
                          fontFamily: 'Cairo'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlowingButton(
                    onPressed: _rating == 0 ? () {} : _handleConfirm,
                    text: 'تأكيد',
                    height: 45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
