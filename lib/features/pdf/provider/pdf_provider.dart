



import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repo/pdf_service.dart';

class PdfProviderState{}


class PdfProviderLoading extends PdfProviderState{}

class PdfShareSuccessFull extends PdfProviderState{}

class PdfShareInitial extends PdfProviderState{}

class PdfShareFailed extends PdfProviderState{}

class PdfShareError extends PdfProviderState{
  final String msg;

  PdfShareError({required this.msg});
}




class PdfProviderNotifier extends StateNotifier<PdfProviderState> {
  Ref ref;
  PdfProviderNotifier(this. ref) : super(PdfShareInitial());



  void sharePdf(String text)async{


    state = PdfProviderLoading();
    try{

      final pdfService = ref.read(pdfServiceProvider);

     bool isShared =await  pdfService.generatePdfAndShare(text);

     if(isShared){
       state = PdfShareSuccessFull();
     }else{
       state = PdfShareFailed();
     }






    }catch(e){
      state = PdfShareError(msg: 'Some error occured $e');
    }

  }
}



final pdfProvider = StateNotifierProvider<PdfProviderNotifier,PdfProviderState>((ref)=>PdfProviderNotifier(ref));