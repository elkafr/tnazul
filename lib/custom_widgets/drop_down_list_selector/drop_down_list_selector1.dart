import 'package:flutter/material.dart';
import 'package:tnazul/utils/app_colors.dart';




class DropDownListSelector1 extends StatefulWidget {
  final List<dynamic> dropDownList;
  final String hint;
  final dynamic value;
  final num marg;
  final Function onChangeFunc;



  const DropDownListSelector1(
      {Key key,
      this.dropDownList,
      this.hint,
      this.value,
      this.marg,
      this.onChangeFunc,
     
     })
      : super(key: key);
  @override
  _DropDownListSelector1State createState() => _DropDownListSelector1State();
}

class _DropDownListSelector1State extends State<DropDownListSelector1> {
  @override
  Widget build(BuildContext context) {
    
      return Container(

        height: 35,
        width: 125,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),

        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: mainAppColor),
          color: Colors.white,

        ),
        child: 
       DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            isExpanded: true,
            hint: Padding(
              padding: EdgeInsets.only(right: 5),
              child: Text(
       widget.hint,
       style: TextStyle(
           color: Colors.black,
           fontSize: 12,
           fontWeight: FontWeight.w400,
           fontFamily: 'Cairo'),
              ),
            ),
            focusColor: mainAppColor,
            icon:Icon(
                   Icons.keyboard_arrow_down,
                   size: 20,
                   color: hintColor,
                 ),
            style: TextStyle(
         fontSize: 14,
         color: Colors.black,
         fontWeight: FontWeight.w400,
         fontFamily: 'Cairo'),
            items: widget.dropDownList,
            onChanged: widget.onChangeFunc,
            value: widget.value,
          ),
    ));

  }
}
