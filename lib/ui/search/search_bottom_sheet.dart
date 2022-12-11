import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tnazul/custom_widgets/buttons/custom_button.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:tnazul/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/category.dart';
import 'package:tnazul/models/city.dart';
import 'package:tnazul/models/country.dart';
import 'package:tnazul/providers/home_provider.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/ui/search/search_screen.dart';



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

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({Key key}) : super(key: key);
  @override
  _SearchBottomSheetState createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> with ValidationMixin
  {
  String _searchKey = '';
  String _priceFrom = '';
  String _priceTo = '';
  Future<List<Country>> _countryList;
  Future<List<City>> _cityList;
  Country _selectedCountry;
  City _selectedCity;
  CategoryModel _selectedCategory;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  CategoryModel _selectedSub;
  String _xx9='';

  List<String> _adsTypee;
  String _selectedAdsTypee;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);



      _countryList = _homeProvider.getCountryList();
      _cityList = _homeProvider.getCityList(enableCountry: true,countryId:'95');
      _adsTypee= _homeProvider.currentLang=="ar"?["عرض", "طلب"]:["offer", "request"];
      _initialRun = false;
    }
  }

  Widget build(BuildContext context) {
    var adsTypee = _adsTypee.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus( FocusNode());
            },
            child: Container(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: ListView(children: <Widget>[

                Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: mainAppColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate('search_now'),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),

                SizedBox(height: 35,),

                Container(
                  width: constraints.maxWidth,

                  child: CustomTextFormField(
                    hintTxt: _homeProvider.currentLang=="ar"?"بحث بعنون الاعلن ..":"Search by ads title ..",
                    onChangedFunc: (text) {
                      _searchKey = text;
                    },

                  ),
                ),


                SizedBox(height: 20,),
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
                          hint:     _homeProvider.omarKey=="1"?AppLocalizations.of(context).translate('choose_country'):"الدولة",
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




            SizedBox(height: 20,),





                CustomButton(
                  btnLbl:  AppLocalizations.of(context).translate('search'),
                  onPressedFunction: () {
                 if (
checkSearchValidation(context)){
   _homeProvider.setEnableSearch(true);
                    _homeProvider.setSearchKey(_searchKey);
                    _homeProvider.setSelectedCountry(_selectedCountry);
                     _homeProvider.setSelectedCity(_selectedCity);
                     Navigator.pop(context);
   Navigator.pushReplacement(
       context,
       MaterialPageRoute(
           builder: (context) =>
               SearchScreen()));
}
                   
                  },
                ),
              ]),
            ),
          ));
    });
  }
}
