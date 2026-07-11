// lib/core/widgets/loading_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/loading_provider.dart';
import '../states/loading_state.dart';
import '../theme/app_colors.dart';

/// 🔄 Loading Overlay Widget
/// عرض overlay عند التحميل
class LoadingOverlay extends ConsumerWidget {
  final Widget child;
  final bool useGlobalProvider;

  const LoadingOverlay({
    Key? key,
    required this.child,
    this.useGlobalProvider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = useGlobalProvider
        ? ref.watch(loadingProvider)
        : LoadingState.initial;

    return Stack(
      children: [
        child,
        if (loadingState.isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(VirooColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}
