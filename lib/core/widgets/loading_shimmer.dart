// lib/core/widgets/loading_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// ✨ Loading Shimmer Widget
/// تأثير Shimmer أثناء التحميل
class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;

  const LoadingShimmer({
    Key? key,
    this.width = double.infinity,
    this.height = 200,
    this.borderRadius,
    this.shape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// ✨ Loading Grid Shimmer
/// شبكة من عناصر Shimmer
class LoadingGridShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final int crossAxisCount;

  const LoadingGridShimmer({
    Key? key,
    this.itemCount = 6,
    this.itemHeight = 200,
    this.crossAxisCount = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => LoadingShimmer(
        height: itemHeight,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

/// ✨ Loading List Shimmer
/// قائمة من عناصر Shimmer
class LoadingListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const LoadingListShimmer({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: LoadingShimmer(
          height: itemHeight,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
