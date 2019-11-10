// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:photobooth/main.dart' as prefix0;
import 'package:photobooth/src/data/blocs/pbd/bloc.dart';
import 'package:photobooth/src/data/blocs/ui/bloc.dart';
import 'package:photobooth/src/data/enums.dart';
import 'package:photobooth/src/data/global_data.dart';
import 'package:photobooth/src/data/services/local_save.dart';
import 'package:photobooth/src/data/services/php_services.dart';
import 'package:photobooth/src/ui/app.dart';
import 'package:photobooth/src/ui/elements/image_ui.dart';

class MockSharedPrefService extends Mock implements BaseSharedPrefService {}
class MockPHPService extends Mock implements BasePHPService {}

void main() {
  UIBloc uiBloc;
  PBDBloc pbdBloc;
  MockSharedPrefService sharedPrefService;
  MockPHPService phpService;
  setUp(() {
    uiBloc = UIBloc();
    pbdBloc = PBDBloc();
    phpService = MockPHPService();
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

  });

  group('UI Functions', () {
    test('Navigation to Image Select', () {
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

  group('PBDocument BLoC and Services', () {
    test('PBDoc Reset', () {
      final expectedResponse = [
        PBDStateInit(),
        PBDStateLoading(),
        PBDStateLoaded(PBDObject(null, []), false, false, ColorSelect.red)
      ];

      expectLater(
        pbdBloc,
        emitsInOrder(expectedResponse),
      );

      pbdBloc.add(PBDEventReset());
    });

    test('PHPService PostBPD', () async{
      final String file = 'file';
      final String dir = 'directory';
      final PBDObject pbdObject = PBDObject(null, []);
      final int backs = 4;
      when(phpService.postPBD(file,dir, pbdObject, backs)).thenAnswer((_)=>Future.value(true));
      expectLater(true, await phpService.postPBD(file,dir, pbdObject, backs));

    });
    test('PHPService PostImage', ()async{
      final String base64 = 'base64';
      final String file = 'file';
      final String dir = 'directory';

      when(phpService.postImageBase64(base64, file,dir)).thenAnswer((_)=>Future.value(true));
      expectLater(true, await phpService.postImageBase64(base64, file,dir));

    });

    test('SharedPrefService initLoadSaved',()async{
      when(sharedPrefService.initLoadSaved()).thenAnswer((_)=>Future.value(true));
      expect(true, await sharedPrefService.initLoadSaved());
    });

    test('SharedPrefService savePBDObject',()async{
      final PBDObject pbdObject = PBDObject(null, []);
      final int backs = 4;
      when(sharedPrefService.savePBDObject(pbdObject, backs)).thenAnswer((_)=>Future.value(true));
      expect(true, await sharedPrefService.savePBDObject(pbdObject, backs));

    });

    test('SharedPrefService getPBDObject',()async{

      when(sharedPrefService.getPBDObject()).thenAnswer((_)=>Future.value(PBDObject(null, [])));
      expect(PBDObject(null, []), await sharedPrefService.getPBDObject());

    });

    test('SharedPrefService getBacks',()async{
      when(sharedPrefService.getBacks()).thenAnswer((_)=>Future.value(4));
      expect(4, await sharedPrefService.getBacks());
    });
  });

}
