import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gokon/models/matchingModel.dart';
import 'package:gokon/models/messageModel.dart';
import 'package:gokon/models/profileModel.dart';

class ProfileProvider with ChangeNotifier {
  final Uri _uriHost = Uri.parse(dotenv.get('BACKEND_URL_HOST'));

  bool _isSuccess = false;
  File? uploadTopImage;

  /// プロフィール機能
  ProfileModel myProfile = ProfileModel(
    user: null,
    isSpecial: false,
    isKyc: false,
    name: '',
    topImage: null,
    createdAt: null,
    updatedAt: null,
    age: 0,
    gender: '',
    height: null,
    location: null,
    work: null,
    graduation: null,
    hobby: null,
    passion: null,
    tweet: null,
    introduction: null,
    sendFavorite: null,
    receiveFavorite: null,
    stockFavorite: null,
  );
  List<ProfileModel> profileList = [];
  List<ProfileModel> profileApproachingList = [];
  List<ProfileModel> profileApproachedList = [];
  List<ProfileModel> profileMatchingList = [];
  ProfileModel? profileDetail;

  /// マッチング機能
  MatchingModel? matching;
  List<MatchingModel> _matchingList = [];
  List<String> _matchingUserIdList = [];
  List<MatchingModel> _approachingList = [];
  List<String> _approachingUserIdList = [];
  List<MatchingModel> _approachedList = [];
  List<String> _approachedUserIdList = [];

  /// メッセージ機能
  List<MessageModel> messageList = [];
  List<MessageModel> _sendMessageList = [];
  List<MessageModel> _receiveMessageList = [];
  String newMessage = '';

