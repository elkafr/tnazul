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

class AddAdScreen extends StatefulWidget {
  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  Future<List<Country>> _countryList;
  Future<List<City>> _cityList;
  Country _selectedCountry;
  City _selectedCity;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  File _imageFile;
  String _xx=null;

  String _xx1='';
  String _xx2='';
  String _xx9='';

  bool checkedValue=false;



  dynamic _pickImageError;
  final _picker = ImagePicker();
  AuthProvider _authProvider;
  ApiProvider _apiProvider =ApiProvider();
  bool _isLoading = false;
  String _adsTitle = '';
  String _adsJob = '';
  String _adsEducation  = '';
  String _adsPhone = '';
  String _adsPhone1 = '';
  String _adsWhatsapp = '';
  String _adsDescription = '';




  NavigationProvider _navigationProvider;
  LocationData _locData;

  List<String> _adsFrom;
  String _selectedAdsFrom;

  List<String> _adsTypee;
  String _selectedAdsTypee;

  List<String> _adsType;
  String _selectedAdsType;

  List<String> _adsYears;
  String _selectedAdsYears;


   Future<void> _getCurrentUserLocation() async {
     _locData = await Location().getLocation();
    if(_locData != null){
      print('lat' + _locData.latitude.toString());
      print('longitude' + _locData.longitude.toString());
      Commons.showToast(context, message:
        AppLocalizations.of(context).translate('detect_location'));
        setState(() {

        });
    }
  }


  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }












  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {




      _homeProvider = Provider.of<HomeProvider>(context);

      _adsFrom = _homeProvider.currentLang=="ar"?["رب العمل", "الوافد", "أخري"]:["Employer", "newcomer", "Other"];
      _adsTypee= _homeProvider.currentLang=="ar"?["عرض", "طلب"]:["offer", "request"];
      _adsType = _homeProvider.currentLang=="ar"?["نقل بالتنازل", " إنتهاء عقد العمل", "فسخ عقد العمل" , "أخري"]:["Transfer assignment", "The work contract has expired","Termination of the employment contract","Other"];
      _adsYears = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"];

      _countryList = _homeProvider.getCountryList();
      _cityList = _homeProvider.getCityList(enableCountry: true,countryId:'95');

      _initialRun = false;
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








  Widget _buildBodyItem() {

    var adsFrom = _adsFrom.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();


    var adsTypee = _adsTypee.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();


    var adsType = _adsType.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    var adsYears = _adsYears.map((item) {
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



            GestureDetector(
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
                           _homeProvider.currentLang=="ar"?"صورة الاعلان":"Photograph",
                           style: TextStyle(
                               color: Colors.black,
                               fontWeight: FontWeight.w600,
                               fontSize: 15),
                         ):Text(
                           _homeProvider.currentLang=="ar"?"صورة الاعلان":"Photograph",
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
                )),






            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),

              child: CustomTextFormField(
                hintTxt: _homeProvider.omarKey=="1"?AppLocalizations.of(context).translate('ad_title'):"عنوان الاعلان",

                onChangedFunc: (text) {
                  _adsTitle = text;
                },
                validationFunc: validateAdTitle,
              ),
            ),



            Container(
              margin: EdgeInsets.only(top: _height * 0.01,bottom: _height * 0.01),
            ),
            FutureBuilder<List<Country>>(

              future: _countryList,
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  if (snapshot.hasData) {
                    var countryList = snapshot.data.map((item) {
                      return new DropdownMenuItem<Country>(

                        child: new Text(item.countryName),
                        value: item,
                      );
                    }).toList();
                    return DropDownListSelector(

                      dropDownList: countryList,
                      marg: .07,
                      hint:  _homeProvider.omarKey=="1"?AppLocalizations.of(context).translate('choose_country'):"الدولة",
                      onChangeFunc: (newValue) {
                        FocusScope.of(context).requestFocus( FocusNode());
                        setState(() {
                          _selectedCountry = newValue;

                          _homeProvider.setSelectedCountry(newValue);

                        });
                      },

                      value: _selectedCountry,

                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Center(child: CircularProgressIndicator());
              },
            ),




            /* ( _homeProvider.omarKey=="1"  && _homeProvider.typee=="1")?Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: DropDownListSelector(

                marg: .07,
                dropDownList: adsFrom,
                hint:  _homeProvider.currentLang=="ar"?"الإعلان من":"Advertise from",
                onChangeFunc: (newValue) {

                  FocusScope.of(context).requestFocus( FocusNode());
                  setState(() {
                    _selectedAdsFrom = newValue;
                  });
                },
                value: _selectedAdsFrom,
              ),
            ):Text("",style: TextStyle(height: 0),), */









            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.02),
              child: CustomTextFormField(
                maxLines: 3,
                hintTxt:  AppLocalizations.of(context).translate('ad_description'),
                validationFunc: validateAdDescription,
                onChangedFunc: (text) {
                  _adsDescription = text;
                },
              ),
            ),


            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                maxLines: 3,
                hintTxt:_homeProvider.currentLang=="ar"?"ايضاحات بواقع 50 حرف":"Explanations of 50 characters",
                validationFunc: validateAdDescription,
                onChangedFunc: (text) {
                  _adsEducation = text;
                },
              ),
            ),


            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              padding: EdgeInsets.only(right: 30),
              child:   Text(_homeProvider.currentLang=="ar"?"التواصل مع صاحب الاعلان":"Communicate with the advertisement owner",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            ),



            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                suffixIconIsImage: true,
                suffixIconImagePath: "assets/images/phone.png",
                hintTxt: _homeProvider.currentLang=="ar"?"رقم الجوال (05xxxxxxxx)":"Phone (05xxxxxxxx)",
                onChangedFunc: (text) {
                  _adsPhone = text;
                },
                validationFunc: validateNull,
              ),

            ),

           /* Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                suffixIconIsImage: true,
                suffixIconImagePath: "assets/images/phone.png",
                hintTxt: _homeProvider.currentLang=="ar"?"رقم جوال ..اختياري (05xxxxxxxx)":"Phone ..optional (05xxxxxxxx)",
                onChangedFunc: (text) {
                  _adsPhone1 = text;
                },

              ),

            ), */



            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                suffixIconIsImage: true,
                suffixIconImagePath: "assets/images/whats.png",
                hintTxt:  _homeProvider.currentLang=="ar"?"رقم الواتساب ..ان وجد (9665xxxxxxxx)":"whatsapp ..if found (966xxxxxxxx)",
                onChangedFunc: (text) {
                  _adsWhatsapp = text;
                },

              ),
            ),




            CustomButton(
              btnLbl: AppLocalizations.of(context).translate('publish_ad'),
              onPressedFunction: () async {
                if (_formKey.currentState.validate() &
                    checkAddAdValidation(context,
                        adCountry: _selectedCountry
                    )
                    ){

                               FocusScope.of(context).requestFocus( FocusNode());
                             setState(() => _isLoading = true);
                               String fileName = (_imageFile!=null)?Path.basename(_imageFile.path):"";

                /*   if(_selectedAdsFrom=="رب العمل"){
                     _xx1="1";
                   }else if(_selectedAdsFrom=="الوافد"){
                     _xx1="2";
                   }else if(_selectedAdsFrom=="أخري"){
                     _xx1="3";
                   }else if(_selectedAdsFrom=="Employer"){
                     _xx1="1";
                   }else if(_selectedAdsFrom=="newcomer"){
                     _xx1="2";
                   }else if(_selectedAdsFrom=="Other"){
                     _xx1="3";
                   } */


                               if(_selectedAdsTypee=="عرض"){
                                 _xx9="1";
                               }else if(_selectedAdsTypee=="طلب"){
                                 _xx9="2";
                               }else if(_selectedAdsTypee=="offer"){
                                 _xx9="1";
                               }else if(_selectedAdsTypee=="طلب"){
                                 _xx9="2";
                               }

                   if(_selectedAdsType=="نقل بالتنازل"){
                     _xx2="1";
                   }else if(_selectedAdsType=="إنتهاء عقد العمل"){
                     _xx2="2";
                   }else if(_selectedAdsType=="فسخ عقد العمل"){
                     _xx2="3";
                   }else if(_selectedAdsType=="أخري"){
                     _xx2="4";
                   }else if(_selectedAdsType=="Transfer assignment"){
                     _xx2="1";
                   }else if(_selectedAdsType=="The work contract has expired"){
                     _xx2="2";
                   }else if(_selectedAdsType=="Termination of the employment contract"){
                     _xx2="3";
                   }else if(_selectedAdsType=="Other"){
                     _xx2="4";
                   }

                  FormData formData = new FormData.fromMap({
                    "user_id": _authProvider.currentUser.userId,
                    "ads_title": _adsTitle,
                    "ads_job": _adsJob,
                    "ads_education": _adsEducation,
                    "ads_from":_xx1,
                    "ads_type":_xx2,
                    "ads_typee":_xx9,
                    "ads_years": _selectedAdsYears,
                    "ads_details": _adsDescription,
                    "ads_country": _selectedCountry.countryId,
                    "ads_phone": _adsPhone,
                    "ads_phone1": _adsPhone1,
                    "ads_whatsapp": _adsWhatsapp,
                    //"ads_location":'${_locData.latitude},${_locData.longitude}',
                    "imgURL[0]": (_imageFile!=null)?await MultipartFile.fromFile(_imageFile.path, filename: fileName):""
                  });
                  final results = await _apiProvider
                      .postWithDio(Urls.ADD_AD_URL + "?api_lang=${_authProvider.currentLang}", body: formData);
                  setState(() => _isLoading = false);


                  if (results['response'] == "1") {

                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return ConfirmationDialog(
                            title: AppLocalizations.of(context).translate('ad_has_published_successfully'),
                            message:
                                AppLocalizations.of(context).translate('ad_published_and_manage_my_ads'),
                          );
                        });
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                       Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/my_ads_screen');
                      _navigationProvider.upadateNavigationIndex(4);
                    });
                  } else {
                    Commons.showError(context, results["message"]);
                  }



                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _navigationProvider = Provider.of<NavigationProvider>(context);
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
                  Text(AppLocalizations.of(context).translate('add_ad'),
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
