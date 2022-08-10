import 'package:flutter/material.dart';

class MyRadioButton extends StatefulWidget {
  final bool isOn;
  final double radius;
  final Function()? onTap;
  final Color fillColor;
  final Color dotColor; 
  const MyRadioButton({
    super.key, 
    this.isOn = false, 
    this.radius = 35,
    required this.onTap, 
    this.fillColor = Colors.grey, 
    this.dotColor = const Color.fromARGB(255, 0, 0, 0)});

  @override
  State<MyRadioButton> createState() => _MyRadioButtonState();
}

class _MyRadioButtonState extends State<MyRadioButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: widget.radius/2,
        height: widget.radius/2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.fillColor,
          borderRadius: const BorderRadius.all(Radius.circular(50))
        ),
        child: widget.isOn ? Container(
          width: widget.radius/4,
          height: widget.radius/4,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.dotColor,
            borderRadius: const BorderRadius.all(Radius.circular(50))
          ),
        ) : null
      ),
    );
  }
}

class MyRadioButtonCard extends StatefulWidget {
  final String title;
  final bool isBtnOn;
  final Function()? onTap;

  const MyRadioButtonCard({super.key, required this.title, this.isBtnOn = false, required this.onTap});

  @override
  State<MyRadioButtonCard> createState() => _MyRadioButtonCardState();
}

class _MyRadioButtonCardState extends State<MyRadioButtonCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 60, 26, 83),
          borderRadius: BorderRadius.all(Radius.circular(25))
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 4),
                child: MyRadioButton(
                  isOn: widget.isBtnOn,
                  onTap: widget.onTap
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 4),
                child: Text(
                  widget.title,
                  style: const  TextStyle(
                    color: Color.fromARGB(255, 135, 212, 182)
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}