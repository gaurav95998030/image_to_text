

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_to_text/features/translate/providers/text_transalation_state.dart';

class TranslationNotifier extends StateNotifier<TranslationState> {
  TranslationNotifier()
      : super(TranslationState(
    sourceLanguage: TranslateLanguage.english,
    targetLanguage: TranslateLanguage.hindi,
  ));

  final OnDeviceTranslatorModelManager modelManager =
  OnDeviceTranslatorModelManager();



  void selectSourceLanguage(TranslateLanguage targetLanguage){

    state = state.copyWith(targetLanguage: targetLanguage);

    print('gaurav');

  }

  Future<void> translate(String? text) async {
    if (text == null || text.isEmpty) {
      print("Text is null or empty");
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      // Check if source model is downloaded
      print("Checking if source model is downloaded...");
      bool isSourceModelDownloaded =
      await modelManager.isModelDownloaded(state.sourceLanguage.bcpCode);
      print("Source model download status: $isSourceModelDownloaded");

      // Download source model if not available
      if (!isSourceModelDownloaded) {
        try {
          print("Source model is not downloaded. Downloading...");
          isSourceModelDownloaded =
          await modelManager.downloadModel(state.sourceLanguage.bcpCode);
          print("Source model download completed: $isSourceModelDownloaded");
        } catch (e) {
          print("Error downloading source model: $e");
        }
      }

      // Check if target model is downloaded
      print("Checking if target model is downloaded...");
      bool isTargetModelDownloaded =
      await modelManager.isModelDownloaded(state.targetLanguage.bcpCode);
      print("Target model download status: $isTargetModelDownloaded");

      // Download target model if not available
      if (!isTargetModelDownloaded) {
        try {
          print("Target model is not downloaded. Downloading...");
          isTargetModelDownloaded =
          await modelManager.downloadModel(state.targetLanguage.bcpCode);
          print("Target model download completed: $isTargetModelDownloaded");
        } catch (e) {
          print("Error downloading target model: $e");
        }
      }

      // Update state
      state = state.copyWith(
        isSourceModelDownloaded: isSourceModelDownloaded,
        isTargetModelDownloaded: isTargetModelDownloaded,
      );

      if (isSourceModelDownloaded && isTargetModelDownloaded) {
        print("Both models downloaded. Initializing translator...");
        final translator = OnDeviceTranslator(
          sourceLanguage: state.sourceLanguage,
          targetLanguage: state.targetLanguage,
        );
        print("Translator initialized. Translating text...");
        final translatedText = await translator.translateText(text);
        print("Translation successful: $translatedText");

        state = state.copyWith(translatedText: translatedText);
      }
    } catch (err) {
      print("Error during translation: $err");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

}


final translationProvider =
StateNotifierProvider<TranslationNotifier, TranslationState>(
      (ref) => TranslationNotifier(),
);
