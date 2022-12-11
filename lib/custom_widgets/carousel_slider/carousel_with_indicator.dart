// import 'package:carousel_slider/carousel_slider.dart';

// import 'package:flutter/material.dart';
// import 'package:riyadhmarket/models/img.dart';
// import 'package:riyadhmarket/utils/app_colors.dart';
// import 'package:riyadhmarket/utils/utils.dart';


// List<T> map<T>(List list, Function handler) {
//   List<T> result = [];
//   for (var i = 0; i < list.length; i++) {
//     result.add(handler(i, list[i]));
//   }

//   return result;
// }

// class CarouselWithIndicator extends StatefulWidget {
//   final List<Img> imgList;

//   const CarouselWithIndicator({ @required  this.imgList});
//   @override
//   _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
// }

// class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
//   int _current = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       CarouselSlider(
//         height: 180,
//           autoPlay: true,
//           viewportFraction: 1.0,
//           aspectRatio: MediaQuery.of(context).size.aspectRatio * 4.5,
//           items: map<Widget>(
//             widget.imgList,
//             (index, i) {
//               return Container(
              
//                 // margin: EdgeInsets.symmetric(vertical: 5),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.all(Radius.circular(0.0)),
//                   child: Container(
                    
//                       child: Image.network(
//                   Utils.BASE_URL + i.image,
//                     fit: BoxFit.cover,
//                     width: MediaQuery.of(context).size.width,
                    

//                   )),
//                 ),
//               );
//             },
//           ).toList(),
//           onPageChanged: (index) {
//             setState(() {
//               _current = index;
//             });
//           },
//         ),
    
//       Positioned(
//         bottom: 10,
//         left: MediaQuery.of(context).size.width * 0.45,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: map<Widget>(
//             widget.imgList,
//             (index, url) {
//               return Container(
          
//                 width: 8.0,
//                 height: 8.0,
//                 margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: _current == index ? cPrimaryColor : cWhite),
//               );
//             },
//           ),
//         ),
//       ),
//     ]);
//   }
// }
