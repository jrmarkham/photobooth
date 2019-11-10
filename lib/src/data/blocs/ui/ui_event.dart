import 'package:equatable/equatable.dart';
import 'package:photobooth/src/data/enums.dart';

abstract class UIEvent extends Equatable {
  const UIEvent();
}


// INIT MAIN UI VARS
class UIEventInit extends UIEvent{
  @override
  List<Object> get props => [];
}

class UIEventNav extends UIEvent{
  final UINav uiNav;
  UIEventNav(this.uiNav);

  @override
  List<Object> get props => [uiNav];
}

class UIEventPhotoBoothTrigger extends UIEvent{
  final UIBoothTrigger boothTrigger;
  UIEventPhotoBoothTrigger(this.boothTrigger);

  @override
  List<Object> get props => [boothTrigger];
}

class UIEventImageSelectTrigger extends UIEvent{
  final UIImageTrigger imageSelectTrigger;
  UIEventImageSelectTrigger(this.imageSelectTrigger);

  @override
  List<Object> get props => [imageSelectTrigger];
}
