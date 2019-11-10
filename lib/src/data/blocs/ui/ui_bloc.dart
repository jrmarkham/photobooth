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
  @override
  Stream<UIState> mapEventToState(
    UIEvent event,
  ) async* {
    if (event is UIEventInit) {
      yield UIStateLoading();
      // no triggers
      yield UIStateLoaded(UINav.photoBooth, null, null);
    }
    // change navigation //

    if (event is UIEventNav) {
      // could be a toggle or set nav //
      yield UIStateLoading();
      // no triggers
      yield UIStateLoaded(event.uiNav, null, null);
    }

    if (event is UIEventPhotoBoothTrigger) {
      // could be a toggle or set nav //
      yield UIStateLoading();
      // booth  triggers
      yield UIStateLoaded(UINav.photoBooth, event.boothTrigger, null);
    }

    if (event is UIEventImageSelectTrigger) {
      // could be a toggle or set nav //
      yield UIStateLoading();
      // image trigger
      yield UIStateLoaded(UINav.imageSelect, null,  event.imageSelectTrigger);
    }


  }
}
