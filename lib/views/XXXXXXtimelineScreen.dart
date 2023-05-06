import 'package:flutter/material.dart';
import 'package:gokon/views/messageScreen.dart';
import 'package:gokon/views/XXXXXXtimelineDetailScreen.dart';
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
            const MessageScreen(),
            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'メッセージ'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
          ],
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _tabController.index = index;
            });
          },
          currentIndex: _tabController.index,
        ));
  }
}
