import 'package:flutter/material.dart';
import 'package:sliding_box/sliding_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Slidingbox Example',
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.black12),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SlidingBox(
              height: 50,
              width: 100,
              children: [
                _ExampleItem(
                  color: Colors.amber,
                  text: "First",
                ),
                _ExampleItem(
                  color: Colors.deepPurple,
                  text: "Second",
                ),
                _ExampleItem(
                  color: Colors.green,
                  text: "Thrid",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExampleItem extends StatelessWidget {
  final String text;
  final Color color;

  const _ExampleItem({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => debugPrint("$text Tapped"),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text("$text Widget"),
          )
        ],
      ),
    );
  }
}
