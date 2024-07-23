

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
  void takeImage(ImageSource source) async{
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source:source,maxWidth: 600);
    if(pickedImage==null){
      return ;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });

    performRecoginition( selectedImage);
       //for receiving to parent
  }

  void performRecoginition(File? selectedImage) async{
    final inputImage = InputImage.fromFilePath(selectedImage!.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

   final recogizedText =   await textRecognizer.processImage(inputImage);
    ref.read(recogonizedTextProvider.notifier).update((s)=>recogizedText.text);

  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    Widget content = const Center(child: Text("Please select and Image first"));
    if(selectedImage!=null){
      content=  Image.file(selectedImage!,width: double.infinity, height: screenHeight*4, fit: BoxFit.cover,);
    }

    return Container(
      padding: const EdgeInsets.only(left: 16,top: 16,right: 16),
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: screenHeight*0.4,
            child:content,
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: (){
                  takeImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo),
                label: const Text("Gallery"),

              ),
              const SizedBox(width: 30,),
              TextButton.icon(
                onPressed: () {
                  takeImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                label: const Text("Camera"),

              )
            ],
          )
        ],
      ),
    );
  }
}
