import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room/model/calender_event.dart';

class MonthViewWidget extends StatelessWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;
  final CellTapCallback<CalenderEvent>? onCellTap;
  final TileTapCallback<CalenderEvent>? onEventTap;
  final CalendarPageChangeCallBack? onPageChange;

  const MonthViewWidget({
    Key? key,
    this.state,
    this.width,
    this.onCellTap,
    this.onEventTap,
    this.onPageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MonthView<CalenderEvent>(
      key: state,
      width: width,
      onCellTap: onCellTap,
      onEventTap: onEventTap,
      onPageChange: onPageChange,
    );
  }
}
