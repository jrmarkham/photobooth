import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photobooth/src/data/global_data.dart';

class SaveFormPage extends StatefulWidget {
  final Function saveImage;
  final Function savePBD;

  SaveFormPage(this.saveImage, this.savePBD);

  @override
  _SaveFormPageState createState() => _SaveFormPageState();
}

class _SaveFormPageState extends State<SaveFormPage> {
  TextEditingController nameCon;
  TextEditingController dirCon;

  @override
  void initState() {
    super.initState();
    nameCon = TextEditingController();
    dirCon = TextEditingController();
  }

  void submit(BuildContext context, Function function) {
    String name = 'file';
    String dir = 'directory';

    //input remove spaces
    if (nameCon.text.isNotEmpty) {
      name = nameCon.text.trim();
      name = name.split(" ").join("_");
    }
    if (dirCon.text.isNotEmpty) {
      dir = dirCon.text.trim();
      dir = dir.split(" ").join("_");
    }

    function(name, dir);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Function closeFunction = () => Navigator.pop(context);
    final Function saveImageFunction = () => submit(context, widget.saveImage);
    final Function savePBDFunction = () => submit(context, widget.savePBD);
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              saveText,
              style: bodyTextStyle(),
            ),
            appTextField(
                con: nameCon, maxLen: 10, maxLines: 1, label: 'File Name'),
            appTextField(
                con: dirCon, maxLen: 10, maxLines: 1, label: 'Directory'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                appButton(saveImage, saveImageFunction),
                appButton(savePBD, savePBDFunction),
              ],
            ),
            SizedBox(height: corePadding),
            appButton(btnCancel, closeFunction),
          ],
        ),
    );
  }
}
