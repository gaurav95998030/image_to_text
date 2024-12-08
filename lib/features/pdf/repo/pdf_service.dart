

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

final pdfServiceProvider = Provider<PdfService>((ref) => PdfService());

class PdfService {


  Future<bool> generatePdfAndShare(String text) async{
    final pdf = pw.Document();


    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text(text),
        ),
      ),);

        final output = await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'example.pdf',
    );


        return output;
  }

  }