  /// 自己プロフィール取得
  // TODO:自己プロフィール取得実装
  Future fetchMyProfile(int userId) async {
    _isSuccess = false;
    try {
      Dio dio = Dio();
      List<Cookie> cookieList = await _prepareDio(dio);
      final Response<dynamic> profile = await dio.get(
        '/api/v1/users?id=$userId',
        options: Options(
          headers: {
            'Authorization': 'bearer ${cookieList.first.value}',
          },
        ),
      );
      myProfile = _inputProfileModel(profile.data!);
      _isSuccess = true;
    } catch (error) {
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  /// 画像ピックアップ
  Future pickTopImage() async {
    _isSuccess = false;
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

      if (image != null) {
        final imageDecode = decodeImage(File(image.path).readAsBytesSync());
        if (imageDecode != null) {
          var _imageResize;
          const int _imageLongSide = 720;
          if (imageDecode.width > imageDecode.height) {
            if (imageDecode.width > _imageLongSide) {
              _imageResize = copyResize(imageDecode,
                  width: _imageLongSide,
                  height:
                      _imageLongSide * imageDecode.height ~/ imageDecode.width);
            }
          } else {
            if (imageDecode.height > _imageLongSide) {
              _imageResize = copyResize(imageDecode,
                  width:
                      _imageLongSide * imageDecode.width ~/ imageDecode.height,
                  height: _imageLongSide);
            }
          }
          if (_imageResize != null) {
            File(image.path).writeAsBytesSync(encodePng(_imageResize));
          }
        }
        uploadTopImage = File(image.path);
      }
      _isSuccess = true;
    } catch (error) {
      print("エラーが発生しました");
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  /// プロフィール新規作成or更新
  Future upsertMyProfile(int userId) async {
    _isSuccess = false;
    try {
      Dio dio = Dio();
      List<Cookie> cookieList = await _prepareDio(dio);

      final Response profile = await dio.post('/api/v1/users/upsert',
          options: Options(
            headers: {
              'Authorization': 'bearer ${cookieList.first.value}',
            },
          ),
          data: {
            //   "is_special": false,
            //   "is_kyc": false,
            //   "top_image": uploadTopImage != null
            //       ? await MultipartFile.fromFile(
            //           uploadTopImage!.path,
            //           filename: uploadTopImage!.path.split('/').last,
            //         )
            //       : myProfile.topImage,
            "user_id": 4,
            "name": myProfile.name,
            "age": myProfile.age,
            "gender": myProfile.gender,
            "height": myProfile.height,
            "location": myProfile.location,
            "work": myProfile.work,
            "graduation": myProfile.graduation,
            "hobby": myProfile.hobby,
            "passion": myProfile.passion,
            "tweet": myProfile.tweet,
            "introduction": myProfile.introduction,
            //   "send_favorite": myProfile.sendFavorite,
            //   "receive_favorite": myProfile.receiveFavorite,
            //   "stock_favorite": myProfile.stockFavorite
          });
      print(profile);
      myProfile = _inputProfileModel(profile.data!);
      _isSuccess = true;
    } catch (error) {
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  /// ユーザーのプロフィール一覧を取得する（いいね・マッチング状態のユーザーは除外）
  Future fetchProfileList() async {
    _isSuccess = false;
    _isSuccess = await _fetchProfileAllList();
    // _isSuccess = await _fetchMatchingList();
    // profileList.removeWhere(
    //     (profile) => _approachingUserIdList.contains(profile.user));
    // profileList
    //     .removeWhere((profile) => _approachedUserIdList.contains(profile.user));
    // notifyListeners();
    return _isSuccess;
  }

  /// いいねしたユーザーのプロフィール一覧を取得する（マッチング状態のユーザーは除外）
  Future fetchProfileApproachingList() async {
    _isSuccess = false;
    _isSuccess = await _fetchProfileAllList();
    _isSuccess = await _fetchMatchingList();
    profileApproachingList = profileList
        .where((profile) => _approachingUserIdList.contains(profile.user))
        .toList();
    profileApproachingList
        .removeWhere((profile) => _matchingUserIdList.contains(profile.user));
    notifyListeners();
    return _isSuccess;
  }

  /// いいねされたユーザーのプロフィール一覧を取得する（マッチング状態のユーザーは除外）
  Future fetchProfileApproachedList() async {
    _isSuccess = false;
    _isSuccess = await _fetchProfileAllList();
    _isSuccess = await _fetchMatchingList();
    profileApproachedList = profileList
        .where((profile) => _approachedUserIdList.contains(profile.user))
        .toList();
    profileApproachedList
        .removeWhere((profile) => _matchingUserIdList.contains(profile.user));
    notifyListeners();
    return _isSuccess;
  }

  /// マッチングしているユーザーのプロフィール一覧を取得する
  Future fetchProfileMatchingList() async {
    _isSuccess = false;
    _isSuccess = await _fetchProfileAllList();
    _isSuccess = await _fetchMatchingList();
    profileMatchingList = profileList
        .where((profile) => _matchingUserIdList.contains(profile.user))
        .toList();
    notifyListeners();
    return _isSuccess;
  }

  /// 選択したユーザーのプロフィールをセットする
  void setProfileDetail(ProfileModel profile) {
    profileDetail = profile;
    notifyListeners();
  }

  /// いいねをしたユーザーかどうかをチェックする
  bool checkSendFavorite(String userId) {
    return _approachingUserIdList.contains(userId);
  }

  /// いいねをくれたユーザーかどうかをチェックする
  bool checkReceiveFavorite(String userId) {
    return _approachedUserIdList.contains(userId);
  }

  /// いいねを送る・承認する
  Future sendFavorite() async {
    _isSuccess = false;
    try {
      String approachUserId = profileDetail != null ? profileDetail!.user! : '';
      // 既にこちらからいいねを送っている場合は処理を行わない
      if (checkSendFavorite(approachUserId)) {
        // 何も処理を行わない
      }
      // 既に相手からいいねが来ている場合は上記のリクエストデータのapprovedをTrueにしていいねを行い、相手のマッチングモデルデータのapprovedもTrueに更新する
      else if (checkReceiveFavorite(approachUserId)) {
        // いいね新規作成処理
        await _createFavorite(approached: approachUserId, approved: true);
        // いいねをくれたユーザーのマッチングリストの中でapproachUserIdと一致するマッチングデータのIDを探索する
        Iterable<MatchingModel> approachMatching = _approachedList
            .where((matching) => matching.approaching == approachUserId);
        int approachMatchingId = approachMatching.first.id ?? 0;
        // 相手のいいねデータに対する承認処理
        await _patchApproved(id: approachMatchingId);
        // マッチングデータ再取得
        await fetchProfileMatchingList();
      }
      // どちらもいいねを送っていない場合は上記のリクエストデータを用いてマッチングデータを作成する
      else {
        // いいね新規作成処理
        await _createFavorite(approached: approachUserId, approved: false);
        // いいねしたユーザー一覧データ再取得
        await fetchProfileApproachingList();
      }
      _isSuccess = true;
    } catch (error) {
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  /// 指定したユーザーとのメッセージの内容を取得する
  Future getMessageList() async {
    _isSuccess = false;
    messageList.clear();
    try {
      // バックエンドから自身に関連するメッセージ一覧を取得する
      await _fetchSendMessageList();
      await _fetchReceiveMessageList();
      // 指定したユーザーとのメッセージだけをフィルタリングして新規メッセージ順に messageList に格納する
      messageList.addAll(_sendMessageList
          .where((message) => message.receiver == profileDetail!.user));
      messageList.addAll(_receiveMessageList
          .where((message) => message.sender == profileDetail!.user));
      messageList
          .sort((alpha, beta) => alpha.createdAt!.compareTo(beta.createdAt!));
      // 処理成功
      _isSuccess = true;
    } catch (error) {
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  /// 【プライベート】送ったメッセージの内容を全件取得する
  // TODO:メッセージ取得実装
  Future _fetchSendMessageList() async {
    Dio dio = Dio();
    List<Cookie> cookieList = await _prepareDio(dio);
    // final Response<dynamic> message = await dio.get(
    //   '/api/dm-message/',
    //   options: Options(
    //     headers: {
    //       'Authorization': 'bearer ${cookieList.first.value}',
    //     },
    //   ),
    // );
    // _sendMessageList = _inputMessageModelList(message.data!);
  }

  /// 【プライベート】受け取ったメッセージの内容を全件取得する
  // TODO:メッセージ内容全件取得
  Future _fetchReceiveMessageList() async {
    Dio dio = Dio();
    List<Cookie> cookieList = await _prepareDio(dio);
    // final Response<dynamic> message = await dio.get(
    //   '/api/dm-inbox/',
    //   options: Options(
    //     headers: {
    //       'Authorization': 'bearer ${cookieList.first.value}',
    //     },
    //   ),
    // );
    // _receiveMessageList = _inputMessageModelList(message.data!);
  }

  /// 指定したユーザーに新規メッセージを送信する
  // TODO:新規メッセージを送信
  Future createMessage() async {
    _isSuccess = false;
    try {
      Dio dio = Dio();
      List<Cookie> cookieList = await _prepareDio(dio);
      // await dio.post(
      //   '/api/dm-message/',
      //   options: Options(
      //     headers: {
      //       'Authorization': 'bearer ${cookieList.first.value}',
      //     },
      //   ),
      //   data: {
      //     "receiver": profileDetail!.user,
      //     "message": newMessage,
      //   },
      // );
      newMessage = '';
      await getMessageList();
      _isSuccess = true;
    } catch (error) {
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  /// 【プライベート】プロフィール全件取得
  // TODO:プロフィール全件取得
  Future _fetchProfileAllList() async {
    _isSuccess = false;
    profileList.clear();
    String gender = myProfile.gender;
    try {
      Dio dio = Dio();
      List<Cookie> cookieList = await _prepareDio(dio);
      final Response profiles = await dio.get(
        '/api/v1/users/list?gender=$gender',
        options: Options(
          headers: {
            'Authorization': 'bearer ${cookieList.first.value}',
          },
        ),
      );
      print("pppppppppppp");
      print(profiles.data!);
      print("pppppppppppp");
      profileList = _inputProfileModelList(profiles.data!);
      _isSuccess = true;
    } catch (error) {
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  /// 【プライベート】いいねしているユーザー・いいねされているユーザー・マッチングしているユーザーのそれぞれのマッチングリストを取得する
  // TODO:マッチングリスト取得
  Future _fetchMatchingList() async {
    _isSuccess = false;
    try {
      Dio dio = Dio();
      List<Cookie> cookieList = await _prepareDio(dio);
      // final Response matchingList = await dio.get(
      //   '/api/favorite/',
      //   options: Options(
      //     headers: {
      //       'Authorization': 'bearer ${cookieList.first.value}',
      //     },
      //   ),
      // );
      // _matchingList = _inputMatchingModelList(matchingList.data!);
      _approachingList = _matchingList
          .where((matching) => matching.approaching == myProfile.user)
          .toList();
      _approachingUserIdList =
          _approachingList.map((matching) => matching.approached).toList();
      _approachedList = _matchingList
          .where((matching) => matching.approached == myProfile.user)
          .toList();
      _approachedUserIdList =
          _approachedList.map((matching) => matching.approaching!).toList();
      _matchingList =
          _matchingList.where((matching) => matching.approved == true).toList();
      _matchingUserIdList =
          _matchingList.map((matching) => matching.approaching!).toList();
      _isSuccess = true;
    } catch (error) {
      print(error);
      _isSuccess = false;
    }
    notifyListeners();
    return _isSuccess;
  }

  /// 【プライベート】マッチングデータ新規作成
  // TODO:【プライベート】マッチングデータ新規作成取得
  Future _createFavorite(
      {required String approached, required bool approved}) async {
    Dio dio = Dio();
    // List<Cookie> cookieList = await _prepareDio(dio);
    // return await dio.post(
    //   '/api/favorite/',
    //   options: Options(
    //     headers: {
    //       'Authorization': 'bearer ${cookieList.first.value}',
    //     },
    //   ),
    //   data: {
    //     "approached": approached,
    //     "approved": approved,
    //   },
    // );
  }

  /// 【プライベート】マッチングデータ承認フィールド更新
  Future _patchApproved({required int id}) async {
    Dio dio = Dio();
    List<Cookie> cookieList = await _prepareDio(dio);
    return await dio.patch(
      '/api/favorite/$id/',
      options: Options(
        headers: {
          'Authorization': 'bearer ${cookieList.first.value}',
        },
      ),
      data: {"approved": true},
    );
  }

  /// 【プライベート】バックエンドから取得したプロフィールデータのProvider化
  ProfileModel _inputProfileModel(dynamic profile) {
    return ProfileModel(
      user: profile!['user_name'], //ここが空でなければユーザーは作成されていると判断される
      // isSpecial: profile!['is_special'],
      // isKyc: profile!['is_kyc'],
      // topImage: profile!['top_image'],
      isSpecial: false,
      isKyc: false,
      name: profile!['user_detail']['name'],
      createdAt: profile!['user_detail']['created_at'],
      updatedAt: profile!['user_detail']['updated_at'],
      age: profile!['user_detail']['age'],
      gender: profile!['user_detail']['gender'],
      height: profile!['user_detail']['height'],
      location: profile!['user_detail']['location'],
      work: profile!['user_detail']['work'],
      graduation: profile!['user_detail']['graduation'],
      hobby: profile!['user_detail']['hobby'],
      passion: profile!['user_detail']['passion'],
      tweet: profile!['user_detail']['tweet'],
      introduction: profile!['user_detail']['introduction'],
      // sendFavorite: profile!['send_favorite'],
      // receiveFavorite: profile!['receive_favorite'],
      // stockFavorite: profile!['stock_favorite'],
      // profile!['fromLastLogin'],
    );
  }

  /// 【プライベート】バックエンドから取得したプロフィールデータ一覧のProvider化
  List<ProfileModel> _inputProfileModelList(dynamic profiles) {
    return profiles
        .map<ProfileModel>((profile) => _inputProfileModel(profile))
        .toList();
  }

  /// 【プライベート】バックエンドから取得したマッチングデータのProvider化
  MatchingModel _inputMatchingModel(dynamic matching) {
    return MatchingModel(
      id: matching!['id'],
      approaching: matching!['approaching'],
      approached: matching!['approached'],
      approved: matching!['approved'],
      createdAt: matching!['created_at'],
    );
  }

  /// 【プライベート】バックエンドから取得したマッチングデータ一覧のProvider化
  List<MatchingModel> _inputMatchingModelList(dynamic matchingList) {
    return matchingList
        .map<MatchingModel>((matching) => _inputMatchingModel(matching))
        .toList();
  }

  /// 【プライベート】バックエンドから取得したメッセージデータのProvider化
  MessageModel _inputMessageModel(dynamic message) {
    return MessageModel(
      id: message!['id'],
      sender: message!['sender'],
      receiver: message!['receiver'],
      message: message!['message'],
      createdAt: message!['created_at'],
    );
  }

  /// 【プライベート】バックエンドから取得したメッセージデータ一覧のProvider化
  List<MessageModel> _inputMessageModelList(dynamic messageList) {
    return messageList
        .map<MessageModel>((message) => _inputMessageModel(message))
        .toList();
  }

  /// 【プライベート】HTTPクライアントの実行準備
  Future<List<Cookie>> _prepareDio(Dio dio) async {
    dio.options.baseUrl = _uriHost.toString();
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    // dio.options.contentType = 'application/json' or 'multipart/form-data';
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    PersistCookieJar cookieJar =
        PersistCookieJar(storage: FileStorage(appDocPath + "/.cookies/"));
    dio.interceptors.add(CookieManager(cookieJar));
    List<Cookie> cookieList = await cookieJar.loadForRequest(_uriHost);
    return cookieList;
  }
}
