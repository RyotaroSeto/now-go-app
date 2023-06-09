import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gokon/pickers/graduationPickerWidget.dart';
import 'package:gokon/pickers/passionPickerWidget.dart';
import 'package:gokon/pickers/locationPickerWidget.dart';
import 'package:gokon/pickers/sexPicker.dart';
import 'package:gokon/providers/loginProvider.dart';
import 'package:gokon/providers/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gokon/utils/showSnackBar.dart';
import 'package:gokon/widgets/bottomNavBarWidget.dart';
import 'package:gokon/widgets/drawerWidget.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Flutter Web の場合 dotenv.get('BACKEND_URL_HOST_CASE_FLUTTER_WEB')
    final Uri uriHost = Uri.parse(dotenv.get('BACKEND_URL_HOST'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('マイプロフィール'),
      ),
      body: Consumer2<ProfileProvider, LoginProvider>(
        builder: (context, profileProvider, loginProvider, _) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: <Widget>[
                      profileProvider.uploadTopImage != null
                          ? Image.file(profileProvider.uploadTopImage!)
                          : profileProvider.myProfile.topImage != null
                              ? Image.network(
                                  '${profileProvider.myProfile.topImage?.replaceFirst(dotenv.get('STORAGE_URL_HOST'), uriHost.toString())}',
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
                      profileProvider.myProfile.isKyc
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent,
                              size: 16,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  TextButton(
                    child: const Text('画像変更'),
                    onPressed: () => profileProvider.pickTopImage(),
                  ),
                  TextFormField(
                    onChanged: (value) =>
                        profileProvider.myProfile.name = value,
                    decoration: const InputDecoration(
                        labelText: 'なまえ', hintText: 'このフィールドは必須です'),
                    maxLength: 50,
                    initialValue: profileProvider.myProfile.name,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) =>
                        profileProvider.myProfile.age = int.parse(value),
                    decoration: const InputDecoration(
                      labelText: '年齢',
                      hintText: '18歳未満は登録出来ません',
                    ),
                    enabled: profileProvider.myProfile.user == null,
                    maxLength: 2,
                    initialValue: profileProvider.myProfile.age.toString(),
                  ),
                  for (String key in sexPicker.keys) ...{
                    RadioListTile(
                      value: key,
                      groupValue: profileProvider.myProfile.gender,
                      title: Text(sexPicker[key] ?? '性別不詳'),
                      selected: profileProvider.myProfile.gender == key,
                      onChanged: (value) {
                        if (profileProvider.myProfile.user == null) {
                          profileProvider.myProfile.gender = value.toString();
                          profileProvider.notifyListeners();
                        } else {
                          null;
                        }
                      },
                    )
                  },
                  TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) =>
                        profileProvider.myProfile.height = int.parse(value),
                    decoration: const InputDecoration(
                        labelText: '身長cm', hintText: '140cm以上200cm未満で入力してください'),
                    maxLength: 3,
                    initialValue: profileProvider.myProfile.height != null
                        ? profileProvider.myProfile.height.toString()
                        : '',
                  ),
                  const LocationPickerWidget(),
                  TextFormField(
                    onChanged: (value) =>
                        profileProvider.myProfile.work = value,
                    decoration: const InputDecoration(
                      labelText: '仕事',
                    ),
                    maxLength: 20,
                    initialValue: profileProvider.myProfile.work,
                  ),
                  const GraduationPickerWidget(),
                  TextFormField(
                    onChanged: (value) =>
                        profileProvider.myProfile.hobby = value,
                    decoration: const InputDecoration(
                      labelText: '趣味',
                    ),
                    maxLength: 20,
                    initialValue: profileProvider.myProfile.hobby,
                  ),
                  const PassionPickerWidget(),
                  TextFormField(
                    onChanged: (value) =>
                        profileProvider.myProfile.tweet = value,
                    decoration: const InputDecoration(
                      labelText: 'ひとこと',
                    ),
                    maxLength: 10,
                    initialValue: profileProvider.myProfile.tweet,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) =>
                        profileProvider.myProfile.introduction = value,
                    decoration: const InputDecoration(
                      labelText: '自己紹介',
                    ),
                    maxLength: 1000,
                    maxLines: null,
                    initialValue: profileProvider.myProfile.introduction,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.95, 32),
                      ),
                      onPressed: () {
                        if (profileProvider.myProfile.user == null) {
                          profileProvider
                              .upsertMyProfile(loginProvider.getUserId())
                              .then((isSuccess) {
                            if (isSuccess) {
                              Navigator.pushReplacementNamed(
                                  context, '/my-profile');
                              showSnackBar(context, 'プロフィールが新規作成されました');
                            } else {
                              showSnackBar(context, 'エラーが発生しました');
                            }
                          });
                        } else {
                          profileProvider
                              .upsertMyProfile(loginProvider.getUserId())
                              .then((isSuccess) {
                            if (isSuccess) {
                              Navigator.pushReplacementNamed(
                                  context, '/my-profile');
                              showSnackBar(context, 'プロフィール更新が完了しました');
                            } else {
                              showSnackBar(context, 'エラーが発生しました');
                            }
                          });
                        }
                      },
                      child: profileProvider.myProfile.user == null
                          ? const Text('プロフィールを作成する')
                          : const Text('プロフィールを更新する'),
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
