import 'package:aid_diary/actions/app_action.dart';
import 'package:aid_diary/pages/drawing_page.dart';
import 'package:aid_diary/routing/destination.dart';
import 'package:material_ui/material_ui.dart';

class DrawingNavigation {
  static Future<String?> open(BuildContext context, {int? entryId}) =>
      Navigator.of(context).push<String>(MaterialPageRoute<String>(
        settings: routeFor('drawing', entryId),
        builder: (_) => DrawingPage(entryId: entryId),
      ));
}

final drawingDestinations = [
  Destination('drawing', 'Draw with a finger, mouse or pen',
      (context, args) async {
    await DrawingNavigation.open(context, entryId: intArg(args, 'id'));
  }, params: [
    ActionParam('id', ParamType.integer, 'Entry to attach the drawing to'),
  ]),
];
