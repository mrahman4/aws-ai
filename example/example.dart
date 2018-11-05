import 'package:aws_ai/src/RekognitionHandler.dart';
import 'package:aws_ai/src/TranslateHandler.dart';
import 'dart:async';
import 'dart:io';

main() async {

  File sourceImagefile; //load source image in this File object
  String  accessKey = "",
          secretKey = "",
          region    = "" ;

  RekognitionHandler rekognition = new RekognitionHandler(accessKey, secretKey, region);
  String labelsArray = await rekognition.detectLabels(sourceImagefile);
  print(labelsArray);



  TranslateHandler translate = new TranslateHandler(accessKey, secretKey, region);
  String output = await translate.translate(TranslateLanguages.ar, TranslateLanguages.en, "اسمي محمد");
  print(output);
}
