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

class AdItem1 extends StatefulWidget {

  final AnimationController animationController;
  final Animation animation;
  final bool insideFavScreen;
  final Ad ad;

  const AdItem1({Key key, this.insideFavScreen = false, this.ad, this.animationController, this.animation}) : super(key: key);
  @override
  _AdItemState createState() => _AdItemState();
}

class _AdItemState extends State<AdItem1> {
  double _height = 0 ,_width = 0;
  bool _initialRun = true;
  AuthProvider _authProvider;
  HomeProvider _homeProvider;
  FavouriteProvider _favouriteProvider;
  ApiProvider _apiProvider = ApiProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _homeProvider= Provider.of<HomeProvider>(context);
      _favouriteProvider = Provider.of<FavouriteProvider>(context);

      if (widget.ad.adsIsFavorite == 1 && _authProvider.currentUser != null) {
        _favouriteProvider.addItemToFavouriteAdsList(
            widget.ad.adsId, widget.ad.adsIsFavorite);
      }
      print('favourite' + widget.ad.adsIsFavorite.toString());
      _initialRun = false;
    }
  }

  Widget _buildItem(String title,String imgPath){
    return Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(2)),
        Image.asset(imgPath,color: Color(0xffC5C5C5),
          height: 14,
          width: 15,
        ),
        Padding(padding: EdgeInsets.all(4)),
        Consumer<AuthProvider>(
            builder: (context,authProvider,child){
              return  Container(
                  margin: EdgeInsets.only(left: authProvider.currentLang == 'ar' ? 0 : 2,right:  authProvider.currentLang == 'ar' ? 2 : 0 ),
                  child:   Text(title,style: TextStyle(
                      fontSize: title.length >1 ?14 : 14,color: Color(0xffC5C5C5),
                  ),
                    overflow: TextOverflow.ellipsis,
                  ));
            }
        )
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
                  child:LayoutBuilder(builder: (context, constraints) {
                    _height =  constraints.maxHeight;
                    _width = constraints.maxWidth;
                    return Container(
                     padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: constraints.maxWidth *0.03,
                          right: constraints.maxWidth *0.02,bottom: constraints.maxHeight*0.03),

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
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(_authProvider.currentLang == 'ar' ? 10 :0),
                                        bottomRight: Radius.circular(_authProvider.currentLang == 'ar' ? 10 :0),
                                        bottomLeft: Radius.circular((_authProvider.currentLang != 'ar' ? 10 :0),
                                        ),
                                        topLeft: Radius.circular((_authProvider.currentLang != 'ar' ? 10 :0))
                                    )
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(widget.ad.adsPhoto ,height: constraints.maxHeight *0.4,
                                      width: constraints.maxWidth,
                                      fit: BoxFit.cover,

                                    )),
                              ),
                              Expanded(
                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(

                                      margin: EdgeInsets.symmetric(
                                          vertical: constraints.maxHeight *0.01,
                                          horizontal: constraints.maxWidth *0.01
                                      ),
                                      width: constraints.maxWidth *0.85,

                                      child:  Text(widget.ad.adsTitle,style: TextStyle(
                                        color: Colors.black,fontSize: 16,
                                        fontWeight: FontWeight.bold,

                                      ),
                                        maxLines: 1,
                                      ),
                                      height: 30,
                                    ),


                                    _homeProvider.omarKey=="1"?_buildItem(widget.ad.adsJob, 'assets/images/job.png'):Text("",style: TextStyle(height: 0),),
                                    _buildItem(widget.ad.adsCityName, 'assets/images/city.png'),
                                    _buildItem(widget.ad.adsCountryName, 'assets/images/pin.png'),
                                    _buildItem(widget.ad.adsDate, 'assets/images/time.png'),
                                    Padding(padding: EdgeInsets.all(2)),
                                    Row(

                                      children: <Widget>[
                                        Text(
                                          widget.ad.adsUserName,
                                          style: TextStyle(
                                              color: mainAppColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,

                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          _homeProvider.currentLang=="ar"?"المزيد":"more",
                                          style: TextStyle(
                                              color: mainAppColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.underline
                                          ),
                                        ),
                                      ],
                                    )

                                  ],
                                ),
                              )
                            ],
                          ),

                          /* Positioned(
              top: constraints.maxHeight *0.02,

              child: Container(
                height: _height *0.25,
                width: _width *0.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black38,

                ),
                child: _authProvider.currentUser == null
                        ? GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/login_screen'),
                            child: Center(
                                child: Icon(
                              Icons.favorite_border,
                              size: 20,
                              color: Colors.white,
                            )),
                          )
                        : Consumer<FavouriteProvider>(
                            builder: (context, favouriteProvider, child) {
                            return GestureDetector(
                              onTap: () async {
                                if (favouriteProvider.favouriteAdsList
                                    .containsKey(widget.ad.adsId)) {
                                  favouriteProvider.removeFromFavouriteAdsList(
                                      widget.ad.adsId);
                                  await _apiProvider.get(Urls
                                          .REMOVE_AD_from_FAV_URL +
                                      "ads_id=${widget.ad.adsId}&user_id=${_authProvider.currentUser.userId}");
                                  if (widget.insideFavScreen) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FavouriteScreen()));
                                  }
                                } else {
                                  print(
                                      'user id ${_authProvider.currentUser.userId}');
                                  print('ad id ${widget.ad.adsId}');
                                  favouriteProvider.addToFavouriteAdsList(
                                      widget.ad.adsId, 1);
                                  await _apiProvider
                                      .post(Urls.ADD_AD_TO_FAV_URL, body: {
                                    "user_id": _authProvider.currentUser.userId,
                                    "ads_id": widget.ad.adsId
                                  });
                                }
                              },
                              child: Center(
                                child: favouriteProvider.favouriteAdsList
                                        .containsKey(widget.ad.adsId)
                                    ? SpinKitPumpingHeart(
                                        color: accentColor,
                                        size: 18,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                              ),
                            );
                          })

              ) ,
            )*/




                        ],
                      ),
                    );
                  })));
        });
  }
}
