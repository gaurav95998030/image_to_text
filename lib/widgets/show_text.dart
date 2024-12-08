import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_to_text/providers/recogonized_text_provider.dart';

class ShowText extends StatefulWidget {
  const ShowText({super.key});

  @override
  State<ShowText> createState() => _ShowTextState();
}

class _ShowTextState extends State<ShowText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Consumer(
          builder: (context, ref, child) {
            String text = ref.watch(recogonizedTextProvider);

            return AnimatedTextKit(
              key: UniqueKey(),
              animatedTexts: [
                TypewriterAnimatedText(
                  text.isEmpty ? "Nothing to Recognize" : text,
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  speed: const Duration(milliseconds: 50),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            );
          },
        ),
      ),
    );
  }
}
