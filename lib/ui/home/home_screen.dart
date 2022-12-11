import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/ad_item/ad_item.dart';
import 'package:tnazul/custom_widgets/no_data/no_data.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/providers/terms_provider.dart';
import 'package:tnazul/ui/add_ad/add_ad_screen.dart';
import 'package:tnazul/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:tnazul/models/ad.dart';
import 'package:tnazul/models/category.dart';
import 'package:tnazul/models/city.dart';
import 'package:tnazul/models/marka.dart';
import 'package:tnazul/models/model.dart';
import 'package:tnazul/providers/home_provider.dart';
import 'package:tnazul/providers/navigation_provider.dart';
import 'package:tnazul/ui/ad_details/ad_details_screen.dart';
import 'package:tnazul/ui/auth/login_screen.dart';
import 'package:tnazul/ui/home/widgets/category_item.dart';
import 'package:tnazul/ui/home/widgets/map_widget.dart';
import 'package:tnazul/ui/search/search_bottom_sheet.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/ui/account/account_screen.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/utils/error.dart';
import 'package:tnazul/providers/navigation_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:tnazul/custom_widgets/MainDrawer.dart';
import 'package:tnazul/utils/commons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  NavigationProvider _navigationProvider;
 Future<List<CategoryModel>> _categoryList;
 Future<List<CategoryModel>> _subList;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  AnimationController _animationController;
  AuthProvider _authProvider;

  Future<List<City>> _cityList;
  City _selectedCity;

  Future<List<Marka>> _markaList;
  Marka _selectedMarka;

  Future<List<Model>> _modelList;
  Model _selectedModel;

  CategoryModel _selectedSub;
  String _selectedCat;
  bool _isLoading = false;

  String _xx=null;





  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();

  }
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:true ,catId: '0',catName:
      _homeProvider.currentLang=="ar"?"الكل":"All",catImage: 'assets/images/all.png'),enableSub: false);


      _subList = _homeProvider.getSubList(enableSub: false,catId:_homeProvider.age!=''?_homeProvider.age:"6");


      _cityList = _homeProvider.getCityList(enableCountry: false);
      _markaList = _homeProvider.getMarkaList();
      _modelList = _homeProvider.getModelList();
      _initialRun = false;
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {


    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    return ListView(
      children: <Widget>[


        Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          child: FutureBuilder<String>(
              future: Provider.of<TermsProvider>(context,
                  listen: false)
                  .getNote() ,
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
                      return snapshot.data!=""?Text(snapshot.data,style: TextStyle(fontWeight: FontWeight.bold),):Text("",style: TextStyle(height: 0),);
                    }
                }
                return Center(
                  child: SpinKitFadingCircle(color: mainAppColor),
                );
              }),
        ),

        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Text(_homeProvider.currentLang=="ar"?"الاعلانات":"Ads",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              Spacer(),

              GestureDetector(
                  onTap: () {

                      showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          context: context,
                          builder: (builder) {
                            return Container(
                                width: _width,
                                height: _height * 0.6,
                                child: SearchBottomSheet());
                          });

                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    alignment: Alignment.center,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                      border: Border.all(
                        color: mainAppColor.withOpacity(0.4),
                      ),
                      color: Colors.white,
                    ),
                    child: Text(_homeProvider.currentLang=="ar"?"بحث":"Search",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: mainAppColor,

                      ),
                    ),
                  )),

              //Text(_homeProvider.omarKey)

            ],
          ),
        ),
        Container(height: 10,),
        Container(
            height: _height * 0.85,
            width: _width,
            child:
                Consumer<HomeProvider>(builder: (context, homeProvider, child) {
              return FutureBuilder<List<Ad>>(
                  future: homeProvider.enableSearch
                      ? Provider.of<HomeProvider>(context, listen: true)
                          .getAdsList()
                      : Provider.of<HomeProvider>(context, listen: true)
                          .getAdsList(),
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
                              errorMessage: snapshot.error.toString(),
                            //errorMessage: "حدث خطأ ما ",
                          );
                        } else {
                          if (snapshot.data.length > 0) {

                            return     ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var count = snapshot.data.length;
                                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  );
                                  _animationController.forward();
                                  return Container(
                                      height: _height*.12,
                                      width: _width,
                                      child: InkWell(
                                          onTap: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AdDetailsScreen(
                                                      ad: snapshot.data[index],


                                                    )));
                                          },
                                          child: AdItem(
                                            animationController: _animationController,
                                            animation: animation,
                                            ad: snapshot.data[index],
                                          )));
                                }
                            );

                          } else {
                            return NoData(message: 'لاتوجد نتائج');
                          }
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  });
            }))

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);

    final appBar = AppBar(
      backgroundColor: mainAppColor,
      centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu,color: Colors.white,size: 30,),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),

      title:Text("تنازل",style: TextStyle(fontSize: 20,color: Colors.white),),
actions: <Widget>[
  Text("datss",style: TextStyle(height: 0),)
],

    );
    _height = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);

    return PageContainer(
      child: Scaffold(
        appBar: appBar,
        drawer: MainDrawer(),
        body: FutureBuilder<String>(
            future: Provider.of<TermsProvider>(context,
                listen: false)
                .getClose(),
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
                    return snapshot.data=="0"?_buildBodyItem():FutureBuilder<String>(
                        future: Provider.of<TermsProvider>(context,
                            listen: false)
                            .getCloseMsg() ,
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
                                return Container(
                                  alignment: Alignment.center,

                                  child: Text(snapshot.data,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 20),),
                                );
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        });
                  }
              }
              return Center(
                child: SpinKitFadingCircle(color: mainAppColor),
              );
            }),
      ),
    );
  }
}
