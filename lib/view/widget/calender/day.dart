import 'package:flutter/material.dart';
import 'package:meeting_room/view/widget/calender/day_widget.dart';

class DayViewPageDemo extends StatefulWidget {
  const DayViewPageDemo({Key? key}) : super(key: key);

  @override
  _DayViewPageDemoState createState() => _DayViewPageDemoState();
}

class _DayViewPageDemoState extends State<DayViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        onPressed: () async {
          // final event =
          // await context.pushRoute<CalendarEventData<Event>>(CreateEventPage(
          //   withDuration: true,
          // ));
          // if (event == null) return;
          // CalendarControllerProvider.of<CalenderEvent>(context).controller.add(event);
        },
        child: const Icon(Icons.add),
      ),
      body: const DayViewWidget(),
    );
  }
}
