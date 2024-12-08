import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_to_text/features/translate/providers/text_transalation_state.dart';
import 'package:image_to_text/providers/recogonized_text_provider.dart';

import '../features/pdf/provider/pdf_provider.dart';
import '../features/translate/providers/text_translation_provider.dart';

class EditTextScreen extends ConsumerStatefulWidget {
  const EditTextScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditTextScreen> createState() => _EditTextScreenState();
}

class _EditTextScreenState extends ConsumerState<EditTextScreen> {
  final TranslateLanguage sourceLanguage = TranslateLanguage.english;
  final TranslateLanguage targetLanguage = TranslateLanguage.hindi;

  bool isSourceModalDownloaded = false;
  bool isTargetModalDownloaded = false;

  String translatedText = '';
  dynamic modelManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     modelManager = OnDeviceTranslatorModelManager();
  }

  // void handleTranslateClick(String? text) async {
  //   if (text != null) {
  //     try {
  //
  //       isSourceModalDownloaded = await modelManager.isModelDownloaded(sourceLanguage.bcpCode);
  //       isTargetModalDownloaded = await modelManager.isModelDownloaded(targetLanguage.bcpCode);
  //
  //
  //       if(!isSourceModalDownloaded){
  //         isSourceModalDownloaded = await modelManager.downloadModel(sourceLanguage.bcpCode);
  //       }
  //
  //       if(!isTargetModalDownloaded){
  //         isTargetModalDownloaded = await modelManager.downloadModel(targetLanguage.bcpCode);
  //       }
  //
  //       print(isTargetModalDownloaded);
  //       print(isSourceModalDownloaded);
  //
  //       if(isSourceModalDownloaded&&isTargetModalDownloaded){
  //         final onDeviceTranslator = OnDeviceTranslator(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);
  //         final String response = await onDeviceTranslator.translateText(text);
  //
  //
  //        setState(() {
  //          translatedText = response;
  //        });
  //       }
  //
  //
  //   }catch(err){
  //       print(err);
  //     }
  //   } else {
  //     print("Text is null");
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    ref.listen<PdfProviderState>(
      pdfProvider,
          (previous, next) {


        if (next is PdfProviderLoading) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Sharing"),
              content: Text("Please wait"),
            ),
          );
        }
        if (next is PdfShareSuccessFull) {

          Navigator.of(context).pop();

          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Success"),
              content: Text("Operation completed successfully!"),
            ),
          );
        }
        if (next is PdfShareError) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Error occurred"),
              content: Text("Some error occurred"),
            ),
          );
        }
      },
    );
    void copyText() {
      Clipboard.setData(ClipboardData(text: ref.watch(translationProvider).translatedText));
      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Extracted Text Copied"),
        behavior: SnackBarBehavior.fixed,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return Scaffold(
      appBar:AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            const Text(
              "Edit Extracted Text",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent.shade700,
        elevation: 6,
        shadowColor: Colors.black38,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Logic for saving or additional action
            },
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            tooltip: 'Save Changes',
          ),
        ],
      ),

        body: SingleChildScrollView(
          child: Consumer(
          builder: (context, ref, child) {

          
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
                        onChanged: (value){
                          ref.read(recogonizedTextProvider.notifier).update((cb)=>value);
                        },
                        initialValue: ref.read(recogonizedTextProvider),
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
                            Navigator.pop(context);
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Translate to',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            TranslationState state = ref.watch(translationProvider);
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<TranslateLanguage>(
                                  value: state.targetLanguage,
                                  items: TranslateLanguage.values.map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    ref
                                        .read(translationProvider.notifier)
                                        .selectSourceLanguage(value ?? TranslateLanguage.hindi);
                                  },
                                  dropdownColor: Colors.white,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            return ElevatedButton.icon(
                              onPressed: () {
                                ref
                                    .read(translationProvider.notifier)
                                    .translate(ref.read(recogonizedTextProvider));
                              },
                              icon: const Icon(
                                Icons.translate,
                                size: 16,
                              ),
                              label: const Text("Translate"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20,),
                    Consumer(
                        builder: (context,ref,child) {
                          TranslationState state = ref.watch(translationProvider);
          
                          if(state.isLoading){
                            return const Text('Loading');
                          }
                          return Text(state.translatedText, style: TextStyle(fontSize: 16),);
                        }
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: (){
                            if(ref.read(translationProvider).translatedText.isEmpty) {
                              const snackBar = SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text("Please Select Image first"),
                                behavior: SnackBarBehavior.fixed,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }else{
                              copyText();
                            }

                          }, icon: Icon(Icons.copy)),
                          IconButton(onPressed: (){
                            if(ref.read(translationProvider).translatedText.isEmpty) {
                              const snackBar = SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text("Please Select Image first"),
                                behavior: SnackBarBehavior.fixed,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }else{
                              ref.read(pdfProvider.notifier).sharePdf(ref.watch(translationProvider).translatedText);
                            }

                          }, icon: Icon(Icons.picture_as_pdf)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
                ),
        ),
    );
  }
}
