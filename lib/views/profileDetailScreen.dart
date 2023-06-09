import 'package:flutter/material.dart';
import 'package:gokon/pickers/graduationPicker.dart';
import 'package:gokon/providers/profileProvider.dart';
import 'package:gokon/utils/showSnackBar.dart';
import 'package:provider/provider.dart';
import 'package:gokon/pickers/locationPicker.dart';
import 'package:gokon/pickers/passionPicker.dart';
import 'package:gokon/pickers/sexPicker.dart';
import 'package:gokon/widgets/bottomNavBarWidget.dart';
import 'package:gokon/widgets/drawerWidget.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uri uriHost = Uri.parse('http://10.0.2.2:8080');
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロフィール詳細'),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      profileProvider.profileDetail!.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      profileProvider.profileDetail!.topImage != null
                          ? Image.network(
                              '${profileProvider.profileDetail!.topImage?.replaceFirst('http://127.0.0.1:8080/', uriHost.toString())}',
                              width: 100,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'images/nophotos.png',
                                  width: 100,
                                  fit: BoxFit.fill,
                                );
                              },
                            )
                          : Image.asset(
                              'images/nophotos.png',
                              width: 100,
                              fit: BoxFit.fill,
                            ),
                      profileProvider.profileDetail!.isKyc
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent,
                              size: 16,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${profileProvider.profileDetail!.age.toString()}歳',
                      ),
                      Text(
                        sexPicker[profileProvider.profileDetail!.gender] ?? '',
                      ),
                      Text(
                        locationPicker[
                                profileProvider.profileDetail!.location] ??
                            '',
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '送ったいいね ${profileProvider.profileDetail!.sendFavorite ?? ''}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'もらったいいね ${profileProvider.profileDetail!.receiveFavorite ?? ''}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '所持しているいいね ${profileProvider.profileDetail!.stockFavorite ?? ''}',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'いいねする',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: Icon(
                          profileProvider.checkSendFavorite(
                                  profileProvider.profileDetail!.user ?? '')
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.pinkAccent),
                      onPressed: () async {
                        if (!profileProvider.checkSendFavorite(
                            profileProvider.profileDetail!.user ?? '')) {
                          profileProvider.sendFavorite().then((isSuccess) {
                            if (isSuccess) {
                              showSnackBar(context, 'いいねを送りました');
                            } else {
                              showSnackBar(context, 'エラーが発生しました');
                            }
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      profileProvider.profileDetail!.tweet ?? '',
                      style:
                          const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${profileProvider.profileDetail!.height ?? ''}cm',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'お仕事 ${profileProvider.profileDetail!.work ?? ''}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      graduationPicker[
                              profileProvider.profileDetail!.graduation] ??
                          '',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '趣味 ${profileProvider.profileDetail!.hobby ?? ''}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '結婚願望 ${passionPicker[profileProvider.profileDetail!.passion ?? '']}',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '自己紹介',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        profileProvider.profileDetail!.introduction ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer: const DrawerWidget(),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
