import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header(this.heading);
  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Text(
            heading,
            style: const TextStyle(fontSize: 24, color: Colors.red),
          ),
        ),
      );
}

class divider extends StatelessWidget {
  const divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 8,
      thickness: 1,
      indent: 8,
      endIndent: 8,
      color: Colors.black,
    );
  }
}

class Stats extends StatelessWidget {
  const Stats(this.stat);
  final String stat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Text(
          stat,
          style: TextStyle(
              fontSize: 19.0, color: Colors.black, fontFamily: "sans serif"),
        ),
      ),
    );
  }
}
