import 'package:flutter/material.dart';
import 'package:photobooth/src/data/blocs/ui/bloc.dart';
import 'package:photobooth/src/data/global_data.dart';

class ImageSelectorUI extends StatelessWidget {
  final UIBloc _uiBloc;
  final bool imageReady;
  ImageSelectorUI(this._uiBloc, this.imageReady);

  @override
  Widget build(BuildContext context) {
    final Function closeFunction =
        () => _uiBloc.add(UIEventNav(UINav.photoBooth));
    final Function saveFunction = imageReady
        ? () => _uiBloc.add(UIEventImageSelectTrigger(UIImageTrigger.save))
        : null;
    final Function editFunction = imageReady
        ? () => _uiBloc.add(UIEventImageSelectTrigger(UIImageTrigger.edit))
        : null;
    final Function galleryFunction =
        () => _uiBloc.add(UIEventImageSelectTrigger(UIImageTrigger.gallery));
    final Function cameraFunction =
        () => _uiBloc.add(UIEventImageSelectTrigger(UIImageTrigger.camera));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: appBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            iconButton(
                icon: iconClose, function: closeFunction, tooltip: btnClose),
            iconButton(icon: iconSave, function: saveFunction, tooltip: btnSave),
            iconButton(icon: iconEdit, function: editFunction, tooltip: btnEdit),
            iconButton(
                icon: iconGallery,
                function: galleryFunction,
                tooltip: btnGallery),
            iconButton(
                icon: iconCamera, function: cameraFunction, tooltip: btnCamera),
          ],
        ),
      ),
    );
  }
}
