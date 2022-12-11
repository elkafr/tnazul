import 'package:tnazul/ui/account/terms_and_rules_screen2.dart';
import 'package:tnazul/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/providers/home_provider.dart';
import 'package:tnazul/providers/navigation_provider.dart';
import 'package:tnazul/shared_preferences/shared_preferences_helper.dart';
import 'package:tnazul/ui/account/about_app_screen.dart';
import 'package:tnazul/ui/account/app_commission_screen.dart';
import 'package:tnazul/ui/account/contact_with_us_screen.dart';
import 'package:tnazul/ui/account/language_screen.dart';
import 'package:tnazul/ui/account/personal_information_screen.dart';
import 'package:tnazul/ui/account/terms_and_rules_Screen.dart';
import 'package:tnazul/ui/my_ads/my_ads_screen.dart';
import 'package:tnazul/ui/notification/notification_screen.dart';
import 'package:tnazul/ui/favourite/favourite_screen.dart';
import 'package:tnazul/ui/my_chats/my_chats_screen.dart';
import 'package:tnazul/ui/home/home_screen.dart';
import 'package:share/share.dart';
import 'package:tnazul/ui/blacklist/blacklist_screen.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/providers/terms_provider.dart';
import 'package:tnazul/utils/error.dart';


import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tnazul/custom_widgets/connectivity/network_indicator.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/user.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/providers/navigation_provider.dart';
import 'package:tnazul/shared_preferences/shared_preferences_helper.dart';
import 'package:tnazul/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:tnazul/utils/app_colors.dart';

import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return new _MainDrawer();
  }
}

class _MainDrawer extends State<MainDrawer> {
  double _height = 0 , _width = 0;

