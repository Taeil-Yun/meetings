import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room/model/calender_event.dart';
import 'package:meeting_room/view/calender_screen/calender_screen_controller.dart';
import 'package:meeting_room/view/widget/calender/week_widget.dart';
import 'package:provider/provider.dart';

class WeekViewDemo extends StatefulWidget {
  final DateTime? selectedDay;
  final CellTapCallback<CalenderEvent>? onCellTap;
  final DateTapCallback? onDateTap;
  final String room;

  const WeekViewDemo({Key? key, this.selectedDay, this.onCellTap, this.onDateTap, required this.room})
      : super(key: key);

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekViewDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        onPressed: () {
          context.push('/home/create_room', extra: {'room': widget.room});
        },
        child: const Icon(Icons.add),
        // onPressed: _addEvent,
      ),
      body: WeekViewWidget(
        selectedDay: widget.selectedDay,
        onCellTap: widget.onCellTap,
        onDateTap: widget.onDateTap,
        onPageChange: (date, e) async {
          final viewModel = context.read<CalenderScreenController>();
          await viewModel.getDataAboutRoom(roomNo: widget.room, selectedDate: date).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  // Future<void> _addEvent() async {
  //   final event =
  //   await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
  //     withDuration: true,
  //   ));
  //   if (event == null) return;
  //   CalendarControllerProvider.of<Event>(context).controller.add(event);
  // }
}
