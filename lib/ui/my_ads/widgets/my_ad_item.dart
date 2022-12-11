import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/custom_widgets/buttons/custom_button.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/ad.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/ui/edit_ad/edit_ad_screen.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/utils/commons.dart';
import 'package:tnazul/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:tnazul/custom_widgets/drop_down_list_selector/drop_down_list_selector1.dart';
import 'package:tnazul/providers/home_provider.dart';

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

class MyAdItem extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final Ad ad;

  const MyAdItem({Key key, this.animationController, this.animation, this.ad})
      : super(key: key);
  @override
  _MyAdItemState createState() => _MyAdItemState();
}

class _MyAdItemState extends State<MyAdItem> {
  final _formKey = GlobalKey<FormState>();
  bool _initialRun = true;
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  AuthProvider _authProvider;
  HomeProvider _homeProvider;
  List<String> _adsFrom;
  String _selectedAdsFrom;
  String xx1='';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);

      _adsFrom =
          _homeProvider.currentLang == "ar" ? ["نعم"] : ["yes"];

      _initialRun = false;
    }
  }

  Widget _buildItem(String title, String imgPath) {
    return Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(2)),
        Image.asset(
          imgPath,
          color: Color(0xffC5C5C5),
          height: 14,
          width: 15,
        ),
        Padding(padding: EdgeInsets.all(4)),
        Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return Container(
              margin: EdgeInsets.only(
                  left: authProvider.currentLang == 'ar' ? 0 : 2,
                  right: authProvider.currentLang == 'ar' ? 2 : 0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: title.length > 1 ? 14 : 14,
                  color: Color(0xffC5C5C5),
                ),
                overflow: TextOverflow.ellipsis,
              ));
        })
      ],
    );
  }

  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);

    var adsFrom = _adsFrom.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(item),
        value: item,
      );
    }).toList();

    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: widget.animation,
              child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 50 * (1.0 - widget.animation.value), 0.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: constraints.maxWidth * 0.02,
                              right: constraints.maxWidth * 0.02,
                              bottom: constraints.maxHeight * 0.1),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
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
                          child: Stack(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0))),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  _authProvider.currentLang ==
                                                          'ar'
                                                      ? 10
                                                      : 0),
                                              bottomRight: Radius.circular(
                                                  _authProvider.currentLang ==
                                                          'ar'
                                                      ? 10
                                                      : 0),
                                              bottomLeft: Radius.circular(
                                                (_authProvider.currentLang !=
                                                        'ar'
                                                    ? 10
                                                    : 0),
                                              ),
                                              topLeft: Radius.circular(
                                                  (_authProvider.currentLang !=
                                                          'ar'
                                                      ? 10
                                                      : 0))),
                                          child: Image.network(
                                            widget.ad.adsPhoto,
                                            height: constraints.maxHeight,
                                            width: constraints.maxWidth * 0.3,
                                            fit: BoxFit.cover,
                                          ))),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical:
                                                constraints.maxHeight * 0.04,
                                            horizontal:
                                                constraints.maxWidth * 0.02),
                                        width: constraints.maxWidth * 0.62,
                                        child: Text(
                                          widget.ad.adsTitle,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              height: 1.4),
                                          maxLines: 3,
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Row(
                                          children: <Widget>[
                                            _buildItem(widget.ad.adsCountryName,
                                                'assets/images/pin.png'),
                                            Spacer(),
                                            _buildItem(widget.ad.adsDate,
                                                'assets/images/time.png'),
                                          ],
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(2)),




                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                constraints.maxWidth * 0.01,
                                            vertical:
                                                constraints.maxHeight * 0.025),
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      constraints.maxWidth *
                                                          0.02),
                                              width:
                                                  constraints.maxWidth * 0.22,
                                              child: CustomButton(
                                                height: 35,
                                                defaultMargin: false,
                                                btnLbl:
                                                    AppLocalizations.of(context)
                                                        .translate('edit'),
                                                onPressedFunction: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditAdScreen(
                                                                ad: widget.ad,
                                                              )));
                                                },
                                              ),
                                            ),
                                            Container(
                                                width:
                                                    constraints.maxWidth * 0.22,
                                                child: CustomButton(
                                                  onPressedFunction: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    final results =
                                                        await _apiProvider.post(
                                                            Urls.DELETE_AD_URL +
                                                                "?id=${widget.ad.adsId}&user_id=${_authProvider.currentUser.userId}&api_lang=${_authProvider.currentLang}");

                                                    setState(() =>
                                                        _isLoading = false);
                                                    if (results['response'] ==
                                                        "1") {
                                                      Commons.showToast(context,
                                                          message: results[
                                                              "message"]);
                                                      Navigator
                                                          .pushReplacementNamed(
                                                              context,
                                                              '/my_ads_screen');
                                                    } else {
                                                      Commons.showError(context,
                                                          results["message"]);
                                                    }
                                                  },
                                                  height: 35,
                                                  defaultMargin: false,
                                                  btnColor: Colors.white,
                                                  btnStyle: TextStyle(
                                                      color: mainAppColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                  btnLbl: AppLocalizations.of(
                                                          context)
                                                      .translate('delete'),
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        _isLoading
                            ? Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              )
                            : Container()
                      ],
                    );
                  })));
        });
  }
}
