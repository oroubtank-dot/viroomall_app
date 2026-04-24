// lib/features/product/presentation/widgets/product_details/product_image_gallery.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_widgets.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;

  const ProductImageGallery({super.key, required this.images});

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الصورة الرئيسية
        GestureDetector(
          onTap: () => _showFullScreen(context),
          child: GlassContainer(
            height: 280,
            width: double.infinity,
            borderRadius: BorderRadius.circular(20),
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: widget.images.isNotEmpty
                  ? Image.memory(
                      base64Decode(widget.images[_currentIndex]),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (c, e, s) => _placeholder(),
                    )
                  : _placeholder(),
            ),
          ),
        ),
        // مؤشرات الصور
        if (widget.images.length > 1) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _currentIndex == index
                            ? VirooColors.amberPrimary
                            : VirooColors.glassBorder,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(widget.images[index]),
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => _placeholder(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: VirooColors.amberPrimary.withOpacity(0.1),
      child: const Center(
        child: Icon(Icons.image_rounded,
            color: VirooColors.amberPrimary, size: 60),
      ),
    );
  }

  void _showFullScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: widget.images.isNotEmpty
                  ? Image.memory(
                      base64Decode(widget.images[_currentIndex]),
                      fit: BoxFit.contain,
                    )
                  : _placeholder(),
            ),
          ),
        ),
      ),
    );
  }
}
