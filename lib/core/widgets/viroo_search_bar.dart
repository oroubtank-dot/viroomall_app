// lib/core/widgets/viroo_search_bar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../../features/search/presentation/providers/search_provider.dart';

class VirooSearchBar extends ConsumerStatefulWidget {
  const VirooSearchBar({super.key});

  @override
  ConsumerState<VirooSearchBar> createState() => _VirooSearchBarState();
}

class _VirooSearchBarState extends ConsumerState<VirooSearchBar> {
  final _controller = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      ref.read(searchProvider.notifier).search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: VirooColors.glassDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: VirooColors.glassBorder, width: 1.5),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search_rounded,
                    color: VirooColors.amberPrimary, size: 24),
                onPressed: _performSearch,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style:
                      const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                  onSubmitted: (_) => _performSearch(),
                  onChanged: (value) {
                    if (value.length >= 2) {
                      ref.read(searchProvider.notifier).search(value);
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن منتج...',
                    hintStyle: TextStyle(
                        color: VirooColors.textSecondary, fontFamily: 'Cairo'),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (_controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: VirooColors.textSecondary, size: 20),
                  onPressed: () {
                    _controller.clear();
                    ref.read(searchProvider.notifier).clearSearch();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
