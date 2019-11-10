// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:photobooth/src/data/blocs/pbd/bloc.dart';
import 'package:photobooth/src/data/blocs/ui/bloc.dart';
import 'package:photobooth/src/data/enums.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/data/services/local_save.dart';
import 'package:photobooth/src/data/services/php_services.dart';

class MockSharedPrefService extends Mock implements BaseSharedPrefService {}
class MockPHPService extends Mock implements BasePHPService {}

void main() {
  UIBloc uiBloc;
  PBDBloc pbdBloc;
  MockSharedPrefService sharedPrefService;
  setUp(() {
    uiBloc = UIBloc();
    pbdBloc = PBDBloc();
    sharedPrefService = MockSharedPrefService();
  });

  tearDown(() {
    uiBloc.close();
    pbdBloc.close();
  });

  // initialize blocs
  group('App Started', () {
    test('Init Blocs', () {
      expect(UIStateInit(), uiBloc.initialState);
      expect(PBDStateInit(), pbdBloc.initialState);
    });

    test('INIT UI ', () {
      final expectedResponse = [
        UIStateInit(),
        UIStateLoading(),
        UIStateLoaded(UINav.photoBooth, null, null),
      ];

      expectLater(
        uiBloc,
        emitsInOrder(expectedResponse),
      );
      uiBloc.add(UIEventInit());
    });


    test('PBDoc Initialize ', () {
      final expectedResponse = [PBDStateInit(),
        PBDStateLoading(), PBDStateLoaded(PBDObject(null, []), false, ColorSelect.red, false)
      ];

      when(sharedPrefService.initLoadSaved()).thenAnswer((_) => Future.value(false));


      expectLater(
        pbdBloc,
        emitsInOrder(expectedResponse),
        );

      pbdBloc.add(PBDEventInit());
    });
  });

  group('UI Functions', () {
    test('Change Navigation to Image Select  ', () {
      final expectedResponse = [
        UIStateInit(),
        UIStateLoading(),
        UIStateLoaded(UINav.imageSelect, null, null),
      ];
      expectLater(
        uiBloc,
        emitsInOrder(expectedResponse),
      );
      uiBloc.add(UIEventNav(UINav.imageSelect));
    });
  });

  test('Test PhotoBooth Trigger', () {
    final expectedResponse = [
      UIStateInit(),
      UIStateLoading(),
      UIStateLoaded(UINav.photoBooth, UIBoothTrigger.reset, null),
    ];
    expectLater(
      uiBloc,
      emitsInOrder(expectedResponse),
    );
    uiBloc.add(UIEventPhotoBoothTrigger(UIBoothTrigger.reset));
  });
  test('Test ImageSelect Trigger', () {
    final expectedResponse = [
      UIStateInit(),
      UIStateLoading(),
      UIStateLoaded(UINav.imageSelect, null, UIImageTrigger.camera),
    ];
    expectLater(
      uiBloc,
      emitsInOrder(expectedResponse),
    );
    uiBloc.add(UIEventImageSelectTrigger(UIImageTrigger.camera));
  });
}