  NavigationProvider _navigationProvider;
  AuthProvider _authProvider ;
  HomeProvider _homeProvider ;
  bool _initialRun = true;



  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();

  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _firebaseCloudMessagingListeners() {
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    _flutterLocalNotificationsPlugin.initialize(platform);

    if (Platform.isIOS) _iOSPermission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        _showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
    );
  }

  _showNotification(Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
      'channel id',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await _flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platform);
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _homeProvider = Provider.of<HomeProvider>(context);
      _firebaseCloudMessagingListeners();
      _initialRun = false;
    }
  }




  @override
  Widget build(BuildContext context) {



      return Drawer(
          elevation: 20,

          child: ListView(
            padding: EdgeInsets.zero,

            children: <Widget>[




              (_authProvider.currentUser==null)?
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(30),
                color: mainAppColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                   Container(
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.all(Radius.circular(50.0)),
                       border: Border.all(
                         color: hintColor.withOpacity(0.4),
                       ),
                       color: Colors.white,


                     ),
                     child: Image.asset("assets/images/logo.png",width: 70,height:70 ,),
                   ),
                    Padding(padding: EdgeInsets.all(7)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(4)),
                        Text("زائر",style: TextStyle(color: Colors.white,fontSize: 18)),
                        Text("الحساب الشخصي",style: TextStyle(color: Colors.white,fontSize: 16),),
                      ],
                    )
                  ],
                ),
              )
                  :Container(
                color: mainAppColor,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.all(30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Consumer<AuthProvider>(
                        builder: (context,authProvider,child){
                          return CircleAvatar(
                            backgroundColor: accentColor,
                            backgroundImage: NetworkImage(authProvider.currentUser.userPhoto),
                            maxRadius: 40,
                          );
                        }
                    ),
                    Padding(padding: EdgeInsets.all(7)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(4)),
                        Text(_authProvider.currentUser.userName,style: TextStyle(color: Colors.white,fontSize: 18)),
                        Text("الحساب الشخصي",style: TextStyle(color: Colors.white,fontSize: 16),),
                      ],
                    )
                  ],
                ),
              ),


              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LanguageScreen())),
                dense:true,
                leading:new Icon(FontAwesomeIcons.language,color: Colors.black,),
                title: Text( AppLocalizations.of(context).translate("language"),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              ),


              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AboutAppScreen())),
                dense:true,
                leading: Image.asset('assets/images/about.png',color: Colors.black,),
                title: Text( AppLocalizations.of(context).translate("about_app"),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              ),
              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndRulesScreen())),
                dense:true,
                leading: Image.asset('assets/images/conditions.png',color: Colors.black,),
                title: Text( AppLocalizations.of(context).translate("rules_and_terms"),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              ),


              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TermsAndRulesScreen2())),
                dense:true,
                leading: Image.asset('assets/images/terms2.png',color: Colors.black,),
                title: Text( AppLocalizations.of(context).translate("rules_and_terms2"),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              ),


             /* (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersonalInformationScreen()))
                ,

                dense:true,
                leading: Image.asset('assets/images/edit.png',color: Colors.black,),
                title: Text(AppLocalizations.of(context).translate("personal_info"),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              ),*/




              /*(_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen())),
                dense:true,
                leading: Icon(FontAwesomeIcons.solidBell,color: mainAppColor,),
                title: Row(
                  children: <Widget>[
                    Text( AppLocalizations.of(context).translate("notifications"),style: TextStyle(
                        color: Colors.black,fontSize: 15
                    ),),
                    Padding(padding: EdgeInsets.all(3)),
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red),

                      child: FutureBuilder<String>(
                          future: Provider.of<HomeProvider>(context,
                              listen: false)
                              .getUnreadNotify() ,
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return Center(
                                  child: SpinKitFadingCircle(color: mainAppColor),
                                );
                              case ConnectionState.active:
                                return Text('');
                              case ConnectionState.waiting:
                                return Center(
                                  child: SpinKitFadingCircle(color: mainAppColor),
                                );
                              case ConnectionState.done:
                                if (snapshot.hasError) {
                                  return Error(
                                    //  errorMessage: snapshot.error.toString(),
                                    errorMessage: AppLocalizations.of(context).translate('error'),
                                  );
                                } else {
                                  return    Container(
                                      margin: EdgeInsets.symmetric(horizontal: _width *0.04),
                                      child: Text( snapshot.data.toString(),style: TextStyle(
                                          color: Colors.white,fontSize: 15,height: 1.6
                                      ),));
                                }
                            }
                            return Center(
                              child: SpinKitFadingCircle(color: mainAppColor),
                            );
                          }),
                    ),
                  ],
                ),
              ),




              (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavouriteScreen())),
                dense:true,
                leading: Icon(FontAwesomeIcons.solidHeart,color: mainAppColor,),
                title: Text(AppLocalizations.of(context).translate("favourite"),style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),*/


            /*  (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen())),
                dense:true,
                leading: Icon(FontAwesomeIcons.bell,color: Colors.black,),
                title: FutureBuilder<String>(
                    future: Provider.of<HomeProvider>(context,
                        listen: false)
                        .getUnreadNotify() ,
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
                            return  Row(
                              children: <Widget>[
                                Text( AppLocalizations.of(context).translate("notifications"),style: TextStyle(
                                    color: Colors.black,fontSize: 15
                                ),),
                                Padding(padding: EdgeInsets.all(3)),
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),

                                  child: snapshot.data!="0"?Container(
                                      margin: EdgeInsets.symmetric(horizontal: _width *0.04),
                                      child: Text( snapshot.data.toString(),style: TextStyle(
                                          color: Colors.white,fontSize: 15,height: 1.6
                                      ),)):Text("",style: TextStyle(height: 0),),
                                ),
                              ],
                            );
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    }),
              ), */







              (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyAdsScreen())),
                dense:true,
                leading: Image.asset('assets/images/adds.png',color: Colors.black,),
                title: Text( AppLocalizations.of(context).translate("my_ads"),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              ),

            /*  (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyChatsScreen())),
                dense:true,
                leading: Icon(FontAwesomeIcons.envelope,color: Colors.black,),
                title: FutureBuilder<String>(
                    future: Provider.of<HomeProvider>(context,
                        listen: false)
                        .getUnreadMessage() ,
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
                            return  Row(
                              children: <Widget>[
                                Text( AppLocalizations.of(context).translate("my_chats"),style: TextStyle(
                                    color: Colors.black,fontSize: 15
                                ),),
                                Padding(padding: EdgeInsets.all(3)),
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red),

                                  child: snapshot.data!="0"?Container(
                                      margin: EdgeInsets.symmetric(horizontal: _width *0.04),
                                      child: Text( snapshot.data.toString(),style: TextStyle(
                                          color: Colors.white,fontSize: 15,height: 1.6
                                      ),)):Text("",style: TextStyle(height: 0),),
                                ),
                              ],
                            );
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    }),
              ), */











              /* (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlacklistScreen())),
                dense:true,
                leading: Image.asset('assets/images/chat.png',color: mainAppColor,),
                title: Text( AppLocalizations.of(context).translate("blacklist"),style: TextStyle(
                    color: Colors.black,fontSize: 15
                ),),
              ),  */


              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactWithUsScreen())),
                dense:true,
                leading: Image.asset('assets/images/call.png',color: Colors.black,),
                title: Text( AppLocalizations.of(context).translate("contact_us"),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              ),



              ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppCommissionScreen())),
                dense:true,
                leading: Image.asset('assets/images/3mola.png',color: Colors.black,),
                title: Text( AppLocalizations.of(context).translate("app_commission"),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              ),


              FutureBuilder<String>(
                  future: Provider.of<TermsProvider>(context,
                      listen: false)
                      .getGoogleplay() ,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      case ConnectionState.active:
                        return Text('');
                      case ConnectionState.waiting:
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Error(
                            //  errorMessage: snapshot.error.toString(),
                            errorMessage:  AppLocalizations.of(context).translate('error'),
                          );
                        } else {
                          return   ListTile(

                            onTap: (){
                              Share.share(
                                snapshot.data,
                                subject: "حمل تطبيق تنازل الان !!",
                                sharePositionOrigin: Rect.fromLTWH(0, 0, _width, _height / 2),
                              );
                            },
                            dense:true,
                            leading: Image.asset('assets/images/share.png',color: Colors.black,),
                            title: Text(_homeProvider.currentLang=="ar"?"شارك التطبيق":"Share app",style: TextStyle(
                                color: Colors.black,fontSize: 14
                            ),),
                          );
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  })

              ,

              (_authProvider.currentUser==null)?ListTile(
                onTap: ()=>    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen())),
                dense:true,
                leading: Image.asset('assets/images/logout.png',color: Colors.black,),
                title: Text( AppLocalizations.of(context).translate("login"),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
              ):ListTile(
                dense:true,
                leading: Image.asset('assets/images/logout.png',color: Colors.black,),
                title: Text( AppLocalizations.of(context).translate('logout'),style: TextStyle(
                    color: Colors.black,fontSize: 14
                ),),
                onTap: (){
                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (_) {
                        return LogoutDialog(
                          alertMessage:
                          AppLocalizations.of(context).translate('want_to_logout'),
                          onPressedConfirm: () {
                            Navigator.pop(context);
                            SharedPreferencesHelper.remove("user");

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen()));
                            _authProvider.setCurrentUser(null);
                          },
                        );
                      });
                },
              ),


            ],
          ));


  
  }
}
