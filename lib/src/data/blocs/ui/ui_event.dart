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
  final UIBoothTrigger trigger;
  UIEventPhotoBoothTrigger(this.trigger);

  @override
  List<Object> get props => [trigger];
}

class UIEventImageSelectTrigger extends UIEvent{
  final UIImageTrigger trigger;
  UIEventImageSelectTrigger(this.trigger);

  @override
  List<Object> get props => [trigger];
}
