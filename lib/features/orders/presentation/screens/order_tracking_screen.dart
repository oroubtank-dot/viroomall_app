// lib/features/orders/presentation/screens/order_tracking_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/models/order_model.dart';
import '../widgets/tracking_timeline.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late OrderStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    const isBuyer = true;
    final canConfirm = _currentStatus == OrderStatus.delivered && isBuyer;
    final canRate = _currentStatus == OrderStatus.confirmed && isBuyer;

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        title: const Text('تتبع الطلب',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold)),
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
            if (canConfirm)
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlowingButton(
                  onPressed: _showConfirmDialog,
                  text: 'تأكيد استلام الطلب',
                  icon: Icons.check_circle_rounded,
                ),
              ),
            if (canRate)
              Padding(
                padding: const EdgeInsets.all(20),
                child: GlowingButton(
                  onPressed: () => _showRatingDialog(context),
                  text: 'تقييم المنتج',
                  icon: Icons.star_rounded,
                ),
              ),
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
        title: const Text('تأكيد الاستلام',
            style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
        content: const Text('هل تأكدت من استلام المنتج؟',
            style: TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء',
                style: TextStyle(
                    color: VirooColors.textSecondary, fontFamily: 'Cairo')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDelivery();
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: VirooColors.success),
            child: const Text('تأكيد',
                style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }

  void _confirmDelivery() {
    setState(() {
      _currentStatus = OrderStatus.confirmed;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تأكيد استلام الطلب بنجاح!'),
        backgroundColor: VirooColors.success,
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: VirooColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تقييم المنتج',
            style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('كيف تقيم هذا المنتج؟',
                style: TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    _submitRating(index + 1);
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.star_rounded,
                    color: VirooColors.warning,
                    size: 40,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _submitRating(int rating) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('شكراً لتقييمك بـ $rating نجوم!'),
        backgroundColor: VirooColors.success,
      ),
    );
  }
}
