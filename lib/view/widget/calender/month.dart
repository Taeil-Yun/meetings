import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room/model/calender_event.dart';
import 'package:meeting_room/view/calender_screen/calender_screen_controller.dart';
import 'package:meeting_room/view/widget/calender/month_widget.dart';
import 'package:provider/provider.dart';

class MonthViewPageDemo extends StatefulWidget {
  final CellTapCallback<CalenderEvent>? onCellTap;
  final TileTapCallback<CalenderEvent>? onEventTap;
  final String room;
  
  MonthViewPageDemo({
    Key? key,
    this.onCellTap,
    this.onEventTap,
    required this.room,
  });

  @override
  _MonthViewPageDemoState createState() => _MonthViewPageDemoState();
}

class _MonthViewPageDemoState extends State<MonthViewPageDemo> {
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
      body: MonthViewWidget(
        onCellTap: widget.onCellTap,
        onEventTap: widget.onEventTap,
        onPageChange: (date, e) async {
          final viewModel = context.read<CalenderScreenController>();
          await viewModel.getDataAboutRoom(roomNo: widget.room, selectedDate: date).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

}
