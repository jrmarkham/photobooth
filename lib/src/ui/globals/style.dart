import 'package:flutter/material.dart';
import 'package:photobooth/src/data/enums.dart';

const String MAIN_FONT = 'Roboto';
// CONSTs
// COLORS
const Color colorBlue = Colors.blue;
const Color colorLightGray = Colors.grey;
const Color colorLightestGray = Colors.white60;
const Color colorGray = Colors.black45;
const Color colorWhite = Colors.white;
const Color colorBlack = Colors.black;
//

const double CONTENT_HEIGHT_PERCENTAGE = 0.8;
const double INDICATOR_SIZE_PERCENTAGE = 0.85;
const double INDICATOR_STROKE_SIZE = 10.0; // maybe increate by size
const double LARGE_ICON_FACTOR = 2.0;
//final Color ColorGREEN = const Color(0x00CC00);
//
// Icon and Icon Button Settings
const Color iconColor = colorBlue;
const Color selectedColor = colorLightGray;
double iconSize;

// TEXT SIZES
double titleTextSize;
double labelTextSize;
double bodyTextSize;

// SPACINGS
double corePadding;
double coreButtonSpacing;
double tinySpacing;

//
// SetDevice
double deviceWidth;
double deviceHeight;
double borderRadius = 25.0;

void setDeviceDimensions(double w, double h) {
    deviceWidth = w;
    deviceHeight = h;
    // set values
    if (deviceWidth > 900) {
        iconSize = 50.0;
        corePadding = 15.0;
        coreButtonSpacing = 15.0;
        tinySpacing = 5.0;
        // text


        titleTextSize = 36.0;
        labelTextSize = 26.0;
        bodyTextSize = 24.0;
    } else if (deviceWidth > 750) {
        iconSize = 43.0;
        corePadding = 20.0;
        coreButtonSpacing = 15.0;
        tinySpacing = 4.0;

        // text

        titleTextSize = 34.0;
        labelTextSize = 24.0;
        bodyTextSize = 22.0;
    } else if (deviceWidth > 550) {
        iconSize = 40.0;
        corePadding = 15.0;
        coreButtonSpacing = 12.0;
        tinySpacing = 5.0;

        titleTextSize = 32.0;
        labelTextSize = 22.0;
        bodyTextSize = 20.0;
    } else if (deviceWidth > 400) {
        iconSize = 35.0;
        corePadding = 12.0;
        coreButtonSpacing = 10.0;
        tinySpacing = 3.0;
        // text
        titleTextSize = 28.0;
        labelTextSize = 18.0;
        bodyTextSize = 17.0;
    } else {
        iconSize = 25.0;
        corePadding = 10.0;
        coreButtonSpacing = 5.0;
        tinySpacing = 2.0;

        // text

        titleTextSize = 26.0;
        labelTextSize = 16.0;
        bodyTextSize = 15.0;
    }
}

// TEXT STYLES

TextStyle titleTextStyle() {
    return TextStyle (
        color: colorWhite, fontSize:titleTextSize, fontWeight: FontWeight.bold, fontFamily: MAIN_FONT
        );
}

TextStyle labelTextStyle() {
    return TextStyle (
        color: colorBlue, fontSize:bodyTextSize, fontWeight: FontWeight.bold, fontFamily: MAIN_FONT
        );
}

TextStyle bodyTextStyle() {
    return TextStyle(
        color: colorBlue, fontSize: bodyTextSize, fontFamily: MAIN_FONT);
}// TEXT STYLES


TextStyle buttonTextStyle() {
    return TextStyle(
        color: colorWhite, fontSize: bodyTextSize, fontWeight: FontWeight.bold, fontFamily: MAIN_FONT);
}// TEXT STYLES


// THEMES
AppBarTheme appBarTheme() {
    return AppBarTheme(
        textTheme: TextTheme(
            title: titleTextStyle(),
            ),
        );
}

TextTheme genTextTheme() {
    return TextTheme(
        title: titleTextStyle(),
        body1: bodyTextStyle(),
        );
}

ThemeData appTheme() {
    return ThemeData(
        primaryColor: colorBlue,
        canvasColor: colorWhite,
        appBarTheme: appBarTheme(),
        backgroundColor: colorWhite,
        scaffoldBackgroundColor: colorWhite,
        textTheme: genTextTheme(),
        unselectedWidgetColor:colorLightestGray,
        dialogBackgroundColor: colorWhite,
        fontFamily: MAIN_FONT);
}

Widget iconButton(
    {@required IconData icon,
        @required Function function,
        @required String tooltip}) {
    return GestureDetector(
        child: Tooltip(
            message: tooltip,
            preferBelow: false,
            child: Icon(icon,
                            size: iconSize,
                            color: function !=null  ?colorBlue: colorGray)),
        onTap: function);
}

Widget appLoading() {
    return Center(
        child: SizedBox(
            width: deviceWidth * INDICATOR_SIZE_PERCENTAGE,
            height: deviceWidth * INDICATOR_SIZE_PERCENTAGE,
            child: CircularProgressIndicator(
                backgroundColor: colorBlue,
                strokeWidth: INDICATOR_STROKE_SIZE,
                ),
            ),
        );
}

BoxDecoration appBorder(){
    return BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
    border: Border.all(
    width: 2,
    color: colorBlue,
    style: BorderStyle.solid));
}

BoxDecoration menuItemDecor(ColorSelect _color){
    return BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        color: getColor(_color),
        border: Border.all(
            width: 1,
            color: colorBlack,
            style: BorderStyle.solid));
}


Widget appTextField(
    {@required TextEditingController con,
        @required int maxLen,
        @required int maxLines,
        @required label,
        TextInputType input}) {
    return TextFormField(
        keyboardType: input == null ? TextInputType.text : input,
        controller: con,
        maxLengthEnforced: true,
        maxLength: maxLen,
        maxLines: maxLines,
        textAlign: TextAlign.left,
        style: bodyTextStyle(),


        decoration:
        InputDecoration(labelText: label, labelStyle: bodyTextStyle(), helperStyle:bodyTextStyle(), focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorBlue))),
        );
}


Widget appButton(String label, Function function) {
    double buttonSize = deviceWidth *0.4;
    // bool active = function != null;

    return Container(
        width: buttonSize,
        height: buttonSize * .2,
        decoration: BoxDecoration(
            color: function!= null ? colorBlue :  colorGray,
            borderRadius: BorderRadius.circular(40.0)),
        child: FlatButton(
            child: Center(child: Text(label, style: buttonTextStyle())),
            onPressed: function,
            ));

}