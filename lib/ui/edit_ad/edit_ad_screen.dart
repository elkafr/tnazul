import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/buttons/custom_button.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:tnazul/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/ad.dart';
import 'package:tnazul/models/category.dart';
import 'package:tnazul/models/city.dart';
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
import 'package:path/path.dart' as Path;
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

class EditAdScreen extends StatefulWidget {
  final Ad ad;

  const EditAdScreen({Key key, this.ad}) : super(key: key);

  @override
  _EditAdScreenState createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> with ValidationMixin {
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

String _zz1='';
String _zz2='';

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


bool _initSelectedCity = true;
bool _initSelectedCountry= true;
bool _initSelectedFrom= true;

NavigationProvider _navigationProvider;
LocationData _locData;

List<String> _adsFrom;
String _selectedAdsFrom;

List<String> _adsType;
String _selectedAdsType;

List<String> _adsYears;
String _selectedAdsYears;

  Future<void> _getCurrentUserLocation() async {
    _locData = await Location().getLocation();
    if(_locData != null){
      Commons.showToast(context, message:  AppLocalizations.of(context).translate('detect_location'));
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

    if(widget.ad.adsFrom=="1"){
      _zz1=_homeProvider.currentLang=="ar"?"رب العمل":"Employer";
    }else if(widget.ad.adsFrom=="2"){
      _zz1=_homeProvider.currentLang=="ar"?"الوافد":"newcomer";
    }else if(widget.ad.adsFrom=="3"){
      _zz1=_homeProvider.currentLang=="ar"?"أخري":"Other";
    }




    if(widget.ad.adsType=="1"){
      _zz2=_homeProvider.currentLang=="ar"?"نقل بالتنازل":"Transfer assignment";
    }else if(widget.ad.adsType=="2"){
      _zz2=_homeProvider.currentLang=="ar"?"إنتهاء عقد العمل":"The work contract has expired";
    }else if(widget.ad.adsType=="3"){
      _zz2=_homeProvider.currentLang=="ar"?"فسخ عقد العمل":"Termination of the employment contract";
    }else if(widget.ad.adsType=="4"){
      _zz2=_homeProvider.currentLang=="ar"?"أخري":"Other";
    }



    var adsFrom = _adsFrom.map((item) {

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
            Container(
              padding: EdgeInsets.fromLTRB(25,5,25,10),
              child: _homeProvider.omarKey=="1"?Text(_homeProvider.currentLang=="ar"?"صورة الاعلان":"ads photo"):Text(_homeProvider.currentLang=="ar"?"صورة الاعلان":"Photograph"),
            ),

            Row(
              children: <Widget>[
                Padding(padding:EdgeInsets.fromLTRB(25,5,5,10)),
                GestureDetector(
                    onTap: (){
                      _settingModalBottomSheet(context);
                    },
                    child: Container(
                      height: _height * 0.2,
                      width: _width*.90,

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
                          :ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            widget.ad.adsPhoto,

                          )),
                    )),

                Padding(padding: EdgeInsets.all(5)),



              ],

            ),


        Container(
          padding: EdgeInsets.only(right: 30,top: 10),
          child:Text( _homeProvider.omarKey=="1"?AppLocalizations.of(context).translate('ad_title'):"عنوان الاعلان"),
        ),

            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                initialValue: widget.ad.adsTitle,
                hintTxt: AppLocalizations.of(context).translate('ad_title'),
                onChangedFunc: (text) {
                  _adsTitle = text;
                },
                validationFunc: validateAdTitle,
              ),
            ),





            Container(
              padding: EdgeInsets.only(right: 30,top: 10),
              child: Text(AppLocalizations.of(context).translate('choose_country')),
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

                    if (_initSelectedCountry) {

                      for (int i = 0; i < snapshot.data.length; i++) {
                        if (widget.ad.adsCountryName == snapshot.data[i].countryName) {
                          _selectedCountry = snapshot.data[i];
                          break;
                        }
                      }
                      _initSelectedCountry = false;


                    }

                    return DropDownListSelector(

                      dropDownList: countryList,
                      marg: .07,
                      hint:  AppLocalizations.of(context).translate('choose_country'),
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






           /* _homeProvider.omarKey=="1"?Container(
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


                value: _selectedAdsFrom!=null?_selectedAdsFrom:_zz1,


              ),
            ):Text("",style: TextStyle(height: 0),),*/







            Container(
              padding: EdgeInsets.only(right: 30,top: 10),
              child: Text(AppLocalizations.of(context).translate('ad_description')),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                initialValue: widget.ad.adsDetails,
                maxLines: 3,
                hintTxt: AppLocalizations.of(context).translate('ad_description'),
                validationFunc: validateAdDescription,
                onChangedFunc: (text) {
                  _adsDescription = text;
                },
              ),
            ),


            Container(
              padding: EdgeInsets.only(right: 30,top: 10),
              child: Text(_homeProvider.currentLang=="ar"?"ايضاحات بواقع 50 حرف":"Explanations of 50 characters",),
            ),

            (_homeProvider.omarKey=="1" )?Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),

              child: CustomTextFormField(
                hintTxt:_homeProvider.currentLang=="ar"?"ايضاحات بواقع 50 حرف":"Explanations of 50 characters",

                onChangedFunc: (text) {
                  _adsEducation = text;
                },
                validationFunc: validateNull,
                initialValue: widget.ad.adsEducation,
                maxLines: 3,
              ),
            ):Text("",style: TextStyle(height: 0),),


            Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                suffixIconIsImage: true,
                suffixIconImagePath: "assets/images/phone.png",
                hintTxt: _homeProvider.currentLang=="ar"?"رقم الجوال":"Phone",
                onChangedFunc: (text) {
                  _adsPhone = text;
                },
                validationFunc: validateNull,
                initialValue: widget.ad.adsPhone,
              ),

            ),


           /* Container(
              margin: EdgeInsets.symmetric(vertical: _height * 0.01),
              child: CustomTextFormField(
                suffixIconIsImage: true,
                initialValue: widget.ad.adsPhone1,
                suffixIconImagePath: "assets/images/phone.png",
                hintTxt: _homeProvider.currentLang=="ar"?"رقم جوال ..اختياري":"Phone ..optional",
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
                hintTxt:  _homeProvider.currentLang=="ar"?"رقم الواتساب ..ان وجد":"whatsapp ..if found",
                initialValue: widget.ad.adsWhatsapp,
                onChangedFunc: (text) {
                  _adsWhatsapp = text;
                },



              ),
            ),


            CustomButton(
              btnLbl: AppLocalizations.of(context).translate('save_edit'),
              onPressedFunction: () async {
                if (_formKey.currentState.validate()
                ){



                      FocusScope.of(context).requestFocus( FocusNode());
                  setState(() => _isLoading = true);
                  String fileName = (_imageFile!=null)?Path.basename(_imageFile.path):"";

                  if(_selectedAdsFrom=="رب العمل"){
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







                  FormData formData ;
                  if(_imageFile != null){
                    String fileName = Path.basename(_imageFile.path);
                    formData = new FormData.fromMap({
                      "user_id": _authProvider.currentUser.userId,
                      "ad_id": widget.ad.adsId,
                      "ads_title": _adsTitle,
                      "ads_job": _adsJob,
                      "ads_education": _adsEducation,
                      "ads_from":_xx1,
                      "ads_type":_xx2,
                      "ads_years": _selectedAdsYears,
                      "ads_details": _adsDescription,
                      "ads_country": _selectedCountry.countryId,
                      "ads_city": _selectedCity.cityId,
                      "ads_phone": _adsPhone,
                      "ads_phone1": _adsPhone1,
                      "ads_whatsapp": _adsWhatsapp,
                      //"ads_location":'${_locData.latitude},${_locData.longitude}',
                      "imgURL[0]": (_imageFile!=null)?await MultipartFile.fromFile(_imageFile.path, filename: fileName):""
                    });
                  }
                  else{
                    formData = new FormData.fromMap({
                      "user_id": _authProvider.currentUser.userId,
                      "ad_id": widget.ad.adsId,
                      "ads_title": _adsTitle,
                      "ads_job": _adsJob,
                      "ads_education": _adsEducation,
                      "ads_from":_xx1,
                      "ads_type":_xx2,
                      "ads_years": _selectedAdsYears,
                      "ads_details": _adsDescription,
                      "ads_country": _selectedCountry.countryId,

                      "ads_phone": _adsPhone,
                      "ads_phone1": _adsPhone1,
                      "ads_whatsapp": _adsWhatsapp,
                      //"ads_location":'${_locData.latitude},${_locData.longitude}',
                      "imgURL[0]": (_imageFile!=null)?await MultipartFile.fromFile(_imageFile.path, filename: fileName):""

                    });

                  }

                  final results = await _apiProvider
                      .postWithDio(Urls.EDIT_AD_URL+ "?api_lang=${_authProvider.currentLang}", body: formData);
                  setState(() => _isLoading = false);

                  if (results['response'] == "1") {
                    Commons.showToast(context, message:results["message"]);

                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/my_ads_screen');

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
                      Text( AppLocalizations.of(context).translate('ad_edit'),
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
