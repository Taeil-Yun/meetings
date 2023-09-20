import 'package:calendar_view/calendar_view.dart';
import 'package:meeting_room/model/calender_event.dart';

DateTime get _now => DateTime.now();

List<CalendarEventData<CalenderEvent>> events = [
  CalendarEventData(
    date: _now,
    // event: CalenderEvent(title: "Joe's Birthday"),
    title: "Project meeting",
    description: "Today is project meeting.",
    startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 22),
    author: '정지창',
    participants: [],
    // 저자 author
    // 참여자 participants
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 1)),
    startTime: DateTime(_now.year, _now.month, _now.day, 18),
    endTime: DateTime(_now.year, _now.month, _now.day, 19),
    event: CalenderEvent(title: "Wedding anniversary"),
    title: "Wedding anniversary",
    description: "Attend uncle's wedding anniversary.",
    author: '정지창1',
    participants: [],
  ),
  CalendarEventData(
    date: _now,
    startTime: DateTime(_now.year, _now.month, _now.day, 14),
    endTime: DateTime(_now.year, _now.month, _now.day, 14, 20),
    event: CalenderEvent(title: "Football Tournament"),
    title: "Football Tournament",
    description: "Go to football tournament.",
    author: '정지창2',
    participants: [],
  ),
  CalendarEventData(
    date: _now,
    startTime: DateTime(_now.year, _now.month, _now.day, 14, 20),
    endTime: DateTime(_now.year, _now.month, _now.day, 14, 30),
    event: CalenderEvent(title: "Football Tournament2"),
    title: "Football Tournament",
    description: "Go to football tournament.",
    author: '정지창2',
    participants: [],
  ),
  CalendarEventData(
    date: _now,
    startTime: DateTime(_now.year, _now.month, _now.day, 14, 30),
    endTime: DateTime(_now.year, _now.month, _now.day, 17),
    event: CalenderEvent(title: "Football Tournament3"),
    title: "Football Tournament",
    description: "Go to football tournament.",
    author: '정지창2',
    participants: [],
  ),
  CalendarEventData(
    date: _now.add(Duration(days: 3)),
    startTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 10),
    endTime: DateTime(_now.add(Duration(days: 3)).year,
        _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 14),
    event: CalenderEvent(title: "Sprint Meeting."),
    title: "Sprint Meeting.",
    description: "Last day of project submission for last year.",
    author: '정지창3',
    participants: [],
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        14),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        16),
    event: CalenderEvent(title: "Team Meeting"),
    title: "Team Meeting",
    description: "Team Meeting",
    author: '정지창4',
    participants: [],
  ),
  CalendarEventData(
    date: _now.subtract(Duration(days: 2)),
    startTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        10),
    endTime: DateTime(
        _now.subtract(Duration(days: 2)).year,
        _now.subtract(Duration(days: 2)).month,
        _now.subtract(Duration(days: 2)).day,
        12),
    event: CalenderEvent(title: "Chemistry Viva"),
    title: "Chemistry Viva",
    description: "Today is Joe's birthday.",
    author: '정지창5',
    participants: [],
  ),
];
