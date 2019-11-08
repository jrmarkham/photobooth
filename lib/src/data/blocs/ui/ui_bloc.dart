import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:photobooth/src/data/global_data.dart';
import './bloc.dart';

/*
    UIBloc for all ui events .
    These will trigger state change
    that will update with navigation and triggers

 */


class UIBloc extends Bloc<UIEvent, UIState> {
  @override
  UIState get initialState => UIStateInit();
  UINav _uiNav;
  UIBoothTrigger _boothTrigger;
  UIImageTrigger _imageTrigger;
  @override
  Stream<UIState> mapEventToState(
    UIEvent event,
  ) async* {
    if (event is UIEventInit) {
      yield UIStateLoading();
      _uiNav = UINav.photoBooth;
      // no triggers
      _boothTrigger = null;
      _imageTrigger = null;
      yield UIStateLoaded(_uiNav, _boothTrigger, _imageTrigger);
    }
    // change navigation //

    if (event is UIEventNav) {
      // could be a toggle or set nav //
      yield UIStateLoading();
      _uiNav = event.uiNav;
      // no triggers
      _boothTrigger = null;
      _imageTrigger = null;
      yield UIStateLoaded(_uiNav, _boothTrigger, _imageTrigger);
    }

    if (event is UIEventPhotoBoothTrigger) {
      // could be a toggle or set nav //
      yield UIStateLoading();
      // no triggers
      _boothTrigger = event.trigger;
      _imageTrigger = null;
      yield UIStateLoaded(_uiNav, _boothTrigger, _imageTrigger);
    }

    if (event is UIEventImageSelectTrigger) {
      // could be a toggle or set nav //
      yield UIStateLoading();
      // no triggers
      _boothTrigger = null;
      _imageTrigger = event.trigger;
      yield UIStateLoaded(_uiNav, _boothTrigger, _imageTrigger);
    }


  }
}
