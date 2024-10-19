import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_to_text/main.dart';
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
        title: const Text("TextExtractTo", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: () {
              if (AdaptiveTheme.of(context).mode.isDark) {
                AdaptiveTheme.of(context).setLight();
              } else {
                AdaptiveTheme.of(context).setDark();
              }
            },
            icon: Icon(
              AdaptiveTheme.of(context).mode.isDark ? Icons.sunny : Icons.nightlight,
              color: Colors.white,
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
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
              onPressed: copyText,
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.copy, color: Colors.white),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: 2,
              onPressed: () {},
              backgroundColor: Colors.green,
              child: const Icon(Icons.picture_as_pdf, color: Colors.white),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              heroTag: 3,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const EditTextScreen()));
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
