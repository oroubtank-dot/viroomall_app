// lib/features/admin/presentation/states/add_product_state.dart
import 'dart:io';

class AddProductState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final double uploadProgress;
  final List<File> images;
  final File? video;

  const AddProductState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.uploadProgress = 0.0,
    this.images = const [],
    this.video,
  });

  AddProductState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    double? uploadProgress,
    List<File>? images,
    File? video,
  }) {
    return AddProductState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      images: images ?? this.images,
      video: video ?? this.video,
    );
  }

  bool get hasError => errorMessage != null;
}
