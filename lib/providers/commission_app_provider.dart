import 'package:flutter/material.dart';
import 'package:tnazul/models/commission_app.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/utils/urls.dart';

class CommisssionAppProvider extends ChangeNotifier{

   ApiProvider _apiProvider = ApiProvider();


  String _currentLang;

  void update(AuthProvider authProvider) {
  
    _currentLang = authProvider.currentLang;
  }

  Future<CommissionApp> getCommissionApp() async {
    final response =
        await _apiProvider.get(Urls.BANKS_URL+"?api_lang=$_currentLang");
    CommissionApp commissionApp ;
    if (response['response'] == '1') {
      commissionApp = CommissionApp.fromJson(response);
    }
    return commissionApp;
  }

   String _commissionValue = '';

  void setCommissionValue(String commissionValue) {
    _commissionValue = commissionValue;
    notifyListeners();
  }

  String get commissionValue => _commissionValue;
}