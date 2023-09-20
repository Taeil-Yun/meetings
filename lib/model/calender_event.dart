import 'package:flutter/foundation.dart';

@immutable
class CalenderEvent {
  final String title;

  const CalenderEvent({this.title = "Title"});

  @override
  bool operator ==(Object other) =>
      other is CalenderEvent && title == other.title;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => title;
}
