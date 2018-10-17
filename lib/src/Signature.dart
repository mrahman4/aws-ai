import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:crypto/src/digest_sink.dart';
import 'package:intl/intl.dart';

class Signature {
  Signature();

  static String generateSignature(
      String endpoint,
      String service,
      String region,
      String secretKey,
      String httpMethod,
      var now,
      String queryStringParamters,
      Map<String, String> headerParamters,
      String body) {
    if (secretKey.isEmpty) {
      throw ("No keys provided");
    }

    var amzFormatter = new DateFormat("yyyyMMdd'T'HHmmss'Z'");
    String amzDate =
        amzFormatter.format(now); // format should be '20170104T233405Z"

    var dateFormatter = new DateFormat('yyyyMMdd');
    String dateStamp = dateFormatter.format(
        now); // Date w/o time, used in credential scope. format should be "20170104"

    //************* TASK 1: CREATE A CANONICAL REQUEST *************
    //http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html

    //Step 1 is to define the verb (GET, POST, etc.)--already done.

    //Step 2: Create canonical URI--the part of the URI from domain to query
    //string (use '/' if no path)
    String canonicalUri = '/';

    //Step 3: Create the canonical query string.
    // In case of Post, request parameters are passed in the body of the request and the query string
    //is blank.
    String canonicalQuerystring = queryStringParamters;

    //Step 4: Create the canonical headers. Header names must be trimmed
    //and lowercase, and sorted in code point order from low to high.
    //Note that there is a trailing \n.
    String canonicalHeaders = _getCanonicalFromDictionary(headerParamters);

    //Step 5: Create the list of signed headers. This lists the headers
    //in the canonical_headers list, delimited with ";" and in alpha order.
    //Note: The request can include any headers; canonical_headers and
    //signed_headers include those that you want to be included in the
    //hash of the request. "Host" and "x-amz-date" are always required.
    //For DynamoDB, content-type and x-amz-target are also required.
    String signedHeaders = _getSignedParamters(headerParamters);

    //Step 6: Create payload hash. In case of POST, the payload (body of
    //the request) contains the request parameters.
    //In case of GET body will be empty
    //String payload_hash = hashlib.sha256(utf8.encode(body)).hexdigest();
    var payloadHash = _digest(body);

    //Step 7: Combine elements to create canonical request
    String canonicalRequest = httpMethod +
        '\n' +
        canonicalUri +
        '\n' +
        canonicalQuerystring +
        '\n' +
        canonicalHeaders +
        '\n' +
        signedHeaders +
        '\n' +
        payloadHash.toString();
    var digest1 = _digest(canonicalRequest);

    //************* TASK 2: CREATE THE STRING TO SIGN*************
    //Match the algorithm to the hashing algorithm you use, either SHA-1 or
    //SHA-256 (recommended)
    String algorithm = 'AWS4-HMAC-SHA256';
    String credentialScope =
        dateStamp + '/' + region + '/' + service + '/' + 'aws4_request';
    String stringToSign = algorithm +
        '\n' +
        amzDate +
        '\n' +
        credentialScope +
        '\n' +
        digest1.toString();

    var signature;
    try {
      //************* TASK 3: CALCULATE THE SIGNATURE *************
      //Create the signing key using the function defined above.
      var signingKey = _getSignatureKey(secretKey, dateStamp, region, service);

      //Sign the string_to_sign using the signing_key
      signature = _signHex(signingKey, stringToSign);
    } catch (e) {
      print(e);
    }

    return signature.toString();
  }

  static String _getCanonicalFromDictionary(Map<String, String> dictionary) {
    //OP format: 'content-type:' + content_type + '\n' + 'host:' + host + '\n' + 'x-amz-date:' + amz_date + '\n' + 'x-amz-target:' + amz_target + '\n'
    String output = "";

    void iterateMapEntry(key, value) {
      output += key + ":" + value + '\n';
    }

    dictionary.forEach(iterateMapEntry);

    return output;
  }

  static String _getSignedParamters(Map<String, String> dictionary) {
    //OP format : 'content-type;host;x-amz-date;x-amz-target'
    String output = "";

    void iterateMapEntry(key, value) {
      output += key + ";";
    }

    dictionary.forEach(iterateMapEntry);

    output = output.substring(0, output.length - 1);

    return output;
  }

  static _sign(var key, String msg) {
    var _msg = utf8.encode(msg);

    var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(_msg);

    return digest.bytes;
  }

  static _getSignatureKey(
      String key, String dateStamp, String regionName, String serviceName) {
    var _key = utf8.encode('AWS4' + key);

    var kDate = _sign(_key, dateStamp);

    var kRegion = _sign(kDate, regionName);

    var kService = _sign(kRegion, serviceName);

    var kSigning = _sign(kService, 'aws4_request');

    return kSigning;
  }

  static _digest(String message) {
    var firstChunk = utf8.encode(message);
    var ds = new DigestSink();
    var s = sha256.startChunkedConversion(ds);
    s.add(firstChunk);
    s.close();
    return ds.value;
  }

  /*static _digestForUTF8(var firstChunk)
  {
    var ds = new DigestSink();
    var s = sha256.startChunkedConversion(ds);
    s.add(firstChunk);
    s.close();
    return ds.value;
  }*/

  static _signHex(var key, String message) {
    var _msg = utf8.encode(message);

    var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(_msg);

    return digest;
  }
}
