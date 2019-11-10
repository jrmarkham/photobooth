import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobooth/src/data/blocs/pbd/bloc.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/ui/elements/draw/scribbler.dart';

class PBDStage extends StatefulWidget {
  final GlobalKey globalKey;
  PBDStage(this.globalKey);

  @override
  _PBDStageState createState() => _PBDStageState();
}

class _PBDStageState extends State<PBDStage> {
  PBDBloc _pbdBloc;

  @override
  void initState() {
    super.initState();
    _pbdBloc = BlocProvider.of<PBDBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _pbdBloc,
        builder: (BuildContext context, PBDState state) {
          if (state is PBDStateLoaded) {
            // PHOTO BOOTH DISPLAY DRAWING TOOLS
            return RepaintBoundary(
              key: widget.globalKey,
              child: RepaintBoundary.wrap(
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      // back ground image
                      if (state.pbdObject.image != null) ...[
                        Image.file(
                          state.pbdObject.image,
                          height: deviceHeight * 0.7,
                          width: deviceWidth * 0.85,
                        ),
                      ],
                      // draw stuff container
                      Scribbler(state.pbdObject, state.curColor, _pbdBloc)
                    ],
                  ),
                  state.pbdObject.strokes.length + 1),
            );
          }

          if (state is PBDStateImageLoad) {
            // just an image
            return Column(
              children: <Widget>[
                Text(
                  'Select/Edit/Update an Image for the photo booth',
                  style: bodyTextStyle(),
                ),
                if (state.imageFile != null) ...[
                  Image.file(
                    state.imageFile,
                    height: deviceHeight * 0.7,
                    width: deviceWidth * 0.8,
                  ),
                ],
              ],
            );
          }
          return appLoading();
        });
  }
}
