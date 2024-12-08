import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationState {
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  final bool isSourceModelDownloaded;
  final bool isTargetModelDownloaded;
  final String translatedText;
  final bool isLoading;

  TranslationState({
    required this.sourceLanguage,
    required this.targetLanguage,
    this.isSourceModelDownloaded = false,
    this.isTargetModelDownloaded = false,
    this.translatedText = '',
    this.isLoading = false,
  });

  TranslationState copyWith({
    TranslateLanguage? sourceLanguage,
    TranslateLanguage? targetLanguage,
    bool? isSourceModelDownloaded,
    bool? isTargetModelDownloaded,
    String? translatedText,
    bool? isLoading,
  }) {
    return TranslationState(
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      isSourceModelDownloaded:
      isSourceModelDownloaded ?? this.isSourceModelDownloaded,
      isTargetModelDownloaded:
      isTargetModelDownloaded ?? this.isTargetModelDownloaded,
      translatedText: translatedText ?? this.translatedText,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
