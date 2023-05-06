import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('今すぐお出かけ'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'さあ最高のマッチングアプリを始めましょう！',
          ),
          const SizedBox(
            height: 16,
          ),
          TextButton(
            child: const Text('ログイン'),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          TextButton(
            child: const Text('新規会員登録'),
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
        ],
      )),
    );
  }
}
