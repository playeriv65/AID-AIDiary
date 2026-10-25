import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/models/entry.dart';
import 'package:aid_diary/services/home_widget_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

Entry _entry(String text, DateTime time, {String title = ''}) =>
    Entry(title: title, text: text, timeCreate: time, timeModified: time);

void main() {
  final l10n = lookupAppLocalizations(const Locale('zh'));

  test('the widget shows the latest entry and the streak', () {
    final now = DateTime.now();
    final snapshot = HomeWidgetSnapshot.from([
      _entry('\n## 今天去了公园\n很开心', now),
      _entry('散步', now.subtract(const Duration(days: 1)), title: '昨天'),
    ], l10n);
    expect(snapshot.writtenDate, DateFormat('yyyy-MM-dd').format(now));
    expect(snapshot.snippet, '今天去了公园');
    expect(snapshot.streak, l10n.streakCurrent(2));
    expect(snapshot.toWidgetData()['widget_write'], l10n.widgetWrite);
  });

  test('a titled entry shows its title', () {
    final snapshot = HomeWidgetSnapshot.from(
        [_entry('散步', DateTime.now(), title: '昨天')], l10n);
    expect(snapshot.snippet, '昨天');
  });

  test('an empty diary leaves the date, snippet and streak blank', () {
    final snapshot = HomeWidgetSnapshot.from(const [], l10n);
    expect(snapshot.writtenDate, isEmpty);
    expect(snapshot.snippet, isEmpty);
    expect(snapshot.streak, isEmpty);
    expect(snapshot.pending, l10n.widgetPending);
  });

  test('first lines drop markdown marks', () {
    expect(HomeWidgetSnapshot.firstLine('- [ ] 买菜'), '[ ] 买菜');
    expect(HomeWidgetSnapshot.firstLine('> 引用\n正文'), '引用');
    expect(HomeWidgetSnapshot.firstLine('1. 第一条'), '第一条');
  });

  test('sealed capsules never contribute a widget snippet or streak', () {
    final now = DateTime.now();
    final sealed = Entry(
        text: 'private future text',
        timeCreate: now,
        timeModified: now,
        openAt: now.add(const Duration(days: 10)));
    final snapshot = HomeWidgetSnapshot.from([sealed], l10n);
    expect(snapshot.snippet, isEmpty);
    expect(snapshot.writtenDate, isEmpty);
    expect(snapshot.streak, isEmpty);
  });
}
