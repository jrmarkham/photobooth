import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photobooth/src/data/blocs/pbd/bloc.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/data/models/pbd.dart';
import 'package:photobooth/src/ui/elements/doodle.dart';

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

  Widget drawContainer(PBDObject pbdObject) {
    List<Offset> _points = <Offset>[];
    return Container(
      width: deviceWidth * 0.85,
      height: deviceHeight * 0.7,
      decoration: appBorder(),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          RenderBox object = context.findRenderObject();
          Offset _localPosition = object.globalToLocal(details.globalPosition);
          _points = List.from(_points)..add(_localPosition);
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          _pbdBloc.add(PBDEventAddStroke(_points));
          _points = <Offset>[];
        },
        child: Container(
          child: CustomPaint(
            willChange: true,
            painter: Doodle(pbdObject.strokes),
            size: Size(deviceWidth * 0.8, deviceHeight * 0.7),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _pbdBloc,
        builder: (BuildContext context, PBDState state) {
          if (state is PBDStateLoaded) {
            // PHOTO BOOTH DISPLAY DRAWING TOOLS
            return Column(
              children: <Widget>[
                Text(
                  'Photo Booth UI ${state.pbdObject.strokes.length}',
                  style: bodyTextStyle(),
                ),
                SizedBox(height: 8.0),

                RepaintBoundary(
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
                          drawContainer(state.pbdObject),
                        ],
                      ),
                      state.pbdObject.strokes.length + 1),
                )
              ],
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
                SizedBox(height: 8.0),
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
