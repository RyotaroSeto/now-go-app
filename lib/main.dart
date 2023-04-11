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
      home: const TimelineScreen(),
    );
  }
}

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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _name = 'Your Name';
  final String _introduction = 'Introduce yourself here';
  final String _imageUrl = 'https://via.placeholder.com/150';

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    // 画像選択処理を実装
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    // カメラ起動処理を実装
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _showDialog(),
            child: CircleAvatar(
              backgroundImage: NetworkImage(_imageUrl),
              radius: 60.0,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            _name,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            _introduction,
            style: const TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            child: Text('Edit Profile'),
            onPressed: () {
              // プロフィール編集画面に遷移する処理を実装
            },
          ),
        ],
      ),
    );
  }
}
