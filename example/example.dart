import 'package:aws_ai/src/RekognitionHandler.dart';
import 'dart:async';
import 'dart:io';

main() async {

  File sourceImagefile; //load source image in this File object
  String  accessKey = "",
          secretKey = "",
          region    = "" ;

  RekognitionHandler rekognition = new RekognitionHandler(accessKey, secretKey, region);
  Future<String> labelsArray = rekognition.detectLabels(sourceImagefile);
  print(labelsArray);
}
