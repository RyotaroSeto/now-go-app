import 'package:flutter/material.dart';

class MessageDetailScreen extends StatelessWidget {
  final int index;

  const MessageDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message ${index + 1}'),
      ),
      body: Center(
        child: Text('Details about Message ${index + 1}'),
      ),
    );
  }
}
