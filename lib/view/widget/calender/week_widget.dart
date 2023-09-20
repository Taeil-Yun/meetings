import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room/model/calender_event.dart';


class WeekViewWidget extends StatelessWidget {
  final GlobalKey<WeekViewState>? state;
  final double? width;
  final DateTime? selectedDay;
  final CellTapCallback<CalenderEvent>? onCellTap;
  final DateTapCallback? onDateTap;
  final CalendarPageChangeCallBack? onPageChange;

  const WeekViewWidget({
    Key? key,
    this.state,
    this.width,
    this.selectedDay,
    this.onCellTap,
    this.onDateTap,
    this.onPageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeekView<CalenderEvent>(
      key: state,
      width: width,
      initialDay: selectedDay,
      onEventTap: onCellTap,
      onDateTap: onDateTap,
      onPageChange: onPageChange,
    );
  }
}
