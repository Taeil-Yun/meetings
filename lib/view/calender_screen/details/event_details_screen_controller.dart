import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room/common/util/toast.dart';
import 'package:meeting_room/main.dart';
import 'package:meeting_room/model/calender_event.dart';
import 'package:meeting_room/view_model/firebase/room/fix_room.dart';

class EventDetailsScreenController extends ChangeNotifier {
  CalendarEventData? event;
  String firestoreRoot = '';

  bool isFixe = false;

  final formKey = GlobalKey<FormState>();

  Future<void> eventInit(CalendarEventData data) async {
    CalenderEvent calenderEventTitle = data.event as CalenderEvent;
    firestoreRoot = calenderEventTitle.title;
    event = data;
    notifyListeners();
  }

  Future<void> setInit() async {
    _getSelectedDate(date: event!.date, startDate: event!.startTime, endDate: event!.endTime);
    title.text = event?.title ?? '';
    onDate.text = DateFormat('yyyy년 M월 d일').format(event!.date!);
    startTime.text = '${event!.startTime!.hour == 0 ? '오전 12시' : '${event!.startTime!.hour}시'} ${event!.startTime!.minute != 0 ? '${event!.startTime!.minute}분' : ''}';
    endTime.text = '${event!.endTime!.hour == 0 ? '오전 12시' : '${event!.endTime!.hour}시'} ${event!.endTime!.minute != 0 ? '${event!.endTime!.minute}분' : ''}';
    _eventGraphColor = event!.color;

    notifyListeners();
  }


  get onYear => _onYear;
  String _onYear = '';

  get onMonth => _onMonth;
  String _onMonth = '';

  get onDay => _onDay;
  String _onDay = '';

  get onStartHour => _onStartHour;
  String _onStartHour = '';

  get onStartMinute => _onStartMinute;
  String _onStartMinute = '';

  get onEndHour => _onEndHour;
  String _onEndHour = '';

  get onEndMinute => _onEndMinute;
  String _onEndMinute = '';

  get eventGraphColor => _eventGraphColor;
  Color _eventGraphColor = Colors.blue;

  TextStyle fieldStyle = const TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);
  BorderRadius fieldRadius = BorderRadius.circular(8.0);

  TextEditingController title = TextEditingController();
  TextEditingController participants = TextEditingController();
  TextEditingController onDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  // EventDetailsScreenController({DateTime? selectedDate}) {
  //   if (selectedDate != null) {
  //     _getSelectedDate(selectedDate);
  //   }
  // }

  Future<void> _getSelectedDate({DateTime? date, DateTime? startDate, DateTime? endDate}) async {
    _onYear = date!.year.toString();
    _onMonth = date.month.toString();
    _onDay = date.day.toString();
    _onStartHour = date.hour.toString();
    _onStartMinute = date.minute.toString();

    _onEndHour = endDate!.hour.toString();
    _onEndMinute = endDate.minute.toString();

    onDate.text = DateFormat('yyyy년 M월 d일').format(DateTime(date.year, date.month, date.day));
    startTime.text = '${date.hour == 0 ? '오전 12시' : '${date.hour}시'} ${date.minute != 0 ? '${date.minute}분' : ''}';

    notifyListeners();
  }

  void getOnDate(int year, int month, int day) async {
    _onYear = year.toString();
    _onMonth = month.toString();
    _onDay = day.toString();

    notifyListeners();
  }

  void getOnStartTime(int hour, int minute) {
    _onStartHour = hour.toString();
    _onStartMinute = minute.toString();

    notifyListeners();
  }

  void getOnEndTime(int hour, int minute) {
    _onEndHour = hour.toString();
    _onEndMinute = minute.toString();

    notifyListeners();
  }

  void changeEventGraphColor(Color color) {
    _eventGraphColor = color;

    notifyListeners();
  }

  double dateFieldMaxWidth(BuildContext context) {
    return (MediaQuery.of(context).size.width - 48.0) / 2;
  }

  Future<bool> sendRoomData(BuildContext context, {
    required String room,
    required String title,
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    required int endHour,
    required int endMinute,
    List<String>? participants,
  }) async {
    DateTime createDate = DateTime.now();
    String? getUserName = await secureStorage.read(key: 'name');
    DateTime mergeDate = DateTime(year, month, day, hour, minute);
    DateTime mergeEndDate = DateTime(year, month, day, endHour, endMinute);

    try {
      if (mergeDate.millisecondsSinceEpoch < mergeEndDate.millisecondsSinceEpoch) {
        FixRoomAPI().checkAvaliableDate(room: room, eventId: (event!.event as CalenderEvent).title.split('/').last, onYear: onYear, onMonth: onMonth, startTime: mergeDate, endTime: mergeEndDate).then((value) {
          if (value) {
            FixRoomAPI().fixRoomData(
              room: room,
              eventId: (event!.event as CalenderEvent).title.split('/').last,
              createDate: createDate,
              title: title,
              author: getUserName!,
              onDate: mergeDate.millisecondsSinceEpoch,
              startTime: mergeDate,
              endTime: mergeEndDate,
              onYear: year.toString(),
              onMonth: month.toString(),
              participants: participants,
              graphColor: eventGraphColor.value.toRadixString(16).padLeft(8, '0'),
            );

            // ignore: use_build_context_synchronously
            showNormalToast(context: context, text: '회의실 예약이 완료되었습니다');
            context.pop();
            context.pop();
          } else {
            // ignore: use_build_context_synchronously
            showNegativeToast(context: context, text: '시작 시각에 회의실 예약이 존재합니다');
          }
        });

        return true;
      } else {
        // ignore: use_build_context_synchronously
        showNegativeToast(context: context, text: '종료 시각이 시작 시각보다 빠릅니다');

        return false;
      }
    } catch (e) {
      log('$e');

      // ignore: use_build_context_synchronously
      showNegativeToast(context: context, text: '오류가 발생했습니다');

      return false;
    }
  }
}