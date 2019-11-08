import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobooth/src/data/blocs/pbd/bloc.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/ui/app.dart';
import 'package:photobooth/src/data/blocs/ui/bloc.dart';

void main() {
  // load user setting from cache
  // load app data from json data [file]
  // content data will be hard code for this project

  GlobalData.initGlobalData().then((_) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(
          MaterialApp(
              debugShowCheckedModeBanner: false,
              title: title,
              theme: appTheme(),

              // load up the bloc from the start //
              home: MultiBlocProvider(
                  providers: [
                    BlocProvider<UIBloc>(builder: (BuildContext context) => UIBloc()),
                    BlocProvider<PBDBloc>(
                        builder: (BuildContext context) =>PBDBloc()),
                      BlocProvider<UIBloc>(builder: (BuildContext context) => UIBloc()),
                  ],child:App())));
    });
  });
}