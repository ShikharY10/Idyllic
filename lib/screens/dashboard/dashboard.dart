// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart' as highlight;
import 'package:highlight/languages/protobuf.dart' as protobuf_theme;
import 'package:highlight/languages/json.dart' as json_theme;
import 'package:highlight/languages/yaml.dart' as yaml_theme;
import '../../apiHandler/handler.dart';
import '../../protobuf/idyllic.pb.dart' as protobuf;
import '../../db/hivehandler.dart';
import '../../utils/widget/customradiobutton.dart';
import '../defaultpage.dart';

List<DropdownMenuItem<String>> get methodsItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Method", child: Text("Method")),
    const DropdownMenuItem(value: "GET", child: Text("GET")),
    const DropdownMenuItem(value: "POST", child: Text("POST")),
    const DropdownMenuItem(value: "PUT", child: Text("PUT")),
    const DropdownMenuItem(value: "DELETE", child: Text("DELETE")),
  ];
  return menuItems;
}

List<DropdownMenuItem<String>> get protocolItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Protocol", child: Text("Protocol")),
    const DropdownMenuItem(value: "Json", child: Text("Json")),
    const DropdownMenuItem(value: "Protobuf", child: Text("Protobuf")),
  ];
  return menuItems;
}

class Dashboard extends StatefulWidget {
  final String title;
  final HiveDB hive;
  final Stream uiRefresh;

