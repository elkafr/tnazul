import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/buttons/custom_button.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/user.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/shared_preferences/shared_preferences_helper.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/utils/commons.dart';
import 'package:tnazul/utils/urls.dart';
import 'package:tnazul/ui/home/home_screen.dart';
import 'package:tnazul/providers/home_provider.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/locale/locale_helper.dart';

import 'package:provider/provider.dart';
import 'dart:math' as math;


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/no_data/no_data.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/notification_message.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/providers/notification_provider.dart';
import 'package:tnazul/ui/notification/widgets/notification_item.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/utils/error.dart';
import 'dart:math' as math;


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin{
double _height = 0 , _width = 0;
 final _formKey = GlobalKey<FormState>();
 AuthProvider _authProvider;
 ApiProvider _apiProvider = ApiProvider();
 bool _isLoading = false;
 String _userPhone ='' ,_userPassword ='';
HomeProvider _homeProvider;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String omar="";

Widget _buildBodyItem(){
  return SingleChildScrollView(
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 140,
          ),

          Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                top: 0,
                child:GestureDetector(
                  onTap: () {
                    if(_authProvider.currentLang != 'ar'){
                      SharedPreferencesHelper.setUserLang('ar');
                      helper.onLocaleChanged(new Locale('ar'));
                      _authProvider.setCurrentLanguage('ar');
                    }else if(_authProvider.currentLang != 'en'){
                      SharedPreferencesHelper.setUserLang('en');
                      helper.onLocaleChanged( Locale('en'));
                      _authProvider.setCurrentLanguage('en');

                    }


                  },
                  child: Container(

                      padding: EdgeInsets.only(left: 20,top: 10,right: 20,bottom: 10),
                      child: Text(_authProvider.currentLang=="ar"?"E":"AR",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),

                      decoration: BoxDecoration(
                        color: mainAppColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      )),
                )),

              Container(
                height: 100,
                alignment: Alignment.center,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),


          Container(
            margin: EdgeInsets.symmetric(
              vertical: _height *0.02
            ),
            child: CustomTextFormField(
              onChangedFunc: (text){
                _userPhone = text;
              },
              
                  prefixIconIsImage: true,
                  prefixIconImagePath: 'assets/images/fullcall.png',
                  hintTxt:  AppLocalizations.of(context).translate('phone_no')+" "+"05xxxxxxxx",
                     validationFunc: validateUserPhone,
                ),
          ),
          
           
          
            CustomTextFormField(
              isPassword: true,
                prefixIconIsImage: true,
                onChangedFunc: (text){
                  _userPassword =text;
                },
                prefixIconImagePath: 'assets/images/key.png',
                hintTxt: AppLocalizations.of(context).translate('password'),
                   validationFunc: validatePassword,
            ),


          FutureBuilder<String>(
              future: Provider.of<HomeProvider>(context,
                  listen: false)
                  .getOmar() ,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: SpinKitFadingCircle(color: Colors.black),
                    );
                  case ConnectionState.active:
                    return Text('');
                  case ConnectionState.waiting:
                    return Center(
                      child: SpinKitFadingCircle(color: Colors.black),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Error(
                        //  errorMessage: snapshot.error.toString(),
                        errorMessage: AppLocalizations.of(context).translate('error'),
                      );
                    } else {
                      omar=snapshot.data;
                      return  Row(
                        children: <Widget>[

                          Text("",style: TextStyle(height: 0),)
                        ],
                      );
                    }
                }
                return Center(
                  child: SpinKitFadingCircle(color: mainAppColor),
                );
              }),
            Container(
              margin: EdgeInsets.symmetric(horizontal: _width * 0.07,vertical: _height * 0.02),
               child: GestureDetector(
                 onTap: ()=> Navigator.pushNamed(context,  '/phone_password_reccovery_screen' ),
                 child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color:Colors.black , fontSize: 14, fontFamily: 'Cairo'),
                              children: <TextSpan>[
                                TextSpan(text:  AppLocalizations.of(context).translate('forget_password')),
                                TextSpan(
                                  text:  AppLocalizations.of(context).translate('click_here'),
                                  style: TextStyle(
                                      color: mainAppColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Cairo'),
                                ),
                              ],
                            ),
                          ),
               ),
            )
       
         , _buildLoginBtn()
      ,
         Container(
           margin: EdgeInsets.symmetric(vertical: _height *0.02),
           child: 
        Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.only(
                              right: _width * 0.08, left: _width * 0.02),
                          child: Divider(
                            color: Color(0xffC5C5C5),
                            height: 2,
                            thickness: 1,
                          ),
                        )),
                        Center(
                          child: Text(
                         AppLocalizations.of(context).translate('or'),
                            style: TextStyle(
                                color: Color(0xffC5C5C5),
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        ),
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.only(
                              left: _width * 0.08, right: _width * 0.02),
                          child: Divider(
                            color: Color(0xffC5C5C5),
                            height: 2,
                            thickness: 1,
                          ),
                        ))
                      ],
                    ),
         ),
       CustomButton(
           btnLbl:  AppLocalizations.of(context).translate('register'),
           btnColor: Colors.white,
           btnStyle: TextStyle(
             color: mainAppColor
           ),
           onPressedFunction: (){
             _homeProvider.setOmarKey(omar);
             Navigator.pushNamed(context, '/register_screen');
           },
         ),

       SizedBox(
         height: 25,
       ),
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_authProvider.currentLang=="ar"?"تصفح كزائر":"Browse as a visitor",style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,

                  ),),
                  Padding(padding: EdgeInsets.all(5)),
                  Image.asset('assets/images/arrow.png'),
                ],
              ),
            ),
            onTap: (){
              _homeProvider.setOmarKey(omar);
              Navigator.pushReplacementNamed(context,  '/navigation');
            },
          )
        ],
      ),
    ),
  );
}

 Widget _buildLoginBtn() {

    return _isLoading
        ? Center(
            child:SpinKitFadingCircle(color: mainAppColor),
          )
        : CustomButton(
              btnLbl:  AppLocalizations.of(context).translate('login'),
              onPressedFunction: () async {
                _homeProvider.setOmarKey(omar);
                if (_formKey.currentState.validate()) {
                     _firebaseMessaging.getToken().then((token) async {
                  print('token: $token');
          
                  setState(() {
                    _isLoading = true;
                  });
                 final results = await _apiProvider
                      .post(Urls.LOGIN_URL +"?api_lang=${_authProvider.currentLang}", body: {
                    "user_phone":  _userPhone,
                    "user_pass": _userPassword,
                    "token":token
                   
                  });
               
            setState(() => _isLoading = false);
                  if (results['response'] == "1") {
                     _login(results);
                      
                  } else {
                    Commons.showError(context, results["message"]);
                
                  }
                     });
                   
                }
              },
            );
  }

   _login(Map<String,dynamic> results) {
    _authProvider.setCurrentUser(User.fromJson(results["user_details"]));
    SharedPreferencesHelper.save("user", _authProvider.currentUser);
    Commons.showToast( context,message:results["message"] ,color:  mainAppColor);
    Navigator.pushReplacementNamed(context,  '/navigation');
  }


  @override
  Widget build(BuildContext context) {
         _height =  MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
         _homeProvider = Provider.of<HomeProvider>(context);
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
                  Text( AppLocalizations.of(context).translate('login'),
                      style: Theme.of(context).textTheme.headline1),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),




        ],
      )
      ),
    );
  }
}