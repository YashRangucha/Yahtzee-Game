import 'package:flutter/material.dart';

class Die extends StatefulWidget {
  final int value;
  final bool held;
  final VoidCallback onTapped;

  const Die({super.key, required this.value, required this.held, required this.onTapped});

  @override
  _DieState createState() => _DieState();
}

class _DieState extends State<Die> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTapped,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: widget.held ? Colors.grey : Colors.white,
        ),
        child: Center(
          child: Text(
            '${widget.value}',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
