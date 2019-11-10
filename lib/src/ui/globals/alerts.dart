
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photobooth/src/data/global_data.dart';
 // alert ui to save a new image file or a project //
 // alert ui w/ form elements to save file
 // generic alert
 // inform alert w/out dismiss option

Future<void> informAlert(
     BuildContext context, String title, String message) async {
     return showDialog<void>(
         context: context,
         barrierDismissible: true,
         builder: (BuildContext context) {
             if (Platform.isIOS) {
                 return CupertinoAlertDialog(
                     title: Text(
                         title,
                         style: labelTextStyle(),
                         ),
                     content: Text(
                         message,
                         style: bodyTextStyle(),
                         ),
                     actions: <Widget>[
                         FlatButton(
                             child: Text(
                                 btnOk,
                                 style: labelTextStyle(),
                                 ),
                             onPressed: () => Navigator.pop(context),
                             ),
                     ]);
             }

             return AlertDialog(
                 title: Text(
                     title,
                     style: labelTextStyle(),
                     textAlign: TextAlign.center,
                     ),
                 content: Text(
                     message,
                     style: bodyTextStyle(),
                     textAlign: TextAlign.left,
                     ),
                 actions: <Widget>[
                     FlatButton(
                         child: Text(
                             btnOk,
                             style: labelTextStyle(),
                             ),
                         onPressed: () => Navigator.pop(context),
                         )
                 ]);
         });
 }

Future<void> dialogContainer(BuildContext context, String title, Widget content,
                            {bool boolClose = true}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
            return AlertDialog(
                backgroundColor: colorWhite,
                title: Text(
                    title,
                    style: labelTextStyle(),
                    textAlign: TextAlign.center,
                    ),
                content: content,
                actions: boolClose
                         ? <Widget>[
                             FlatButton(
                                 child: Text(
                                     btnOk,
                                     style: labelTextStyle(),
                                     ),
                                 onPressed: () => Navigator.pop(context))
                         ]
                         : null);
        });
}

Future<void> fullScreenDialog(
    BuildContext context, String title, Widget widget) async {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: colorWhite,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
                      Animation<double> secondaryAnimation) {
            return Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Container(
                        alignment: Alignment.center,
                        child: Text(title, style: titleTextStyle()),
                        width: double.maxFinite,
                        color: colorBlue),
                    ),
                body: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.all(corePadding),
                        child: widget,
                        )));
        });
}
