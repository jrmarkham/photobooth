import 'package:flutter/material.dart';
import 'package:photobooth/src/data/enums.dart';
import 'package:photobooth/src/data/models/pbd.dart';

//  the Final Display shows the data driven users contend once added to the data
//  since this set upon the completion this display
//  this displays renders after the gesture completes (finger up/ pan ended) which means there is a
//  delayed effect.
class FinalDisplay extends CustomPainter{
    List<Stroke> strokes;
    FinalDisplay(this.strokes);

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
  bool shouldRepaint(FinalDisplay finalDisplay) => finalDisplay.strokes != strokes;
}


// the live display show the current stroke as it is stroked the display closes once the drawn line is completed
class LiveDisplay extends CustomPainter{
    final List<Offset> offsetList;
    final ColorSelect cs;
    LiveDisplay(this.offsetList, this.cs);

    @override
    void paint(Canvas canvas, Size size) {
        // change to foreach
        final Paint paint = Paint()
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 5.0;
        // should do different colors here
        paint.color = getColor(cs);
        for(int i = 0; i < offsetList.length -1; i++){
            if(offsetList[i]!= null && offsetList[i+1]!= null){
                canvas.drawLine(offsetList[i], offsetList[i+1], paint);
            }
        }
    }

    @override
    bool shouldRepaint(LiveDisplay liveDisplay) => liveDisplay.offsetList!= offsetList;
}