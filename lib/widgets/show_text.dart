


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
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(

    padding: EdgeInsets.only(top: 10,left: 20,bottom: 10),
    width: double.infinity,

           decoration: BoxDecoration(
    color: Colors.grey,
     borderRadius: BorderRadius.circular(16)
           ),

    child:  Consumer(

    builder: (context,ref,child) {

      String text = ref.watch(recogonizedTextProvider);


      return AnimatedTextKit(
        key:  UniqueKey(),
        animatedTexts: [
          TypewriterAnimatedText(
            text==''?"Nothing to Recognize":text,
            textStyle: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            speed: const Duration(milliseconds: 30),
          ),
        ],

        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 1000),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
      );
    }
          ),
          );
  }
}
