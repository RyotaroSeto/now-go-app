import 'package:flutter/material.dart';
import 'package:gokon/views/messageScreen.dart';
import 'package:gokon/views/timelineDetailScreen.dart';
import 'package:gokon/views/profileScreen.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<bool> _isFavoriteList = List.generate(10, (_) => false);

  void _toggleFavorite(int index) {
    setState(() {
      _isFavoriteList[index] = !_isFavoriteList[index];
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.message)),
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ホームタブのコード
          ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/150'),
                  ),
                  title: Text('User ${index + 1}'),
                  subtitle: Text('Some information about user ${index + 1}'),
                  trailing: IconButton(
                    icon: Icon(
                      _isFavoriteList[index]
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _isFavoriteList[index] ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(index),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TimelineDetailScreen(index: index),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // メッセージタブのコード
          const MessageScreen(),
          // プロフィールタブのコード
          const ProfileScreen(),
        ],
      ),
    );
  }
}
