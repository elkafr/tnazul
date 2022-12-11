import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/buttons/custom_button.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/utils/commons.dart';
import 'package:tnazul/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/providers/terms_provider.dart';
import 'dart:math' as math;

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
import 'package:url_launcher/url_launcher.dart';

class ContactWithUsScreen extends StatefulWidget {
  @override
  _ContactWithUsScreenState createState() => _ContactWithUsScreenState();
}

class _ContactWithUsScreenState extends State<ContactWithUsScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
   ApiProvider _apiProvider = ApiProvider();
 bool _isLoading = false;
bool _initialRun = true;
AuthProvider _authProvider;
 String _userName ='' ,_userEmail ='' , _message ='';

  Widget _buildBodyItem() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            CircleAvatar(
              radius: _height * 0.07,
              backgroundColor: mainAppColor,
              child: Icon(
                Icons.mail,
                size: _height * 0.07,
                color: Colors.white,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: _height * 0.02),
                child: CustomTextFormField(

                  prefixIconIsImage: true,
                  onChangedFunc: (text){
                    _userName = text;
                  },
                  prefixIconImagePath: 'assets/images/user.png',
                  hintTxt: AppLocalizations.of(context).translate('user_name'),
                  validationFunc: validateUserName
                
                )),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(

                prefixIconIsImage: true,
                onChangedFunc: (text){
                  _userEmail = text;
                },
                prefixIconImagePath: 'assets/images/mail.png',
                hintTxt: AppLocalizations.of(context).translate('email'),
                validationFunc: validateUserEmail
              ),
            ),
            CustomTextFormField(
              maxLines: 3,
              onChangedFunc: (text){
                _message = text;
              },
              hintTxt: AppLocalizations.of(context).translate('message'),
              validationFunc:  validateMsg,
            ),
            Container(
              margin: EdgeInsets.only(top: _height *0.02,bottom: _height *0.02),
              child: _buildSendBtn()
            ),
  Container(
              margin: EdgeInsets.symmetric(
                  horizontal: _width * 0.1, vertical: _height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FutureBuilder<String>(
                      future: Provider.of<TermsProvider>(context,
                          listen: false)
                          .getTwitt() ,
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
                              return GestureDetector(
                                  onTap: () {
                                     launch(snapshot.data.toString());
                                  },
                                  child: Image.asset(
                                    'assets/images/twitter.png',
                                    height: 40,
                                    width: 40,
                                  ));
                            }
                        }
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      })
                 ,
                  FutureBuilder<String>(
                      future: Provider.of<TermsProvider>(context,
                          listen: false)
                          .getLinkid() ,
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
                              return GestureDetector(
                                  onTap: () {
                                    launch(snapshot.data.toString());
                                  },
                                  child: Image.asset(
                                    'assets/images/linkedin.png',
                                    height: 40,
                                    width: 40,
                                  ));
                            }
                        }
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      }),
                  FutureBuilder<String>(
                      future: Provider.of<TermsProvider>(context,
                          listen: false)
                          .getInst() ,
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
                              return GestureDetector(
                                  onTap: () {
                                    launch(snapshot.data.toString());
                                  },
                                  child: Image.asset(
                                    'assets/images/instagram.png',
                                    height: 40,
                                    width: 40,
                                  ));
                            }
                        }
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      }),
                  FutureBuilder<String>(
                      future: Provider.of<TermsProvider>(context,
                          listen: false)
                          .getFace() ,
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
                              return GestureDetector(
                                  onTap: () {
                                    launch(snapshot.data.toString());
                                  },
                                  child: Image.asset(
                                    'assets/images/facebook.png',
                                    height: 40,
                                    width: 40,
                                  ));
                            }
                        }
                        return Center(
                          child: SpinKitFadingCircle(color: mainAppColor),
                        );
                      }),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

Widget _buildSendBtn() {
    return _isLoading
        ? Center(
            child:SpinKitFadingCircle(color: mainAppColor),
          )
        : CustomButton(
              btnLbl: AppLocalizations.of(context).translate('send'),
              onPressedFunction: () async {
                if (_formKey.currentState.validate()) {

                  setState(() {
                    _isLoading = true;
                  });
                 final results = await _apiProvider
                      .post(Urls.CONTACT_URL + "?api_lang=${_authProvider.currentLang}", body: {
                    "msg_name":  _userName,
                    "msg_email": _userEmail,
                    "msg_details":_message

                  });
               
            setState(() => _isLoading = false);
                  if (results['response'] == "1") {
                    Commons.showToast(context, message:results["message"]);
                    Navigator.pop(context);

                      
                  } else {
                    Commons.showError(context, results["message"]);

                  }
                   
                }
              },
            );
  }

 



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);

     _initialRun = false;
    }
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
                  Text( AppLocalizations.of(context).translate('contact_us'),
                      style: Theme.of(context).textTheme.headline1),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),
        ],
      )),
    );
  }
}
