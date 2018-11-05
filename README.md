# aws_ai

Flutter package to wrap Amazon artificial intelligence (AI) services, which provide flutter community developers with the ability to add intelligence to their applications through an API call to pre-trained services rather than developing and training their own models.
Amazon AI services are : 
* Amazon Rekognition : built on technology used by Amazon Prime Photos to analyze billions of images daily, is a service that makes it easy to add image analysis to your applications. With Rekognition, you can detect objects, scenes, and faces in images, as well as search and compare faces between images.
* Amazon Translate : a neural machine translation service that delivers fast, high-quality, and affordable language translation.  
* Amazon Polly (still not implemented): a service that turns text into lifelike speech. Polly lets you create applications that speak in over two dozen languages with a wide variety of natural sounding male and female voices to enable you to build entirely new categories of speech-enabled products. 
* Amazon Lex (still not implemented) : uses the same technology as Amazon Alexa to provide advanced deep learning functionalities of automatic speech recognition (ASR) and natural language understanding (NLU) to enable you to build applications with conversational interfaces, commonly called chatbots.


## Translate
Sample Code

```Flutter
import 'package:aws_ai/src/TranslateHandler.dart';

TranslateHandler translate = new TranslateHandler(accessKey, secretKey, region); 
String output = await translate.translate(TranslateLanguages.auto, TranslateLanguages.fr, "اسمي محمد");
```

Output will be a String contains JSON object with below format 
```json
{
   "SourceLanguageCode": "string",
   "TargetLanguageCode": "string",
   "TranslatedText": "string"
}
```
"TranslatedText" will be in UTF8 format.


## Rekognition
* #### Face comparison (compareFaces)
Sample Code

```Flutter
import 'package:aws_ai/src/RekognitionHandler.dart';

File sourceImagefile, targetImagefile; //load source and target images in those File objects
String accessKey, secretKey, region ; //load your aws account info in those variables

RekognitionHandler rekognition = new RekognitionHandler(accessKey, secretKey, region); 
Future<String> labelsArray = rekognition.compareFaces(sourceImagefile, targetImagefile);
```

Output will be a String contains JSON object with below format 
```json
{
 "FaceMatches": [
    {
       "Face": {
          "BoundingBox": {
             "Height": "number",
             "Left": "number",
             "Top": "number",
             "Width": "number"
          },
          "Confidence": "number",
          "Landmarks": [
             {
                "Type": "string",
                "X": "number",
                "Y": "number"
             }
          ],
          "Pose": {
             "Pitch": "number",
             "Roll": "number",
             "Yaw": "number"
          },
          "Quality": {
             "Brightness": "number",
             "Sharpness": "number"
          }
       },
       "Similarity": "number"
    }
 ],
 "SourceImageFace": {
    "BoundingBox": {
       "Height": "number",
       "Left": "number",
       "Top": "number",
       "Width": "number"
    },
    "Confidence": "number"
 },
 "SourceImageOrientationCorrection": "string",
 "TargetImageOrientationCorrection": "string",
 "UnmatchedFaces": [
    {
       "BoundingBox": {
          "Height": "number",
          "Left": "number",
          "Top": "number",
          "Width": "number"
       },
       "Confidence": "number",
       "Landmarks": [
          {
             "Type": "string",
             "X": "number",
             "Y": "number"
          }
       ],
       "Pose": {
          "Pitch": "number",
          "Roll": "number",
          "Yaw": "number"
       },
       "Quality": {
          "Brightness": "number",
          "Sharpness": "number"
       }
    }
 ]
}
```

* #### Facial analysis (detectFaces)
Sample Code

```Flutter
import 'package:aws_ai/src/RekognitionHandler.dart';

File sourceImagefile; //load source image in this File object
String accessKey, secretKey, region ; //load your aws account info in those variables

RekognitionHandler rekognition = new RekognitionHandler(accessKey, secretKey, region);
Future<String> labelsArray = rekognition.detectFaces(sourceImagefile);
```

