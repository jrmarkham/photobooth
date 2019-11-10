import 'package:flutter/material.dart';
import 'package:photobooth/src/data/blocs/pbd/bloc.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/ui/elements/draw/doodle.dart';

class Scribbler extends StatefulWidget {
  final PBDObject pbdObject;
  final ColorSelect colorSelect;
  final PBDBloc _pbdBloc;

  Scribbler(this.pbdObject, this.colorSelect, this._pbdBloc);

  @override
  _ScribblerState createState() => _ScribblerState();
}

class _ScribblerState extends State<Scribbler> {
  List<Offset> _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        child: CustomPaint(
            willChange: true,
            painter: FinalDisplay(widget.pbdObject.strokes),
            size: Size(deviceWidth * 0.85, deviceHeight * 0.7)),
      ),
      Container(
        height: deviceHeight * 0.7,
        width: deviceWidth * 0.85,
        //color: Colors.cyan,
        decoration: appBorder(),
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox object = context.findRenderObject();
              Offset _localPosition =
                  object.globalToLocal(details.globalPosition);
              _points = List.from(_points)..add(_localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) {
            _points.add(null);
            widget._pbdBloc.add(PBDEventAddStroke(_points));
            _points = <Offset>[];
          },
          child: Container(
            child: CustomPaint(
                willChange: true,
                painter: LiveDisplay(_points, widget.colorSelect),
                size: Size(deviceWidth * 0.85, deviceHeight * 0.7)),
          ),
        ),
      ),
    ]);
  }
}
