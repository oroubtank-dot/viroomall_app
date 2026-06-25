// lib/features/orders/presentation/screens/order_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/models/order_model.dart';
import '../../../../core/services/auth_service.dart';
import '../widgets/tracking_timeline.dart';
import '../../../reviews/presentation/widgets/rating_dialog.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  ConsumerState<OrderTrackingScreen> createState() =>
      _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  late OrderStatus _currentStatus;
  bool _isRated = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
    _checkIfRated();
  }

  Future<void> _checkIfRated() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order.id)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _isRated = data['rated'] ?? false;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final isBuyer = user != null && user.uid == widget.order.buyerId;
    final isSeller = user != null && user.uid == widget.order.sellerId;

    // ✅ التقييم متاح للمشتري فقط بعد التسليم وقبل التأكيد
    final canRate = isBuyer &&
        (_currentStatus == OrderStatus.delivered ||
            _currentStatus == OrderStatus.confirmed) &&
        !_isRated;

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        title: const Text(
          'تتبع الطلب',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        child: Column(
          children: [
            _buildProductInfo(),
            Expanded(
              child: TrackingTimeline(
                currentStatus: _currentStatus,
                isBuyer: isBuyer,
                onStatusChanged: (newStatus) {
                  setState(() {
                    _currentStatus = newStatus;
                  });
                },
              ),
            ),

            // ✅ زر تقييم المنتج (للمشتري فقط بعد التسليم)
            if (canRate)
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlowingButton(
                  onPressed: () => _showRatingDialog(context),
                  text: '⭐ تقييم المنتج',
                  icon: Icons.star_rounded,
                  backgroundColor: VirooColors.warning,
                ),
              ),

            // ✅ تأكيد الاستلام (للمشتري)
            if (isBuyer && _currentStatus == OrderStatus.delivered)
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlowingButton(
                  onPressed: _showConfirmDialog,
                  text: '✅ تأكيد استلام الطلب',
                  icon: Icons.check_circle_rounded,
                  backgroundColor: VirooColors.success,
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return GlassContainer(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: VirooColors.glassDark,
              borderRadius: BorderRadius.circular(12),
              image: widget.order.productImage.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(widget.order.productImage),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: widget.order.productImage.isEmpty
                ? const Icon(Icons.shopping_bag,
                    color: VirooColors.textSecondary)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.order.productName,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.order.price.toStringAsFixed(0)} ج.م × ${widget.order.quantity}',
                  style: const TextStyle(
                    color: VirooColors.amberPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الإجمالي: ${(widget.order.price * widget.order.quantity).toStringAsFixed(0)} ج.م',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VirooColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'تأكيد الاستلام',
          style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
        ),
        content: const Text(
          'هل تأكدت من استلام المنتج؟',
          style: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                  color: VirooColors.textSecondary, fontFamily: 'Cairo'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDelivery();
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: VirooColors.success),
            child: const Text(
              'تأكيد',
              style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelivery() async {
    try {
      // تحديث حالة الطلب
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.order.id)
          .update({
        'status': OrderStatus.confirmed.name,
        'updatedAt': FieldValue.serverTimestamp(),
        'buyerConfirmed': true,
      });

      // تحديث إحصائيات البائع
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.order.sellerId)
          .update({
        'totalSales': FieldValue.increment(1),
      });

      setState(() {
        _currentStatus = OrderStatus.confirmed;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم تأكيد استلام الطلب بنجاح!'),
            backgroundColor: VirooColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ خطأ: ${e.toString()}'),
            backgroundColor: VirooColors.error,
          ),
        );
      }
    }
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => RatingDialog(
        productId: widget.order.productId,
        productTitle: widget.order.productName,
        orderId: widget.order.id,
        onRated: () {
          setState(() {
            _isRated = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('شكراً لتقييمك! ⭐'),
              backgroundColor: VirooColors.success,
            ),
          );
        },
      ),
    );
  }
}
