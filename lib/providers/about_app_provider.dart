import 'package:flutter/material.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/utils/urls.dart';

class AboutAppProvider extends ChangeNotifier{
   ApiProvider _apiProvider = ApiProvider();
 String _currentLang;


  void update(AuthProvider authProvider) {
 
    _currentLang = authProvider.currentLang;
  }
  Future<String> getAboutApp() async {
    final response =
        await _apiProvider.get(Urls.ABOUT_APP_URL +"?api_lang=$_currentLang");
    String aboutApp = '';
    if (response['response'] == '1') {
      aboutApp = response['messages'];
    }
    return aboutApp;
  }
}