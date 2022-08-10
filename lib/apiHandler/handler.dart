import 'dart:convert';
import 'dart:io';
import 'package:idyllic/proto/generated/p_buf.pb.dart' as buf;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> createFolderInAppDocDir(String folderName) async {

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final Directory appDocDirFolder = Directory('${appDocDir.path}/$folderName/');

  if (await appDocDirFolder.exists()) {
    return appDocDirFolder.path;
  } else {
    final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
    return appDocDirNewFolder.path;
  }
}

void write(String text, String filename) async {
  String path = await createFolderInAppDocDir("idyllic");
  final File file = File("$path/$filename");
  file.writeAsString(text);
}

Future<http.StreamedResponse> sendRequest(String address, String method, String header, Map<dynamic, dynamic> requestBody) async {
  print("requestBody: $requestBody");

  // var headers = {
  //   'Content-Type': 'application/json'
  // };
  // var request = http.Request(method, Uri.parse(address));
  // request.body = json.encode(requestBody);
  // request.headers.addAll(headers);
  
  // var headers = {
  //   'Content-Type': 'application/json'
  // };

  var headers = getHeader(header);
  
  var request = http.Request(method, Uri.parse(address));
  request.body = json.encode(requestBody);
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  return response;
}

Map<String, String> getHeader(String rawHeader) {
  Map<String, String> results = {};
  var headers = rawHeader.split("|||||");
  if (headers.length == 1) {
    headers = headers[0].split("\n");
  } else if (headers.length == 2) {
    headers = headers[0].split("\n") + headers[1].split("\n");
  }
  headers.forEach((element) {
    if (element.isNotEmpty) {
      var splited = element.split("=");
      results["${splited[0]}"] = "${splited[1]}";
    }    
  });
  return results;
}

Future<Map<dynamic, dynamic>> handleResponse(http.StreamedResponse response, String protocol, String proocolBody) async {
  if (response.statusCode == 200) {
    String body = await response.stream.bytesToString();
    if (protocol == "Json") {
      Map<dynamic, dynamic> res = json.decode(body);
      return res;
    } else if (protocol == "Protobuf") {

      String completedProtcolBody = [
        "syntax = \"proto3\";\n",
        "package main;\n",
        proocolBody,
      ].join("\n");

      write(completedProtcolBody, "p_buf.proto");

      await Process.run(
        "lib/proto/protoc",
        [
          "--dart_out=lib/proto/generated/",
          "--plugin=protoc-gen-dart=./lib/proto/protoc-gen-dart",
          "--proto_path=/home/shikhary10/Documents/idyllic/",
          "p_buf.proto"
        ]
      );

      List<String> classes = (extractClassName(proocolBody));

      String resR = await execute(body, classes[0]);
      return {"result":resR};

    } else {
      return {};
    }
  }else {
    return {"error": response.reasonPhrase!};
  }
}

Future<String> execute(String body, String clss) async {
  Object? s = buf.Parent.fromBuffer(body.codeUnits).toProto3Json();
  if (s != null) {
    return s.toString();
  } else {
    return "";
  }
}

List<String> extractClassName(String protocolBody) {
  String tword = "";
  List<String> target = [];
  for (int i = 0; i < protocolBody.length-6; i++) {
    if (protocolBody.substring(i, i+7) == "message") {
      for (int j = i+8; j < protocolBody.length; j++) {
        if (protocolBody[j] == " ") {
          break;
        }else {
          tword = tword + protocolBody[j];
        }
      }
      i = i+8;
      target.add(tword);
      tword = "";
    }
  }
  return target;
}

Extracted extractProtocol(String protocolBody) {
  int startingIndex = -1;
  int lastIndex = -1;
  String tword = "";
  String target = "";
  for (int i = 0; i < protocolBody.length-7; i++) {
    if (protocolBody.substring(i, i + 7) == "target") {
      startingIndex = i;
      target = "";
      for (int j = i; j < protocolBody.length; j++) {
        target = target + protocolBody[j];
      }
      if (target == "target") {
        for (int k = i+7; k < protocolBody.length; k++) {
          if (protocolBody[k] == ";") {
            lastIndex = k;
          } else {
            tword = tword + protocolBody[k];
          }
        }
      }
    } 
  }
  return Extracted([], ""); 
}

class Extracted {List<String> targets;
  String mainProtoColBody;

  Extracted(this.targets, this.mainProtoColBody);

  Map<dynamic, dynamic> toJson() {
    return {
      "targets": targets,
      "mainProtocolBody": mainProtoColBody
    };
  }
}