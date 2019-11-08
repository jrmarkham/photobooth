import 'package:flutter/material.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/ui/globals/style.dart';

class ColorDropdown extends StatefulWidget {
  final ColorSelect _currentColor;
  final Function updateColorFunction;
  ColorDropdown(this._currentColor, this.updateColorFunction);

  @override
  _ColorDropdownState createState() => _ColorDropdownState();
}

class _ColorDropdownState extends State<ColorDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<ColorSelect>(
          value: widget._currentColor,
          onChanged: (ColorSelect val) {
            widget.updateColorFunction(val);
          },
          items: ColorSelect.values.map((ColorSelect color) {
            return DropdownMenuItem<ColorSelect>(
              value: color,
              child: Container(
                width: deviceWidth * 0.1,
                height: 15.0,
                decoration: menuItemDecor(color),
              ),
            );
          }).toList()),
    );
  }
}
