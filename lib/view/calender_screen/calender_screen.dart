import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room/view/calender_screen/calender_screen_controller.dart';
import 'package:meeting_room/view/widget/calender/month.dart';
import 'package:provider/provider.dart';

class CalenderScreen extends StatefulWidget {
  final String room;
  const CalenderScreen({super.key, required this.room});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final PageController pageController = PageController(
    initialPage: 0,
  );
  int currentIndex = 0;

  bool isCalender = true;
  bool dataLoaded = false;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewModel = context.read<CalenderScreenController>();
      viewModel.getDataAboutRoom(roomNo: widget.room, selectedDate: DateTime.now()).then((value) {
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.read<CalenderScreenController>().removeListenerDb().then((value) {
                context.pop();
              });
            },
            icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(widget.room),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: MonthViewPageDemo(
              room: widget.room,
              onCellTap: (event, date) {
                context.push("/home/calender/weekly", extra: {"room" : widget.room, "date" : date});
              },
              onEventTap: (event, date) {
                context.push("/home/calender/weekly", extra: {"room" : widget.room, "date" : date});
              },
            ),
          ),
          // Expanded(
          //   child: currentIndex == 2
          //       ? const DayViewPageDemo()
          //       : currentIndex == 1
          //           ? const WeekViewDemo()
          //           : const MonthViewPageDemo(),
          // ),
        ],
      ),
    );
  }
}
