import 'package:flutter/material.dart';

class TimelineDetailScreen extends StatelessWidget {
  final int index;

  const TimelineDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User ${index + 1}'),
      ),
      body: Center(
        child: Text('Details about User ${index + 1}'),
      ),
    );
  }
}
