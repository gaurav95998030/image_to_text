
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
   File? selectedImage;
  void takeProfileImage(ImageSource source) async{
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source:source,maxWidth: 600);
    if(pickedImage==null){
      return ;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });





  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            color: Colors.red,
            child:  Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap:()=> takeProfileImage(ImageSource.gallery),
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: selectedImage!=null?Image.file(selectedImage!, height:100,width:100,fit: BoxFit.cover,):const Icon(Icons.account_box,size: 100,)
                    ),
                  ),
                  const SizedBox(width: 12,),
                  const Text(
                    "Hi YourName!!",
                    style: TextStyle(
                        fontSize: 20
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
