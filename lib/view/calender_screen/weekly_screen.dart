import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room/common/util/toast.dart';
import 'package:meeting_room/view/widget/calender/week.dart';

class WeeklyScreens extends StatelessWidget {
  final DateTime? selectedDate;
  final String room;
  const WeeklyScreens({super.key, this.selectedDate, required this.room});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: WeekViewDemo(
          room: room,
          selectedDay: selectedDate,
          onCellTap: (event, date) {
            /// TODO: 수정? 삭제? 등등 기능 추가
            print('event: $event, date: $date');
            print('?????');
            context.push('/home/calender/weekly/event_details', extra: event.first);
          },
          onDateTap: (date) {
            if (DateTime(date.year, date.month, date.day).millisecondsSinceEpoch >= DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch) {
              context.push('/home/create_room', extra: {'room': room, 'date': date});
            } else {
              // ignore: use_build_context_synchronously
              showNegativeToast(context: context, text: '지난날은 예약할 수 없습니다');
            }
          },
        ));
  }
}
