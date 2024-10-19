import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_to_text/providers/recogonized_text_provider.dart';

class EditTextScreen extends StatefulWidget {
  const EditTextScreen({Key? key}) : super(key: key);

  @override
  State<EditTextScreen> createState() => _EditTextScreenState();
}

class _EditTextScreenState extends State<EditTextScreen> {
  final TranslateLanguage sourceLanguage = TranslateLanguage.english;
  final TranslateLanguage targetLanguage = TranslateLanguage.hindi;

  void handleTranslateClick(String? text) async {
    if (text != null) {
      try {
        print("Original text: $text");
        final onDeviceTranslator = OnDeviceTranslator(
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
        );
        print("Translator initialized");

        final modelManager = OnDeviceTranslatorModelManager();

        // Check if source model is downloaded
        final bool isSourceModelDownloaded =
        await modelManager.isModelDownloaded(sourceLanguage.bcpCode);
        print("Source model downloaded: $isSourceModelDownloaded");

        if (!isSourceModelDownloaded) {
          await modelManager.downloadModel(sourceLanguage.bcpCode);
          print("Source model downloaded");
        }

        // Check if target model is downloaded
        final bool isTargetModelDownloaded =
        await modelManager.isModelDownloaded(targetLanguage.bcpCode);
        print("Target model downloaded: $isTargetModelDownloaded");

        if (!isTargetModelDownloaded) {
          await modelManager.downloadModel(targetLanguage.bcpCode);
          print("Target model downloaded");
        } else {
          print("Target model is already downloaded.");
        }

        // Now perform translation
        final String translatedText =
        await onDeviceTranslator.translateText(text);
        print("Translated text: $translatedText");

      } catch (err) {
        print("Error during translation: $err");
      }
    } else {
      print("Text is null");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Extracted Text",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          String? text = ref.read(recogonizedTextProvider);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Edit the extracted text:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: text,
                      keyboardType: TextInputType.multiline,
                      maxLines: null, // Allows the input to expand as needed
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: "Extracted Text",
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey.shade700),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(width: 1.5, color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add functionality for saving the edited text
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        handleTranslateClick(text);
                      },
                      child: const Text("Translate"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
