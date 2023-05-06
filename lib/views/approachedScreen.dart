import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gokon/providers/profileProvider.dart';
import 'package:gokon/widgets/drawerWidget.dart';
import 'package:gokon/widgets/bottomNavBarWidget.dart';
import 'package:gokon/widgets/profileListWidget.dart';

class ApproachedScreen extends StatelessWidget {
  const ApproachedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('いいねをくれた人'),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return ProfileListWidget(
              profiles: profileProvider.profileApproachedList);
        },
      ),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
