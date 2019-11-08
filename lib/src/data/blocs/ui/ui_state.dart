import 'package:equatable/equatable.dart';
import 'package:photobooth/src/data/global_data.dart';

abstract class UIState extends Equatable {
  const UIState();
}

class UIStateInit extends UIState {
  @override
  List<Object> get props => [];
}


class UIStateLoading extends UIState {
  @override
  List<Object> get props => [];
}

// NAV Changes
class UIStateLoaded extends UIState {
  final UINav uiNav;
  final UIBoothTrigger boothTrigger;
  final UIImageTrigger imageTrigger;
  UIStateLoaded(this.uiNav, this.boothTrigger, this.imageTrigger);

  @override
  List<Object> get props => [uiNav, boothTrigger, imageTrigger];
}
