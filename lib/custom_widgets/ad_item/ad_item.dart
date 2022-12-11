import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tnazul/locale/app_localizations.dart';
import 'package:tnazul/models/ad.dart';
import 'package:tnazul/networking/api_provider.dart';
import 'package:tnazul/providers/auth_provider.dart';
import 'package:tnazul/providers/favourite_provider.dart';
import 'package:tnazul/providers/home_provider.dart';
import 'package:tnazul/ui/favourite/favourite_screen.dart';
import 'package:tnazul/utils/app_colors.dart';
import 'package:tnazul/utils/urls.dart';
import 'package:provider/provider.dart';

class AdItem extends StatefulWidget {

  final AnimationController animationController;
  final Animation animation;
  final bool insideFavScreen;
  final Ad ad;



  const AdItem({Key key, this.insideFavScreen = false, this.ad, this.animationController, this.animation}) : super(key: key);
  @override
  _AdItemState createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
double _height = 0 ,_width = 0;
  bool _initialRun = true;
  AuthProvider _authProvider;
  HomeProvider _homeProvider;
  FavouriteProvider _favouriteProvider;
  ApiProvider _apiProvider = ApiProvider();
bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _homeProvider = Provider.of<HomeProvider>(context);
      _favouriteProvider = Provider.of<FavouriteProvider>(context);

      if (widget.ad.adsIsFavorite == 1 && _authProvider.currentUser != null) {
        _favouriteProvider.addItemToFavouriteAdsList(
            widget.ad.adsId, widget.ad.adsIsFavorite);
      }
      print('favourite' + widget.ad.adsIsFavorite.toString());
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

  @override
  Widget build(BuildContext context) {
    return   AnimatedBuilder(
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
                                      Container(
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10),
                                        child: Row(
                                          children: <Widget>[
                                            _buildItem(widget.ad.adsVisits,
                                                'assets/images/view.png'),

                                          ],
                                        ),
                                      ),


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
