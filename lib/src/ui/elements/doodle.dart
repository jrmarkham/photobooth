import 'package:flutter/material.dart';
import 'package:photobooth/src/data/enums.dart';
import 'package:photobooth/src/data/models/pbd.dart';


class Doodle extends CustomPainter{
    List<Stroke> strokes;
    Doodle(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
      // change to foreach
      final Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

      strokes.forEach((element){
          // should do different colors here
          final List<Offset> offsetList = element.offsets;
          paint.color = getColor(element.color);
          for(int i = 0; i < offsetList.length -1; i++){
              if(offsetList[i]!= null && offsetList[i+1]!= null){
                  canvas.drawLine(offsetList[i], offsetList[i+1], paint);
              }
          }
      });
  }

  @override
  bool shouldRepaint(Doodle oldDoodle) => oldDoodle.strokes != strokes;



}

