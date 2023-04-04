import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matching App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TimelineScreen(),
    );
  }
}

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<bool> _isFavoriteList = List.generate(10, (_) => false);

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
        title: Text('Timeline'),
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
          MessageScreen(),
          // プロフィールタブのコード
          const Center(child: Text('Profile Tab')),
        ],
      ),
    );
  }
}

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

class MessageScreen extends StatelessWidget {
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
