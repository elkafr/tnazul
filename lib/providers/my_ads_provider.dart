import 'package:flutter/material.dart';
import 'package:tnazul/models/ad.dart';
import 'package:tnazul/models/user.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/utils/urls.dart';

  class MyAdsProvider extends ChangeNotifier {
    ApiProvider _apiProvider = ApiProvider();
  User _currentUser;
  String _currentLang;

  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang =  authProvider.currentLang;
  }
     Future<List<Ad>> getMyAdsList() async {

    final response = await _apiProvider.get(
        Urls.MY_ADS_URL + 'user_id=${_currentUser.userId}&page=1&api_lang=$_currentLang' );
    List<Ad> adsList = List<Ad>();
    if (response['response'] == '1') {
      Iterable iterable = response['requests'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }

    return adsList;
  }


  }