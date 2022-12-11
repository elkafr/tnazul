import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/buttons/custom_button.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:tnazul/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/country.dart';
import 'package:tnazul/models/user.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/providers/home_provider.dart';
import 'package:tnazul/shared_preferences/shared_preferences_helper.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/utils/commons.dart';
import 'package:tnazul/utils/urls.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class EditPersonalInfoScreen extends StatefulWidget {
  @override
  _EditPersonalInfoScreenState createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> with ValidationMixin {
 double _height = 0 , _width = 0;
 String _userName = '',_userPhone = '',_userEmail ='',_userShow ='';
 AuthProvider _authProvider;
 bool _initialRun = true;
 bool _isLoading = false;
 Country _selectedCountry;
 bool _initSelectedCountry = true;
  Future<List<Country>> _countryList;
  HomeProvider _homeProvider;
    final _formKey = GlobalKey<FormState>();
  ApiProvider _apiProvider = ApiProvider();
 bool checkedValue=false;
 bool checkedValue11;

 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
      
      _countryList = _homeProvider.getCountryList();
      _userName = _authProvider.currentUser.userName;
      _userPhone = _authProvider.currentUser.userPhone;
      _userEmail = _authProvider.currentUser.userEmail;
      _userShow = _authProvider.currentUser.userShow;

      if(_userShow=="true"){
        checkedValue11=true;
      }else{
        checkedValue11=false;
      }
      _initialRun = false;
      print(_authProvider.currentUser.userShow);
    }
  }
Widget _buildBodyItem(){

  return SingleChildScrollView(

    child: Container(
      height: _height,
      width: _width,
      child: Form(
        key: _formKey,
        child: Column(
     
          children: <Widget>[

            SizedBox(
              height: 80,
            ),
             CustomTextFormField(
               initialValue: _userName,
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/user.png',
                hintTxt:AppLocalizations.of(context).translate('user_name'),
                validationFunc:validateUserName,
               onChangedFunc: (text) {
                 _userName = text;
               },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: _height *0.02),
                child: CustomTextFormField(
                  initialValue: _userPhone,
                  prefixIconIsImage: true,
                  prefixIconImagePath: 'assets/images/call.png',
                  hintTxt:  AppLocalizations.of(context).translate('phone_no'),
                  validationFunc: validateUserPhone,
                  onChangedFunc: (text) {
                    _userPhone = text;
                  },
                ),
              ),
                CustomTextFormField(
                  initialValue: _userEmail,
                  prefixIconIsImage: true,
                  prefixIconImagePath: 'assets/images/mail.png',
                  hintTxt: AppLocalizations.of(context).translate('email'),
                  validationFunc:  validateUserEmail,
                  onChangedFunc: (text) {
                    _userEmail = text;
                  },
              ),

            Container(
              alignment: Alignment.centerRight,

              child: CheckboxListTile(

                checkColor: Colors.white,
                activeColor: mainAppColor,
                title: Text(_homeProvider.currentLang=="ar"?"اظهار رقم الهاتف ؟":"Show phone number?",style: TextStyle(fontSize: 15),),

                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                    _homeProvider.setCheckedValue(newValue.toString());
                    print(_homeProvider.checkedValue);
                    print(_userShow);
                  });
                },
                value:_homeProvider.checkedValue=="true"?true:false,

              ),
            ),

Spacer(),
            CustomButton(
              btnLbl: AppLocalizations.of(context).translate('save'),
              onPressedFunction: () async {
if (_formKey.currentState.validate()){
setState(() => _isLoading = true);
                    FormData formData = new FormData.fromMap({
                      "user_id": _authProvider.currentUser.userId,
                      "user_name":  _userName,        
                      "user_phone" : _userPhone,
                      "user_email":  _userEmail,
                      "user_show":  checkedValue,
                    });
                    final results = await _apiProvider
                        .postWithDio(Urls.PROFILE_URL + "?api_lang=${_authProvider.currentLang}", body: formData);
                    setState(() => _isLoading = false);

                    if (results['response'] == "1") {
                      _authProvider
                          .setCurrentUser(User.fromJson(results["user"]));
                      SharedPreferencesHelper.save(
                          "user", _authProvider.currentUser);
                      Commons.showToast(context,message: results["message"] );
                      Navigator.pop(context);
                    } else {
                      Commons.showError(context, results["message"]);
                    }
}
 
              },
              ),
              
SizedBox(
  height: _height *0.02,
)

              
          ],
        ),
      ),
    ),
  );
}


@override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    return PageContainer(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          _buildBodyItem(),
         Container(
              height: 60,
              decoration: BoxDecoration(
                color: mainAppColor,

              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Consumer<AuthProvider>(
                      builder: (context,authProvider,child){
                        return authProvider.currentLang == 'ar' ? Image.asset(
                      'assets/images/back.png',
                      color: Colors.white,
                    ): Transform.rotate(
                            angle: 180 * math.pi / 180,
                            child:  Image.asset(
                      'assets/images/back.png',
                      color: Colors.white,
                    ));
                      },
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text( AppLocalizations.of(context).translate('edit_info'),
                      style: Theme.of(context).textTheme.headline1),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),
               _isLoading
        ? Center(
            child:SpinKitFadingCircle(color: mainAppColor),
          )
        :Container()
        ],
      )),
    );
  }
}