Output will be a String contains JSON object with below format 
```json
{
 "FaceDetails": [
    {
       "AgeRange": {
          "High": "number",
          "Low": "number"
       },
       "Beard": {
          "Confidence": "number",
          "Value": "boolean"
       },
       "BoundingBox": {
          "Height": "number",
          "Left": "number",
          "Top": "number",
          "Width": "number"
       },
       "Confidence": "number",
       "Emotions": [
          {
             "Confidence": "number",
             "Type": "string"
          }
       ],
       "Eyeglasses": {
          "Confidence": "number",
          "Value": "boolean"
       },
       "EyesOpen": {
          "Confidence": "number",
          "Value": "boolean"
       },
       "Gender": {
          "Confidence": "number",
          "Value": "string"
       },
       "Landmarks": [
          {
             "Type": "string",
             "X": "number",
             "Y": "number"
          }
       ],
       "MouthOpen": {
          "Confidence": "number",
          "Value": "boolean"
       },
       "Mustache": {
          "Confidence": "number",
          "Value": "boolean"
       },
       "Pose": {
          "Pitch": "number",
          "Roll": "number",
          "Yaw": "number"
       },
       "Quality": {
          "Brightness": "number",
          "Sharpness": "number"
       },
       "Smile": {
          "Confidence": "number",
          "Value": "boolean"
       },
       "Sunglasses": {
          "Confidence": "number",
          "Value": "boolean"
       }
    }
 ],
 "OrientationCorrection": "string"
}
```

* #### Unsafe image detection (detectModerationLabels)
Sample Code

```Flutter
import 'package:aws_ai/src/RekognitionHandler.dart';

File sourceImagefile; //load source image in this File object
String accessKey, secretKey, region ; //load your aws account info in those variables

RekognitionHandler rekognition = new RekognitionHandler(accessKey, secretKey, region);
Future<String> labelsArray = rekognition.detectModerationLabels(sourceImagefile);
```

Output will be a String contains JSON object with below format 
```json
{
 "ModerationLabels": [
    {
       "Confidence": "number",
       "Name": "string",
       "ParentName": "string"
    }
 ]
}
```

* #### Celebrity recognition (recognizeCelebrities)
Sample Code

```Flutter
import 'package:aws_ai/src/RekognitionHandler.dart';

File sourceImagefile; //load source image in this File object
String accessKey, secretKey, region ; //load your aws account info in those variables

RekognitionHandler rekognition = new RekognitionHandler(accessKey, secretKey, region);
Future<String> labelsArray = rekognition.recognizeCelebrities(sourceImagefile);
```

Output will be a String contains JSON object with below format 
```json
{
    "CelebrityFaces": [
      {
         "Face": {
            "BoundingBox": {
               "Height": "number",
               "Left": "number",
               "Top": "number",
               "Width": "number"
            },
            "Confidence": "number",
            "Landmarks": [
               {
                  "Type": "string",
                  "X": "number",
                  "Y": "number"
               }
            ],
            "Pose": {
               "Pitch": "number",
               "Roll": "number",
               "Yaw": "number"
            },
            "Quality": {
               "Brightness": "number",
               "Sharpness": "number"
            }
         },
         "Id": "string",
         "MatchConfidence": "number",
         "Name": "string",
         "Urls": [ "string" ]
      }
    ],
    "OrientationCorrection": "string",
    "UnrecognizedFaces": [
      {
         "BoundingBox": {
            "Height": "number",
            "Left": "number",
            "Top": "number",
            "Width": "number"
         },
         "Confidence": "number",
         "Landmarks": [
            {
               "Type": "string",
               "X": "number",
               "Y": "number"
            }
         ],
         "Pose": {
            "Pitch": "number",
            "Roll": "number",
            "Yaw": "number"
         },
         "Quality": {
            "Brightness": "number",
            "Sharpness": "number"
         }
      }
    ]
    }
```

* #### Text in image (detectText)
Sample Code

```Flutter
import 'package:aws_ai/src/RekognitionHandler.dart';

File sourceImagefile; //load source image in this File object
String accessKey, secretKey, region ; //load your aws account info in those variables

RekognitionHandler rekognition = new RekognitionHandler(accessKey, secretKey, region);
Future<String> labelsArray = rekognition.detectText(sourceImagefile);
```

Output will be a String contains JSON object with below format 
```json
{
 "TextDetections": [
    {
       "Confidence": "number",
       "DetectedText": "string",
       "Geometry": {
          "BoundingBox": {
             "Height": "number",
             "Left": "number",
             "Top": "number",
             "Width": "number"
          },
          "Polygon": [
             {
                "X": "number",
                "Y": "number"
             }
          ]
       },
       "Id": "number",
       "ParentId": "number",
       "Type": "string"
    }
 ]
}
```

* #### Object and scene detection (detectLabels)
Sample Code

```Flutter
import 'package:aws_ai/src/RekognitionHandler.dart';

File sourceImagefile; //load source image in this File object
String accessKey, secretKey, region ; //load your aws account info in those variables

RekognitionHandler rekognition = new RekognitionHandler(accessKey, secretKey, region);
Future<String> labelsArray = rekognition.detectLabels(sourceImagefile);
```

Output will be a String contains JSON object with below format 
```json
{
 "Labels": [
    {
       "Confidence": "number",
       "Name": "string"
    }
 ],
 "OrientationCorrection": "string"
}
```


