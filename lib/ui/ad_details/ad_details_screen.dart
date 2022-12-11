import 'package:tnazul/custom_widgets/buttons/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/safe_area/page_container.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/ad.dart';
import 'package:tnazul/models/ad_details.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/ad_details_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/providers/favourite_provider.dart';
import 'package:tnazul/ui/chat/chat_screen.dart';
import 'package:tnazul/ui/seller/seller_screen.dart';
import 'package:tnazul/ui/section_ads/section_ads_screen.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/utils/commons.dart';
import 'package:tnazul/utils/urls.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/utils/error.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:tnazul/ui/ad_details/widgets/slider_images.dart';
import 'package:tnazul/providers/home_provider.dart';
import 'package:tnazul/ui/comments/comment_bottom_sheet.dart';
import 'package:tnazul/custom_widgets/no_data/no_data.dart';
import 'package:tnazul/custom_widgets/custom_text_form_field/custom_text_form_field.dart';

import 'package:tnazul/ui/comment/comment_screen.dart';
import 'package:tnazul/ui/auth/login_screen.dart';

class AdDetailsScreen extends StatefulWidget {
  final Ad ad;

  const AdDetailsScreen({Key key, this.ad}) : super(key: key);
  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
  double _height = 0, _width = 0;
  ApiProvider _apiProvider = ApiProvider();
  AuthProvider _authProvider;
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  HomeProvider _homeProvider;
  String reportValue;
  String xx1;
  String xx2;

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/pin.png',
    );
  }

  Widget _buildRow(
      {@required String imgPath,
      @required String title,
      @required String value}) {
    return Row(
      children: <Widget>[
        Image.asset(
          imgPath,
          color: mainAppColor,
          height: 16,
          width: 16,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              title,
              style: TextStyle(color: omar, fontSize: 14),
            )),
        Spacer(),
        Text(
          value,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }






  Widget _buildRowGreen(
      {@required String imgPath,
        @required String title,
        @required String value}) {
    return Row(
      children: <Widget>[
        Image.asset(
          imgPath,
          color: mainAppColor,
          height: 16,
          width: 16,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              title,
              style: TextStyle(color: omar, fontSize: 14),
            )),
        Spacer(),
        Text(
          value,
          style: TextStyle(color: Colors.green, fontSize: 14),
        ),
      ],
    );
  }


  Widget _buildRowRed(
      {@required String imgPath,
        @required String title,
        @required String value}) {
    return Row(
      children: <Widget>[
        Image.asset(
          imgPath,
          color: mainAppColor,
          height: 16,
          width: 16,
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              title,
              style: TextStyle(color: omar, fontSize: 14),
            )),
        Spacer(),
        Text(
          value,
          style: TextStyle(color: Colors.red, fontSize: 14),
        ),
      ],
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(15)),
                Container(
                  child: Text(_homeProvider.currentLang == "ar"
                      ? "ارسال بلاغ :-"
                      : "Send report :-"),
                ),
                Padding(padding: EdgeInsets.all(15)),
                Container(
                  child: CustomTextFormField(
                    hintTxt: _homeProvider.currentLang == "ar"
                        ? "سبب البلاغ"
                        : "Report reason",
                    onChangedFunc: (text) async {
                      reportValue = text;
                    },

                  ),
                ),
                CustomButton(
                  btnColor: mainAppColor,
                  btnLbl: _homeProvider.currentLang == "ar" ? "ارسال" : "Send",
                  onPressedFunction: () async {
                    final results = await _apiProvider.post(
                        Urls.REPORT_AD_URL +
                            "?api_lang=${_authProvider.currentLang}",
                        body: {
                          "report_user": _authProvider.currentUser.userId,
                          "report_gid": widget.ad.adsId,
                          "report_value": reportValue,
                        });

                    if (results['response'] == "1") {
                      Commons.showToast(context, message: results["message"]);
                      Navigator.pop(context);
                    } else {
                      Commons.showError(context, results["message"]);
                    }
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
              ],
            ),
          );
        });
  }

  Widget _buildBodyItem() {



    return FutureBuilder<AdDetails>(
        future: Provider.of<AdDetailsProvider>(context, listen: false)
            .getAdDetails(widget.ad.adsId),
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

                if(snapshot.data.adsFrom=="1"){
                 xx1=_homeProvider.currentLang=="ar"?"رب العمل":"Employer";
                }else if(snapshot.data.adsFrom=="2"){
                  xx1=_homeProvider.currentLang=="ar"?"الوافد":"newcomer";
                }else if(snapshot.data.adsFrom=="3"){
                  xx1=_homeProvider.currentLang=="ar"?"أخري":"Other";
                }


                if(snapshot.data.adsType=="1"){
                  xx2=_homeProvider.currentLang=="ar"?"نقل بالتنازل":"Transfer assignment";
                }else if(snapshot.data.adsType=="2"){
                  xx2=_homeProvider.currentLang=="ar"?"إنتهاء عقد العمل":"The work contract has expired";
                }else if(snapshot.data.adsType=="3"){
                  xx2=_homeProvider.currentLang=="ar"?"فسخ عقد العمل":"Termination of the employment contract";
                }else if(snapshot.data.adsType=="4"){
                  xx2=_homeProvider.currentLang=="ar"?"أخري":"Other";
                }

                List comments = snapshot.data.adsComments;
                // List related= snapshot.data.adsRelated;
                var initalLocation = snapshot.data.adsLocation.split(',');
                LatLng pinPosition = LatLng(double.parse(initalLocation[0]),
                    double.parse(initalLocation[1]));

                // these are the minimum required values to set
                // the camera position
                CameraPosition initialLocation =
                    CameraPosition(zoom: 15, bearing: 30, target: pinPosition);

                return ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),



                    (_homeProvider.omarKey=="0")?GestureDetector(
                      child: CustomButton(
                        btnLbl: _homeProvider.currentLang=="ar"?"اخفاء المحتوى من هذا المعلن":"Hide content from this advertiser",
                        btnColor: mainAppColor,
                        onPressedFunction: () async{

                          final results = await _apiProvider
                              .post("https://tanazul.net/api/report999" +
                              "?api_lang=${_authProvider.currentLang}", body: {
                            // "report_user": _authProvider.currentUser.userId,
                            "report_gid": widget.ad.adsId,
                            //"report_value": reportValue,
                          });


                          if (results['response'] == "1") {
                            Commons.showToast(context, message: results["message"]);
                            Navigator.pop(context);
                          } else {
                            Commons.showError(context, results["message"]);
                          }

                        },
                      ),
                    ):Text(" ",style: TextStyle(height: 0),),




                    (_homeProvider.omarKey=="0")?GestureDetector(
                      child: CustomButton(
                        btnLbl: _homeProvider.currentLang=="ar"?"الابلاغ عن المحتوي":"Report content",
                        btnColor: mainAppColor,
                        onPressedFunction: () async{

                          final results = await _apiProvider
                              .post("https://tanazul.net/api/report9999" +
                              "?api_lang=${_authProvider.currentLang}", body: {
                            // "report_user": _authProvider.currentUser.userId,
                            "report_gid": widget.ad.adsId,
                            //"report_value": reportValue,
                          });


                          if (results['response'] == "1") {
                            Commons.showToast(context, message: results["message"]);
                          //  Navigator.pop(context);
                          } else {
                            Commons.showError(context, results["message"]);
                          }

                        },
                      ),
                    ):Text(" ",style: TextStyle(height: 0),),



                    _homeProvider.omarKey=="1"?Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: _width * 0.25, vertical: _height * 0.02),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            widget.ad.adsPhoto,
                            height: _height * 0.4,
                            fit: BoxFit.cover,
                          )),
                    ):Container(

                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Image.network(
                            widget.ad.adsPhoto,
                            height: _height * 0.4,
                            fit: BoxFit.cover,
                          )),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        widget.ad.adsTitle,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(

                      alignment: Alignment.center,
                      width: _width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.remove_red_eye,
                            color: mainAppColor,
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Text(
                            widget.ad.adsVisits,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text(
                            _homeProvider.currentLang=="ar"?"مشاهدة":"visit",
                            style: TextStyle(
                                fontSize: 14,
                                color: omar),
                          ),



                        ],
                      ),
                    ),



                    _homeProvider.omarKey=="1"?Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: _width * 0.10, vertical: _height * 0.01),
                      alignment: Alignment.center,
                      width: _width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[



                          Text(
                            _homeProvider.currentLang=="ar"?"نوع المعلن :":"Advertiser type:",
                            style: TextStyle(
                                fontSize: 14,
                                color: omar),
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text(
                            _homeProvider.currentLang=="ar"?"مكتب استقدام":"Recruiting Office",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: mainAppColor),
                          ),
                        ],
                      ),
                    ):Text(""),

                    Container(
                      height: _height * 0.1,
                      padding: EdgeInsets.only(right: 10,left: 10),
                      margin: EdgeInsets.symmetric(
                          horizontal: _width * 0.04, vertical: _height * 0.01),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: hintColor.withOpacity(0.4),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            _homeProvider.currentLang=="ar"?"المعلن":"The advertiser",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: omar),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              _homeProvider
                                  .setCurrentSeller(snapshot.data.adsUser);
                              _homeProvider.setCurrentSellerName(
                                  snapshot.data.adsUserName);
                              _homeProvider.setCurrentSellerPhone(
                                  snapshot.data.adsUserPhone);
                              _homeProvider.setCurrentSellerPhoto(
                                  snapshot.data.adsUserPhoto);

                              _homeProvider.setCurrentSellerShow(
                                  snapshot.data.adsUserShow);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SellerScreen(
                                        userId: snapshot.data.adsUser,
                                      )));
                            },
                            child: Text(
                              snapshot.data.adsUserName,
                              style: TextStyle(
                                  color: mainAppColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),


                          /* GestureDetector(
                            onTap: () {
                              launch("tel://${snapshot.data.adsPhone}");
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: _width * 0.025),
                                child:
                                Image.asset('assets/images/callnow.png')),
                          ),
                          GestureDetector(
                            onTap: () {
                              launch(
                                  "https://wa.me/${snapshot.data.adsWhatsapp}");
                            },
                            child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: _width * 0.025),
                                child: Image.asset('assets/images/whats.png')),
                          )*/
                        ],
                      ),
                    ),


                    Container(
                      height: _homeProvider.omarKey=="1"?150:100,
                      margin: EdgeInsets.symmetric(horizontal: _width * 0.04),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: hintColor.withOpacity(0.4),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[

                          SizedBox(
                            height: 5,
                          ),




                          

                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: _width * 0.04,
                                  vertical: _height * 0.001),
                              child: _buildRow(
                                  imgPath: 'assets/images/from.png',
                                  title: _homeProvider.currentLang=="ar"?"رقم الاعلان":"Ad number",
                                  value: snapshot.data.adsId)),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: _width * 0.04,
                                  vertical: _height * 0.001),
                              child: _buildRow(
                                  imgPath: 'assets/images/time.png',
                                  title: AppLocalizations.of(context)
                                      .translate('ad_time'),
                                  value: snapshot.data.adsDate)),



                          _homeProvider.omarKey=="1"?Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: _width * 0.04,
                                  vertical: _height * 0.001),
                              child: _buildRow(
                                  imgPath: 'assets/images/pin.png',
                                  title: _homeProvider.currentLang=="ar"?"الجنسية":"Nationality",
                                  value: snapshot.data.adsCountryName)):Text("",style: TextStyle(height: 0),),





                        /*  (_homeProvider.omarKey=="1" && snapshot.data.adsTypee=="1")?Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: _width * 0.04,
                                  vertical: _height * 0.001),
                              child: _buildRow(
                                  imgPath: 'assets/images/from.png',
                                  title: _homeProvider.currentLang=="ar"?"الاعلان من":"Advertise from",
                                  value: xx1)):Text("",style: TextStyle(height: 0),), */







                        ],
                      ),
                    ),

                 SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: _width * 0.04,
                      ),
                      child: Text(
                        _homeProvider.currentLang=="ar"?"الاعلان":"Advertising",
                        style: TextStyle(
                            color: omar,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: _width * 0.04,
                        ),
                        child: Text(
                          snapshot.data.adsDetails,
                          style: TextStyle(height: 1.4, fontSize: 14),
                          textAlign: TextAlign.justify,
                        )),



                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: _width * 0.04,
                      ),
                      child: Text(
                        _homeProvider.currentLang=="ar"?"ايضاحات":"clarifications",
                        style: TextStyle(
                            color: omar,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: _width * 0.04,
                        ),
                        child: Text(
                          snapshot.data.adsEducation,
                          style: TextStyle(height: 1.4, fontSize: 14),
                          textAlign: TextAlign.justify,
                        )),

                    Container(
                        margin: EdgeInsets.only(top: 25,bottom: 25,right: 15,left: 15),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10), topRight: Radius.circular(10),bottomRight:  Radius.circular(10)
                                ,bottomLeft:  Radius.circular(10)),
                            border: Border.all(
                              color: Color(0xffABABAB),
                              width: 1,
                            )
                        ),
                        child:   GestureDetector(
                            onTap: (){

                              if(_authProvider.currentUser==null){

                                Commons.showToast(context,
                                    message: "يجب عليك تسجيل الدخول اولا");

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LoginScreen()));

                              }else{

                                _homeProvider.setCurrentAds(widget.ad.adsId);

                                Navigator.push(context, MaterialPageRoute
                                  (builder: (context)=> CommentScreen()
                                ));




                              }

                            },
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "اضافة تعليق",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, color: Color(0xffABABAB)),
                                  ),),


                              ],
                            ))),


                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: _width * 0.04,
                      ),
                      child: Text(
                        _homeProvider.currentLang=="ar"?"أرقام التواصل":"Contact numbers",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            launch("tel://${snapshot.data.adsPhone}");
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(7.0)),

                                color: mainAppColor,
                              ),
                            padding: EdgeInsets.all(10),
                            width: _width*.45,
                            height: 50,

                              margin: EdgeInsets.symmetric(
                                  horizontal: _width * 0.025),
                              child:
                              Image.asset('assets/images/phone1.png',color: Colors.white,)),
                        ),

                        GestureDetector(
                          onTap: () {
                            launch(
                                "https://wa.me/${snapshot.data.adsWhatsapp}");
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(7.0)),

                                color: mainAppColor,
                              ),
                              padding: EdgeInsets.all(10),
                              width: _width*.45,
                              height: 50,
                              margin: EdgeInsets.symmetric(
                                  horizontal: _width * 0.025),
                              child: Image.asset('assets/images/whats1.png',color: Colors.white,)),
                        )
                      ],
                    ),


                    SizedBox(
                      height: 30,
                    ),

                    Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        decoration: BoxDecoration(
                          color: mainAppColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        ),
                        child:   GestureDetector(
                            onTap: (){
                              if (_authProvider.currentUser != null) {

                                Navigator.push(context, MaterialPageRoute
                                  (builder: (context)=> ChatScreen(
                                  senderId: snapshot.data.userDetails[0].id,
                                  senderImg: snapshot.data.userDetails[0].userImage,
                                  senderName:snapshot.data.userDetails[0].name,
                                  senderPhone:snapshot.data.userDetails[0].phone,
                                  adsId:snapshot.data.adsId,

                                )
                                ));
                              } else {
                                Navigator.pushNamed(
                                    context, '/login_screen');
                              }
                            },
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    child: Image.asset('assets/images/chat.png')),
                                Text(
                                  AppLocalizations.of(context).translate('send_to_advertiser'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700, color: Colors.white),
                                ),

                              ],
                            ))),
                  ],
                );
              }
          }
          return Center(
            child: SpinKitFadingCircle(color: mainAppColor),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
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
                      builder: (context, authProvider, child) {
                        return authProvider.currentLang == 'ar'
                            ? Image.asset(
                                'assets/images/back.png',
                                color: Colors.white,
                              )
                            : Transform.rotate(
                                angle: 180 * math.pi / 180,
                                child: Image.asset(
                                  'assets/images/back.png',
                                  color: Colors.white,
                                ));
                      },
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    width: _width * 0.55,
                    child: Text(widget.ad.adsTitle,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline1),
                  ),
                  Spacer(
                    flex: 3,
                  ),
          
                  Container(
                    width: _width * 0.02,
                  ),
                  IconButton(
                    onPressed: (){
                      Share.share(widget.ad.adsTitle+"  "+" - مشاركة من تطبيق تنازل - ",
                      );
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Container(
                    width: _width * 0.02,
                  ),
                ],
              )),
        ],
      )),
    );
  }
}
