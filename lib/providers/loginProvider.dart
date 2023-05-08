import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gokon/models/userModel.dart';

class LoginProvider with ChangeNotifier {
  bool _isSuccess = false;
  String message = '';

  String username = '';
  String email = '';
  String password = '';
  bool hidePassword = true;
  final UserModel _userModel = UserModel();
  final Uri _uriHost = Uri.parse(dotenv.get('BACKEND_URL_HOST'));

  int getUserId() {
    return _userModel.id;
  }

  void setMessage(String msg) {
    message = msg;
    notifyListeners();
  }

  void togglePasswordVisible() {
    hidePassword = !hidePassword;
    notifyListeners();
  }

  Future<bool> auth() async {
    _isSuccess = false;
    message = '';

    try {
      Dio dio = Dio();
      dio.options.baseUrl = _uriHost.toString();
      dio.options.connectTimeout = 5000;
      dio.options.receiveTimeout = 3000;
      dio.options.contentType = 'application/json';

      List<Cookie> cookieList = [];

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      PersistCookieJar cookieJar =
          PersistCookieJar(storage: FileStorage(appDocPath + "/.cookies/"));
      dio.interceptors.add(CookieManager(cookieJar));
      final responseJwt = await dio.post('/api/v1/session/login', data: {
        'email': email,
        'password': password,
      });
      cookieList = [
        ...cookieList,
        Cookie('access_token', responseJwt.data['access_token'])
      ];
      await cookieJar.saveFromResponse(_uriHost, cookieList);

      _userModel.id = responseJwt.data['user']['id'];
      _userModel.email = responseJwt.data['user']['email'];
      _userModel.username = responseJwt.data['user']['username'];

      _isSuccess = true;
    } catch (error) {
      // TODO:バックエンドのエラーメッセージを出力する
      message = '正しいEメールとパスワードを入力してください';
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  Future<void> logout() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    PersistCookieJar cookieJar =
        PersistCookieJar(storage: FileStorage(appDocPath + "/.cookies/"));
    await cookieJar.delete(_uriHost);
    notifyListeners();
  }

  Future<bool> signup() async {
    _isSuccess = false;
    message = '';

    try {
      Dio dio = Dio();
      dio.options.baseUrl = _uriHost.toString();
      dio.options.contentType = 'application/json';

      final response = await dio.post('/api/v1/users/', data: {
        'user_name': username,
        'email': email,
        'password': password,
      });
      _userModel.id = response.data['id'];
      message = '新規ユーザーの仮登録が成功しました。本登録を行うためログインしてください。';
      _isSuccess = true;
    } catch (error) {
      // TODO:バックエンドのエラーメッセージを出力する
      print(error);
      message = '新規ユーザー登録処理が失敗しました。同じEmailは使用できません';
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }
}
