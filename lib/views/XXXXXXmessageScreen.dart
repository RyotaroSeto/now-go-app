import 'package:flutter/material.dart';
import 'package:gokon/views/messageDetailScreen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            title: Text('Message ${index + 1}'),
            subtitle:
                Text('Some message information about message ${index + 1}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageDetailScreen(index: index),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
