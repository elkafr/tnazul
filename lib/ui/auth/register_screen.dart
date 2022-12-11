import 'package:flutter/cupertino.dart';
import 'package:tnazul/ui/account/terms_and_rules_screen.dart';
import 'package:tnazul/ui/account/terms_and_rules_screen1.dart';
import 'package:tnazul/ui/auth/login_screen.dart';
import 'package:tnazul/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/buttons/custom_button.dart';
import 'package:tnazul/custom_widgets/custom_selector/custom_selector.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:tnazul/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/providers/register_provider.dart';
import 'package:tnazul/providers/terms_provider.dart';
import 'package:tnazul/providers/home_provider.dart';
import 'package:tnazul/ui/auth/widgets/select_country_bottom_sheet.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/utils/commons.dart';
import 'package:tnazul/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/ui/account/active_account_screen.dart';
import 'package:tnazul/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'dart:math' as math;



import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/buttons/custom_button.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:tnazul/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:tnazul/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/category.dart';
import 'package:tnazul/models/city.dart';
import 'package:tnazul/models/country.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/providers/home_provider.dart';
import 'package:tnazul/providers/navigation_provider.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/utils/commons.dart';
import 'package:tnazul/utils/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/models/marka.dart';
import 'package:tnazul/models/model.dart';
import 'package:path/path.dart' as Path;
import 'dart:math' as math;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  RegisterProvider _registerProvider;
  HomeProvider _homeProvider;
  bool _initalRun = true;
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  TermsProvider _termsProvider = TermsProvider();
  String _userName = '', _userPhone = '', _userEmail = '', _userPassword = '', _userSgl = '', _userFashNumber = '', _userFashAdress = '';

  String _xx9='';
  List<String> _userType;
  String _selectedUserType;
  File _imageFile;
  File _imageFile1;
  dynamic _pickImageError;
  final _picker = ImagePicker();


  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }



  void _onImageButtonPressed1(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile1 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initalRun) {
      _registerProvider = Provider.of<RegisterProvider>(context);
      _homeProvider = Provider.of<HomeProvider>(context);
      _registerProvider.getCountryList();
      _termsProvider.getTerms();
      _userType= _homeProvider.currentLang=="ar"?["مستخدم", "مكتب استقدام"]:["user", "Recruiting Office"];
    }
  }



  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }


  void _settingModalBottomSheet1(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.subject),
                    title: new Text('Gallery'),
                    onTap: (){
                      _onImageButtonPressed1(ImageSource.gallery,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Camera'),
                    onTap: (){
                      _onImageButtonPressed1(ImageSource.camera,
                          context: context);
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          );
        }
    );
  }



  Widget _buildBodyItem() {

    var userType = _userType.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),



            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: DropDownListSelector(

                marg: .07,
                dropDownList: userType,
                hint:  _homeProvider.currentLang=="ar"?"نوع العضوية":"Membership type",

                onChangeFunc: (newValue) {

                  if(newValue=="مستخدم"){
                    _xx9="1";
                  }else if(newValue=="مكتب استقدام"){
                    _xx9="2";
                  }else if(newValue=="user"){
                    _xx9="1";
                  }else if(newValue=="Recruiting Office"){
                    _xx9="2";
                  }
                  _homeProvider.setTypee(_xx9);

                  FocusScope.of(context).requestFocus( FocusNode());
                  setState(() {
                    _selectedUserType = newValue;
                  });
                },
                value: _selectedUserType,

              ),
            ),


            CustomTextFormField(
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/user.png',
              hintTxt: AppLocalizations.of(context).translate('user_name'),
              validationFunc: validateUserName,
              onChangedFunc: (text) {
                _userName = text;
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/call.png',
                hintTxt: AppLocalizations.of(context).translate('phone_no'),
                validationFunc: validateUserPhone,
                onChangedFunc: (text) {
                  _userPhone = text;
                },
              ),
            ),
            CustomTextFormField(
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/mail.png',
              hintTxt:AppLocalizations.of(context).translate('email'),
              validationFunc: validateUserEmail,
              onChangedFunc: (text) {
                _userEmail = text;
              },
            ),
            SizedBox(
              height: 15,
            ),


            Container(
              margin: EdgeInsets.only(bottom: _height * 0.02),
              child: CustomTextFormField(
                isPassword: true,
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/key.png',
                hintTxt: AppLocalizations.of(context).translate('password'),
                validationFunc: validatePassword,
                onChangedFunc: (text) {
                  _userPassword = text;
                },
              ),
            ),
            CustomTextFormField(
              isPassword: true,
              prefixIconIsImage: true,
              prefixIconImagePath: 'assets/images/key.png',
              hintTxt:  AppLocalizations.of(context).translate('confirm_password'),
              validationFunc: validateConfirmPassword,
            ),


            _xx9=="2"?Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                hintTxt: _homeProvider.currentLang=="ar"?"رقم السجل ( اجباري )":"Record number (mandatory)",
                validationFunc: validateUserPhone,
                onChangedFunc: (text) {
                  _userSgl = text;
                },
              ),
            ):Text(""),




            _xx9=="2"?GestureDetector(
                onTap: (){
                  _settingModalBottomSheet(context);
                },
                child: Container(
                  height: _height * 0.2,
                  width: _width,
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.07),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(
                      color: hintColor.withOpacity(0.4),
                    ),
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: _imageFile != null
                      ?ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:  Image.file(
                        _imageFile,
                        // fit: BoxFit.fill,
                      ))
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/camera.png',color: mainAppColor,),
                      Padding(padding: EdgeInsets.all(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _homeProvider.omarKey=="1"?Text(
                            _homeProvider.currentLang=="ar"?"صورة السجل":"log image",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ):Text(
                            _homeProvider.currentLang=="ar"?"صورة السجل":"log image",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                          Text(
                            _homeProvider.currentLang=="ar"?".. اختياري":".. Optional",
                            style: TextStyle(
                                color: Color(0xffA2A2A2),
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          )
                        ],
                      )
                    ],
                  ),
                )):Text(""),


            _xx9=="2"?Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                hintTxt: _homeProvider.currentLang=="ar"?"رقم الفسح ( اختياري )":"Clearance number (optional)",
                onChangedFunc: (text) {
                  _userFashNumber = text;
                },
              ),
            ):Text(""),




            _xx9=="2"?Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                hintTxt: _homeProvider.currentLang=="ar"?"عنوان الفسح ( اختياري )":"Clearance adress (optional)",
                onChangedFunc: (text) {
                  _userFashAdress = text;
                },
              ),
            ):Text(""),



            _xx9=="2"?Container(
              padding: EdgeInsets.all(5),
              color: mainAppColor,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: Text(_homeProvider.currentLang=="ar"?"سيتم تفعيل التسجيل بعد دفع رسوم الاشتراك":"Registration will be activated after paying the subscription fee",style: TextStyle(color: Colors.white),),
            ):Text(""),




        _xx9=="2"?Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("رسوم الاشتراك سنويا هى : "),
              FutureBuilder<String>(
                  future: Provider.of<TermsProvider>(context,
                      listen: false)
                      .getPay() ,
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
                          return null;
                        } else {
                          return Text(snapshot.data);
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  }),
              Text("ريال "),
            ],
          ),
        ):Text(""),


            _xx9=="2"?GestureDetector(
                onTap: (){
                  _settingModalBottomSheet1(context);
                },
                child: Container(
                  height: _height * 0.2,
                  width: _width,
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.07),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    border: Border.all(
                      color: hintColor.withOpacity(0.4),
                    ),
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: _imageFile1 != null
                      ?ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child:  Image.file(
                        _imageFile1,
                        // fit: BoxFit.fill,
                      ))
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/images/camera.png',color: mainAppColor,),
                      Padding(padding: EdgeInsets.all(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _homeProvider.omarKey=="1"?Text(
                            _homeProvider.currentLang=="ar"?"صورة التحويل":"conversion image",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ):Text(
                            _homeProvider.currentLang=="ar"?"صورة التحويل":"conversion image",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                          Text(
                            _homeProvider.currentLang=="ar"?".. اجباري":".. Mandatory",
                            style: TextStyle(
                                color: Color(0xffA2A2A2),
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          )
                        ],
                      )
                    ],
                  ),
                )):Text(""),


            Container(
                margin: EdgeInsets.symmetric(
                    vertical: _height * 0.01, horizontal: _width * 0.07),
                child: Row(
                  children: <Widget>[
                    Consumer<RegisterProvider>(
                        builder: (context, registerProvider, child) {
                      return GestureDetector(
                        onTap: () => registerProvider
                            .setAcceptTerms(!registerProvider.acceptTerms),
                        child: Container(
                          width: 25,
                          height: 25,
                          child: registerProvider.acceptTerms
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 17,
                                )
                              : Container(),
                          decoration: BoxDecoration(
                            color: registerProvider.acceptTerms
                                ? Color(0xffA8C21C)
                                : Colors.white,
                            border: Border.all(
                              color: registerProvider.acceptTerms
                                  ? Color(0xffA8C21C)
                                  : hintColor,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      );
                    }),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: _width * 0.02),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TermsAndRulesScreen1()));

                          },
                          child: RichText(

                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                  color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(text:  AppLocalizations.of(context).translate('accept_to_all')),
                                TextSpan(text: ' '),
                                TextSpan(
                                    text: AppLocalizations.of(context).translate('rules_and_terms1'),
                                    style:  TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Cairo',
                                        color: Color(0xffA8C21C))),
                              ],
                            ),
                          ),
                        )),
                  ],
                )),




            CustomButton(
              btnLbl: AppLocalizations.of(context).translate('make_account'),
              onPressedFunction: () async {
           
                if (_formKey.currentState.validate()) {

                    if (_registerProvider.acceptTerms) {

                   if(_selectedUserType!=null){


                      FocusScope.of(context).requestFocus( FocusNode());
                      setState(() => _isLoading = true);
                      String fileName = (_imageFile!=null)?Path.basename(_imageFile.path):"";
                      String fileName1 = (_imageFile1!=null)?Path.basename(_imageFile1.path):"";


                      FormData formData = new FormData.fromMap({
                        "user_name":_userName,
                        "user_phone": _userPhone,
                        "user_pass": _userPassword,
                        "user_pass_confirm":_userPassword,
                        "user_type":_xx9,
                        "user_sgl":_userSgl,
                        "user_fash_number":_userFashNumber,
                        "user_fash_adress":_userFashAdress,
                        //"user_country":_registerProvider.userCountry.countryId,
                        "user_email":_userEmail,
                        "imgURL": (_imageFile!=null)?await MultipartFile.fromFile(_imageFile.path, filename: fileName):"",
                        "imgURL1": (_imageFile1!=null)?await MultipartFile.fromFile(_imageFile1.path, filename: fileName1):""
                      });

                      final results =
                          await _apiProvider.postWithDio(Urls.REGISTER_URL, body:formData);

                      setState(() => _isLoading = false);
                      if (results['response'] == "1") {
                        _register();
                      } else {
                        Commons.showError(context, results["message"]);
                      }



                   } else {
                     Commons.showError(context, _homeProvider.currentLang=="ar"?"يجب اختيار نوع العضوية":"You must choose the type of membership");
                   }


                    } else {
                      Commons.showToast(context,
                          message:  AppLocalizations.of(context).translate('accept_rules_and_terms'),color: Colors.red);
                    }


                }
              },
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                child: Text(
                  AppLocalizations.of(context).translate('has_account'),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                )),
            CustomButton(
              btnLbl: AppLocalizations.of(context).translate('login'),
              btnColor: Colors.white,
              btnStyle: TextStyle(color: mainAppColor),
              onPressedFunction: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  _register() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return ConfirmationDialog(
            title:  AppLocalizations.of(context).translate('account_has created_successfully'),
            message:  AppLocalizations.of(context).translate('account_has created_successfully_use_app_now'),
          );
        });

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ActiveAccountScreen()));
    });
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
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
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
                  Text( AppLocalizations.of(context).translate('register'),
                      style: Theme.of(context).textTheme.headline1),
                  Spacer(
                    flex: 3,
                  ),
                ],
              )),
          _isLoading
              ? Center(
                  child: SpinKitFadingCircle(color: mainAppColor),
                )
              : Container()
        ],
      )),
    );
  }
}
