
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_to_text/features/pdf/provider/pdf_provider.dart';
import 'package:image_to_text/screens/edit_text.dart';
import 'package:image_to_text/widgets/image_picker.dart';
import 'package:image_to_text/widgets/show_text.dart';
import '../providers/recogonized_text_provider.dart';
import '../widgets/drawer.dart';



class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PdfProviderState>(
      pdfProvider,
          (previous, next) {


        if (next is PdfProviderLoading) {
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
      Clipboard.setData(ClipboardData(text: ref.watch(recogonizedTextProvider)));
      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Extracted Text Copied"),
        behavior: SnackBarBehavior.fixed,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.text_snippet, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            const Text(
              "TextExtractTo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.black45,
        backgroundColor: Colors.blueAccent.shade700,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     if (AdaptiveTheme.of(context).mode.isDark) {
          //       AdaptiveTheme.of(context).setLight();
          //     } else {
          //       AdaptiveTheme.of(context).setDark();
          //     }
          //   },
          //   icon: Icon(
          //     AdaptiveTheme.of(context).mode.isDark ? Icons.sunny : Icons.nightlight,
          //     color: Colors.yellowAccent,
          //   ),
          //   tooltip: 'Toggle Theme',
          // ),
        ],
        // leading: IconButton(
        //   icon: const Icon(Icons.menu, color: Colors.white),
        //   onPressed: () {
        //     // Your menu logic here
        //   },
        // ),
      ),

        drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload and Extract Text",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  PickImage(),
                  SizedBox(height: 30),
                  ShowText(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 1,
              onPressed: (){
                if(ref.read(recogonizedTextProvider).isEmpty) {
                  const snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text("Please Select Image first"),
                    behavior: SnackBarBehavior.fixed,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  copyText();
                }

              },
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.copy, color: Colors.white),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: 2,
              onPressed: () {
                if(ref.read(recogonizedTextProvider).isEmpty) {
                  const snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text("Please Select Image first"),
                    behavior: SnackBarBehavior.fixed,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  ref.read(pdfProvider.notifier).sharePdf(ref.read(recogonizedTextProvider));
                }

              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.picture_as_pdf, color: Colors.white),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: 3,
              onPressed: () {
                if(ref.read(recogonizedTextProvider).isEmpty) {
                  const snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text("Please Select Image first"),
                    behavior: SnackBarBehavior.fixed,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const EditTextScreen()));
                }

              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.edit, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
