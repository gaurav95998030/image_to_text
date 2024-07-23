

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_to_text/providers/recogonized_text_provider.dart';

class EditTextScreen extends StatefulWidget {
  const EditTextScreen({super.key});

  @override
  State<EditTextScreen> createState() => _EditTextScreenState();
}

class _EditTextScreenState extends State<EditTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
        body: Consumer(
          builder: (context,ref,child) {
            String ? text = ref.read(recogonizedTextProvider);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: TextFormField(
                  initialValue: text,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(

                    label: Text("edit the exracted text"),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.redAccent)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blueAccent)
                      )
                  ),
                ),
              ),
            );
          }
        ),
    ) ;
  }
}
