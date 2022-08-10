import 'dart:async';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:idyllic/utils/datatype.dart';
import '../db/hivehandler.dart';
import 'dashboard/dashboard.dart';
import 'defaultpage.dart';
import 'topnavbar/topbar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class DashBoardData {
  String? methodValue;
  String? protocolValue;
  TextEditingController? addressController;
  CodeController? protobufController1;
  CodeController? jsonController;
  CodeController? protobufController2;

  DashBoardData({
    this.methodValue, 
    this.protocolValue, 
    this.addressController,
    this.protobufController1,
    this.protobufController2,
    this.jsonController
  });
}

class MyHomePage extends StatefulWidget {
  final HiveDB hive;
  const MyHomePage({super.key, required this.hive});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final ItemScrollController _scrollController = ItemScrollController();

  StreamController<NewPageRequest> topBarController = StreamController<NewPageRequest>();
  Widget mainContent = const DefaultPage();

  String inFocusDashBoardName = "";
  int inFocusDashBoardIndex = 0;

  Map<String ,int> dashBoardPositions = {};

  Map<String, Widget> dashboards = {};
  Map<String, DashBoardData> dashBoardDatas = {};
  StreamController<int> uiRefresher = StreamController<int>();
  late Stream<int> uiStream;

  void mainContentDisplayer() {
    topBarController.stream.listen((index) async {
      // print("new dashboard display event: ${index.type}");

      if (index.type == 1) {
        setState(() {
          dashBoardPositions[index.name] = index.index;
        });
      } else if (index.type == 2) {
        setState(() {
          inFocusDashBoardIndex = index.index;
        });
        _scrollController.jumpTo(index: index.index);
      } else if (index.type == 3) {
        setState(() {
          dashBoardPositions.remove(index.name);
        });
        widget.hive.dashboardBox.delete("${index.name}box");
      }
    });
  }

  @override
  void initState() {
    super.initState();

    uiStream = uiRefresher.stream.asBroadcastStream();

    // print("Laoding Page");
    mainContentDisplayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 42, 18, 58),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Material(
                    elevation: 10,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 37,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 46, 43, 49)
                      ),
                      child: TopBar(topBarController: topBarController)
                    ),
                  ),
                  Expanded(
                    // child: ListView.builder(
                    //   itemCount : 4,
                    //   itemBuilder: ((context, index) {
                    //     return Dashboard(
                    //       title: "name+$index",
                    //       hive: widget.hive,
                    //       uiRefresh: uiStream,
                    //     );
                    //   })
                    // )
                    child: ScrollablePositionedList.builder(
                      itemScrollController: _scrollController,
                      itemCount: dashBoardPositions.values.toList().length,
                      itemBuilder: (context, index) {
                        // print("DashBoard index: $index");
                        return Dashboard(
                          title: dashBoardPositions.keys.toList()[index],
                          hive: widget.hive,
                          uiRefresh: uiStream,
                        );
                      }
                    )
                  )
                ]
              )
            )
          ]
        ),
      )
    );
  }
}