  const Dashboard({
    super.key, 
    required this.title, 
    required this.hive,
    required this.uiRefresh
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  bool isRequestProcessing = false;

  bool isBodyOn = true;
  bool isParamsOn = false;
  bool isHeaderOn = false;

  Map<int,TextEditingController> controllers = {};

  Map<int, List<TextEditingController>> allControllers = {};

  TextEditingController addressController = TextEditingController();

  String? methodSelectedValue = "Method";
  String? protocolSelectedValue = "Protocol";

  late CodeController protocolController;
  late CodeController requestController;
  late CodeController responseController;

  late CodeController paramsController;
  late CodeController defaultHeaderController;
  late CodeController definedHeaderController;

  late protobuf.DashBoardHiveData myData;

  bool isStateManaged = false;
  String? myDataStr;

  void defaultInitializer() async {
    
    myDataStr = widget.hive.dashboardBox.get("${widget.title}box");

    if (myDataStr != null) {
      myData = protobuf.DashBoardHiveData.fromBuffer(myDataStr!.codeUnits);
    } else {
      myData = protobuf.DashBoardHiveData(
        address: "http://127.0.0.1:",
        method: null,
        protocol: null,
        header: "",
        requestBody: "",
        responseBody: "",
        protocolBody: ""
      );
    }

    protocolController.text = myData.protocolBody;
    requestController.text = myData.requestBody;
    responseController.text = myData.responseBody;

    addressController.text = myData.address;
    methodSelectedValue = myData.method.isEmpty ? "Method" : myData.method;
    protocolSelectedValue = myData.protocol.isEmpty ? "Protocol" : myData.protocol;

    paramsController.text = myData.params;
    List<String> headers = myData.header.split("|||||");
    defaultHeaderController.text = (headers.length == 2) ? headers[0] : "Content-Type=application/json\nservice=idyllic\nAccept=*/*\nConnection=keep-alive\nAccept-Encoding=gzip, deflate, br";
    definedHeaderController.text = (headers.length == 2) ? headers[1] : "";

    

  }

  void controllerInitializer() {
    // addressController.text = myData.address;

    protocolController = CodeController(
      text: "",
      language: protobuf_theme.protobuf,
      theme: highlight.atomOneDarkTheme,
      onChange: (value) {
        // updating the method value
        myData.protocolBody = value;
        widget.hive.dashboardBox.put(
          "${widget.title}box",
          String.fromCharCodes(myData.writeToBuffer())
        );
      }
    );

    requestController = CodeController(
      text: "",     // myData.requestBody,
      language: json_theme.json,
      theme: highlight.atomOneDarkTheme,
      onChange: (value) {
        // updating the method value
        myData.requestBody = value;
        widget.hive.dashboardBox.put(
          "${widget.title}box",
          String.fromCharCodes(myData.writeToBuffer())
        );
      }
    );

    responseController = CodeController(
      text: "",    // myData.responseBody,
      language: protobuf_theme.protobuf,
      theme: highlight.atomOneDarkTheme,
      onChange: (value) {
        // updating the method value
        myData.responseBody = value;
        widget.hive.dashboardBox.put(
          "${widget.title}box",
          String.fromCharCodes(myData.writeToBuffer())
        );
      }
    );

    paramsController = CodeController(
      text: "",
      language: yaml_theme.yaml,
      theme: highlight.atomOneDarkTheme,
      onChange: (value) {
        // updating the method value
        // var n = value.split("\n");
        // print(n);
        myData.params = value;
        widget.hive.dashboardBox.put(
          "${widget.title}box",
          String.fromCharCodes(myData.writeToBuffer())
        );
      }
    );

    defaultHeaderController = CodeController(
      text: "Content-Type=application/json\nservice=idyllic\nAccept=*/*\nConnection=keep-alive\nAccept-Encoding=gzip, deflate, br",
      language: yaml_theme.yaml,
      theme: highlight.atomOneDarkTheme,
      onChange: (value) {
        String firstpart = value;
        String lastpart = definedHeaderController.text;
        String payload = "$firstpart|||||$lastpart";
        myData.header = payload;
        widget.hive.dashboardBox.put(
          "${widget.title}box",
          String.fromCharCodes(myData.writeToBuffer())
        );
      }
    );

    definedHeaderController = CodeController(
      text: "",
      language: yaml_theme.yaml,
      theme: highlight.atomOneDarkTheme,
      onChange: (value) {
        String firstpart = defaultHeaderController.text;
        String lastpart = value;
        String payload = "$firstpart|||||$lastpart";
        myData.header = payload;
        widget.hive.dashboardBox.put(
          "${widget.title}box",
          String.fromCharCodes(myData.writeToBuffer())
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    
    controllerInitializer();
    defaultInitializer();
  }

  @override
  Widget build(BuildContext context) {

    return (widget.title == "") ? const DefaultPage() : Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50, bottom: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(
                minWidth: 100,
                maxWidth: 200,
              ),
              height: 50,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 123, 53, 170),
                borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
              )
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 135, 212, 182),
                  borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 66, 105, 90),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      child: DropdownButtonFormField(
                        style: const TextStyle(color: Color.fromARGB(255, 28, 29, 77)),
                        elevation: 6,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 255, 166, 1)
                        ),
                        decoration: InputDecoration(
                          hintText: "Method",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 255, 166, 1)
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 66, 105, 90),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50)
                          ),
                        ),
                        validator: (value) => value == null ? "Method" : null,
                        value: methodSelectedValue,
                        onChanged: (String? newValue) {
                          setState(() {

                            // updating the method value
                            myData.method = newValue!;
                            widget.hive.dashboardBox.put(
                              "${widget.title}box",
                              String.fromCharCodes(myData.writeToBuffer())
                            );

                            methodSelectedValue = newValue;
                          });
                        },
                        items: methodsItems
                      )
                    ),
                    SizedBox(
                      width: 500-120,
                      height: 50,
                      child: TextFormField(
                        style: const TextStyle(color: Color.fromARGB(255, 28, 29, 77)),
                        controller: addressController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 135, 212, 182),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(50)
                          ),
                          hintText: "Address",
                          hintStyle: const TextStyle(color: Color.fromARGB(255, 136, 108, 55)),
                        ),
                        onChanged: (value) {
                          // print("value: ${addressController.text}");

                          // updating the address value;
                          myData.address = value;
                          widget.hive.dashboardBox.put(
                            "${widget.title}box",
                            String.fromCharCodes(myData.writeToBuffer())
                          );
                        }
                      ),
                    ),
                  ]
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: DropdownButtonFormField(
                    style: const TextStyle(color: Color.fromARGB(255, 28, 29, 77)),
                    elevation: 6,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromARGB(255, 255, 166, 1)
                    ),
                    decoration: InputDecoration(
                      hintText: "Protocol",
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 255, 166, 1)
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 66, 105, 90),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50)
                      ),
                    ),
                    validator: (value) => value == null ? "Protocol" : null,
                    value: protocolSelectedValue,
                    onChanged: (String? newValue) {
                      setState(() {

                        // updating the method value
                        myData.protocol = newValue!;
                        widget.hive.dashboardBox.put(
                          "${widget.title}box",
                          String.fromCharCodes(myData.writeToBuffer())
                        );

                        protocolSelectedValue = newValue;
                      });
                    },
                    items: protocolItems
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: InkWell(
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    alignment: Alignment.center,
                    child: isRequestProcessing ? const CircularProgressIndicator(
                      color: Colors.white
                    ) : const Text(
                      "Send",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      )
                    )
                  ),
                  onTap: () async {
                    setState(() {
                      isRequestProcessing = true;
                    });
                    String? requestBody = requestController.text;
                    // print("requestBody: $requestBody");
                    var tempJson = json.decode(requestBody);
                    Future<http.StreamedResponse> futureResponse = sendRequest(
                      addressController.text,
                      methodSelectedValue!,
                      "${defaultHeaderController.text}|||||${definedHeaderController.text}",
                      tempJson
                    );
                    futureResponse.then((response) async {
                      Map<dynamic,dynamic> s = await handleResponse(response, protocolSelectedValue!, protocolController.text);
                      setState(() {
                        responseController.text = json.encode(s);
                        isRequestProcessing = false;
                      });
                    });
                  }
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height/1.32,
                        maxHeight: MediaQuery.of(context).size.height/1.32,
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 60, 26, 83),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Request", style: TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 135, 212, 182),
                                  borderRadius: BorderRadius.all(Radius.circular(25))
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          MyRadioButtonCard(
                                            isBtnOn: isBodyOn,
                                            title: "Body",
                                            onTap: () {
                                              setState(() {
                                                isBodyOn = true;
                                                isParamsOn = false;
                                                isHeaderOn = false;
                                              });
                                            },
                                          ),
                                          MyRadioButtonCard(
                                            isBtnOn: isParamsOn,
                                            title: "Params",
                                            onTap: () {
                                              setState(() {
                                                isBodyOn = false;
                                                isParamsOn = true;
                                                isHeaderOn = false;                                              });
                                            },
                                          ),
                                          MyRadioButtonCard(
                                            isBtnOn: isHeaderOn,
                                            title: "Header",
                                            onTap: () {
                                              setState(() {
                                                isBodyOn = false;
                                                isParamsOn = false;
                                                isHeaderOn = true;
                                              });
                                            },
                                          ),
                                        ]
                                      ),
                                    )
                                  ],
                                )
                              ),
                            )
                          ),
                          Expanded(
                            flex: 7,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 60, 26, 83),
                                borderRadius: BorderRadius.all(Radius.circular(25))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: isBodyOn ? CodeField(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 15, 6, 20),
                                    borderRadius: BorderRadius.all(Radius.circular(25))
                                  ),
                                  controller: requestController,
                                  textStyle: const TextStyle(fontFamily: 'SourceCode'),
                                ) : isParamsOn ? paramsWidget() : isHeaderOn ? headerWidget() : null,
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  )
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height/1.32,
                        maxHeight: MediaQuery.of(context).size.height/1.32,
                      ),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 60, 26, 83),
                        borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Response", style: TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 60, 26, 83),
                                borderRadius: BorderRadius.all(Radius.circular(25))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CodeField(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 15, 6, 20),
                                    borderRadius: BorderRadius.all(Radius.circular(25))
                                  ),
                                  controller: protocolController,
                                  textStyle: const TextStyle(fontFamily: 'SourceCode'),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 60, 26, 83),
                                borderRadius: BorderRadius.all(Radius.circular(25))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CodeField(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 15, 6, 20),
                                    borderRadius: BorderRadius.all(Radius.circular(25))
                                  ),
                                  controller: responseController,
                                  textStyle: const TextStyle(fontFamily: 'SourceCode'),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  )
                ),
              ]
            ),
          )
        ]
      ),
    );
  }

  Widget paramsWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 15, 6, 20),
        borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 8),
                child: Text("Key", style: TextStyle(color: Colors.white))
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Text("Value", style: TextStyle(color: Colors.white))
              ),
            ]
          ),
          CodeField(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 15, 6, 20),
              borderRadius: BorderRadius.all(Radius.circular(25))
            ),
            controller: paramsController,
            textStyle: const TextStyle(fontFamily: 'SourceCode'),
          )
        ]
      )
    );
  }

  Widget headerWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 15, 6, 20),
        borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 18),
            child: Text(
              "Default",
              style: TextStyle(
                color: Colors.white
              )
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)
                  )
                ),
                child: CodeField(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 39, 16, 51),
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  controller: defaultHeaderController,
                  textStyle: const TextStyle(fontFamily: 'SourceCode'),
                )
              ),
            )
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "User Defined",
              style: TextStyle(
                color: Colors.white
              )
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)
                  )
                ),
                child: CodeField(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 48, 38, 53),
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  controller: definedHeaderController,
                  textStyle: const TextStyle(fontFamily: 'SourceCode'),
                )
              ),
            )
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Expanded(
          //       flex: 5,
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Container(
          //           height: 40,
          //           decoration: const BoxDecoration(
          //             color: Color.fromARGB(255, 68, 33, 68),
          //             borderRadius: BorderRadius.all(Radius.circular(25))
          //           ),
          //           child: TextFormField(
          //             style: const TextStyle(color: Colors.white),
          //             decoration: InputDecoration(
          //               filled: true,
          //               fillColor: const Color.fromARGB(255, 31, 49, 42),
          //               border: OutlineInputBorder(
          //                 borderSide: BorderSide.none,
          //                 borderRadius: BorderRadius.circular(50)
          //               ),
          //               hintText: "key",
          //               hintStyle: const TextStyle(color: Color.fromARGB(255, 136, 108, 55)),
          //             ),
          //             onChanged: (value) {
          //               // print("value: ${addressController.text}");

          //               // updating the address value;
          //               myData.address = value;
          //               widget.hive.dashboardBox.put(
          //                 "${widget.title}box",
          //                 String.fromCharCodes(myData.writeToBuffer())
          //               );
          //             }
          //           )
          //         ),
          //       ),
          //     ),
          //     Expanded(
          //       flex: 5,
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Container(
          //           height: 40,
          //           decoration: const BoxDecoration(
          //             color: Color.fromARGB(255, 16, 101, 128),
          //             borderRadius: BorderRadius.all(Radius.circular(25))
          //           ),
          //           child: TextFormField(
          //             style: const TextStyle(color: Colors.white),
          //             decoration: InputDecoration(
          //               filled: true,
          //               fillColor: Color.fromARGB(255, 46, 73, 63),
          //               border: OutlineInputBorder(
          //                 borderSide: BorderSide.none,
          //                 borderRadius: BorderRadius.circular(50)
          //               ),
          //               hintText: "value",
          //               hintStyle: const TextStyle(color: Color.fromARGB(255, 136, 108, 55)),
          //             ),
          //             onChanged: (value) {
          //               // print("value: ${addressController.text}");

          //               // updating the address value;
          //               myData.address = value;
          //               widget.hive.dashboardBox.put(
          //                 "${widget.title}box",
          //                 String.fromCharCodes(myData.writeToBuffer())
          //               );
          //             }
          //           )
          //         ),
          //       ),
          //     )
          //   ]
          // )
        ]
      )
    );
  }


}


  