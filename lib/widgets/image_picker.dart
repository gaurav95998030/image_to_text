import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text/providers/recogonized_text_provider.dart';

class PickImage extends ConsumerStatefulWidget {
  const PickImage({super.key});

  @override
  ConsumerState<PickImage> createState() => _PickImageState();
}

class _PickImageState extends ConsumerState<PickImage> {
  File? selectedImage;

  void takeImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });

    performRecoginition(selectedImage);
  }

  void performRecoginition(File? selectedImage) async {
    final inputImage = InputImage.fromFilePath(selectedImage!.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recogizedText = await textRecognizer.processImage(inputImage);
    ref.read(recogonizedTextProvider.notifier).update((s) => recogizedText.text);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    Widget content = const Center(
      child: Text(
        "Please select an image first",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black45,
        ),
      ),
    );

    if (selectedImage != null) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          selectedImage!,
          width: double.infinity,
          height: screenHeight * 0.4,
          fit: BoxFit.contain,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black26,
          //   blurRadius: 10,
          //   offset: Offset(0, 4),
          // ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.4,
            child: content,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  takeImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo),
                label: const Text("Gallery"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              ElevatedButton.icon(
                onPressed: () {
                  takeImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
