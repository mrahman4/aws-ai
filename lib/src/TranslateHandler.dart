import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

import 'Signature.dart';
import 'package:flutter/foundation.dart';



enum TranslateLanguages {
  auto, //only for source language so Amazon auto detect the language
  en,     //English
  ar,     //Arabic
  zh,     //Chinese (Simplified)
  zh_TW,  //Chinese (Traditional) (zh-TW)
  cs,     //Czech (cs)
  fr,     //French (fr)
  de,     //German (de)
  it,     //Italian (it)
  ja,     //Japanese (ja)
  pt,     //Portuguese (pt)
  ru,     //Russian (ru)
  es,     //Spanish (es)
  tr      //Turkish (tr)
}

class TranslateHandler {
  final String _accessKey, _secretKey, _region;
  TranslateHandler(this._accessKey, this._secretKey, this._region);


  Future<String> _formatHttpRequest(String service, String amzTarget, String body) async {

    String endpoint = "https://$service.$_region.amazonaws.com/";
    String host = "$service.$_region.amazonaws.com";
    String httpMethod = "POST";


    var now = new DateTime.now().toUtc();
    var amzFormatter = new DateFormat("yyyyMMdd'T'HHmmss'Z'");
    String amzDate =
    amzFormatter.format(now); // format should be '20170104T233405Z"

    var dateFormatter = new DateFormat('yyyyMMdd');
    String dateStamp = dateFormatter.format(
        now); // Date w/o time, used in credential scope. format should be "20170104"

    int bodyLength = body.length;

    String queryStringParamters = "";
    Map<String, String> headerParamters = {
      "content-length": bodyLength.toString(),
      "content-type": "application/x-amz-json-1.1",
      "host": host,
      "x-amz-date": amzDate,
      "x-amz-target": amzTarget
    };

    String signature = Signature.generateSignature(
        endpoint,
        service,
        _region,
        _secretKey,
        httpMethod,
        now,
        queryStringParamters,
        headerParamters,
        body);

    String authorization =
        "AWS4-HMAC-SHA256 Credential=$_accessKey/$dateStamp/$_region/$service/aws4_request, SignedHeaders=content-length;content-type;host;x-amz-date;x-amz-target, Signature=$signature";
    headerParamters.putIfAbsent('Authorization', () => authorization);

    //String labelsArray = "";
    StringBuffer builder = new StringBuffer();
    try {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(endpoint));

      request.headers.set('content-length', headerParamters['content-length']);
      request.headers.set('content-type', headerParamters['content-type']);
      request.headers.set('host', headerParamters['host']);
      request.headers.set('x-amz-date', headerParamters['x-amz-date']);
      request.headers.set('x-amz-target', headerParamters['x-amz-target']);
      request.headers.set('Authorization', headerParamters['Authorization']);

      request.write(body);

      HttpClientResponse response = await request.close();

      await for (String a in utf8.decoder.bind(response)) {
        builder.write(a);
      }
    } catch (e) {
      print(e);
    }

    return Future.value(builder.toString());
  }


  Future<String> _translate(String sourceLanguage, String targetLanguage, var text) async {

    try {
    String amzTarget = "AWSShineFrontendService_20170701.TranslateText";
    String service = "translate";

    String body =
        '{"SourceLanguageCode":"$sourceLanguage", "TargetLanguageCode":"$targetLanguage", "Text":"$text"}';

    var response = await _formatHttpRequest(service, amzTarget, body);

    return response;

    } catch (e) {
      print(e);
      return "{}";
    }

  }

  Future<String> translate(
      TranslateLanguages _sourceLanguage, TranslateLanguages _targetLanguage, String _text) async {

    try
    {
      if( _targetLanguage == TranslateLanguages.auto )
      {
        throw("Target language can't be auto");
      }


      String sourceLanguage = _sourceLanguage != TranslateLanguages.zh_TW ? describeEnum(_sourceLanguage) : "zh-TW";
      String targetLanguage = _targetLanguage != TranslateLanguages.zh_TW ? describeEnum(_targetLanguage) : "zh-TW";


      var text = utf8.encode(_text);

      String response ,
          autoLanguage = sourceLanguage;

      if( (_sourceLanguage != TranslateLanguages.en) && (_targetLanguage != TranslateLanguages.en) )
      {
        response = await _translate(sourceLanguage, TranslateLanguages.en.toString(), text);
        sourceLanguage = describeEnum(TranslateLanguages.en) ;
        Map<String, dynamic> responseMap = json.decode(response);
        text = responseMap["TranslatedText"];
        autoLanguage  = responseMap["SourceLanguageCode"];
      }

      response = await _translate(sourceLanguage, targetLanguage, text);
      Map<String, dynamic> responseMap = json.decode(response);
      String translatedText = responseMap["TranslatedText"].toString();
      print(translatedText);

      String output = '{"SourceLanguageCode":"$autoLanguage", "TargetLanguageCode":"$targetLanguage", "TranslatedText": "$translatedText"}';

      return output;

    } catch (e) {
      print(e);
      return "{}";
    }

    /*
    Output will be in this format
    {
       "SourceLanguageCode": "string",
       "TargetLanguageCode": "string",
       "TranslatedText": "string"
    }
    */
  }

}
