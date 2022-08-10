import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idyllic/utils/datatype.dart';

class TopBarCard extends StatelessWidget {
  final String title;
  final bool inFocus;
  final Function()? onTap;
  final Function()? cancelOnTap;
  const TopBarCard({super.key, this.inFocus = false, required this.title, required this.onTap, required this.cancelOnTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 1.0, right: 1),
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 150,
          ),
          alignment: Alignment.center,
          color: inFocus ? const Color.fromARGB(255, 53, 23, 73) : const Color.fromARGB(255, 32, 30, 34),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    title,
                    style: const TextStyle(
                      letterSpacing: 1,
                      color: Color.fromARGB(255, 8, 233, 233)
                    )
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      splashRadius: 15,
                      splashColor: const Color.fromARGB(255, 95, 28, 22),
                      hoverColor: const Color.fromARGB(255, 57, 25, 78),
                      onPressed: cancelOnTap,
                      icon: const Icon(Icons.cancel, color: Color.fromARGB(255, 136, 4, 21))
                    ),
                  ),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class TopBar extends StatefulWidget {
  final StreamController<NewPageRequest> topBarController;
  const TopBar({super.key, required this.topBarController});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  int inFocusIndex = 0;
  int count = 1;

  Map<int, String> topBarContent = {};

  _TopBarState() {
    topBarContent = {
      1 : "navigator",
    };
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < topBarContent.keys.toList().length; i++)
          (topBarContent.values.toList()[i] == "navigator") ?
            InkWell(
              child: Container(
                color: Colors.grey,
                alignment: Alignment.center,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text("+",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                  ),
                )
              ),
              onTap: () {
                String name = "";
                if (count == 1) {
                  name = "dashboad1";
                  count++;
                } else {
                  name = "dashboard${count++}";
                }
                topBarContent.remove(1);
                topBarContent.addAll({count: name, 1: "navigator"});
                widget.topBarController.sink.add(NewPageRequest(name,topBarContent.values.toList().length-1, 1));
                // widget.topBarController.sink.add(NewPageRequest(name,topBarContent.values.toList().length-1, 2));
                setState(() {
                  inFocusIndex = i;
                });
              }
            )
           : Material(
              elevation: (inFocusIndex == i) ? 6.0 : 0.0,
              child: TopBarCard(
                   
                title: topBarContent.values.toList()[i],
                inFocus: (inFocusIndex == i) ? true : false,
                onTap: () {
                  // print("title: ${topBarContent.values.toList()[i]}");
                  if (inFocusIndex != i) {
                    widget.topBarController.sink.add(NewPageRequest(topBarContent.values.toList()[i],i , 2));
                    setState(() {
                      inFocusIndex = i;
                    });
                  }
                  
                },
                cancelOnTap: () {
                  setState(() {
                    widget.topBarController.sink.add(NewPageRequest(topBarContent.values.toList()[i],i, 3));
                    topBarContent.remove(topBarContent.keys.toList()[i]);
                  });
                },
                      ),
           )
      ],
    );
  }
}