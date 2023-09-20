import 'dart:developer';
import 'dart:io';

import 'package:meeting_room/view_model/firebase/firebase_config.dart';

class CreateRoomAPI {
  Future<bool> checkAvaliableDate({required String room, required String onYear, required String onMonth, required DateTime startTime, required DateTime endTime}) async {
    try {
      dynamic getMeetingTime;
      // List<(int, int)> existDateCheck;
      List<dynamic> existDateCheck;

      if (Platform.isWindows) {
        getMeetingTime = await FirebaseConfigForWindows().roomDirection.collection(room).document(onYear).collection(onMonth).get();

        var allMeetDateTime = getMeetingTime.map((e) {
          (int, int) dv = (
            DateTime.parse(e['start_time'].toString().replaceAll(e['start_time'].toString().split('.')[1], '000')).millisecondsSinceEpoch,
            DateTime.parse(e['end_time'].toString().replaceAll(e['end_time'].toString().split('.')[1], '000')).millisecondsSinceEpoch,
          );
          return dv;
        });

        existDateCheck = allMeetDateTime.where((element) => DateTime(DateTime.fromMillisecondsSinceEpoch(element.$2).year, DateTime.fromMillisecondsSinceEpoch(element.$2).month, DateTime.fromMillisecondsSinceEpoch(element.$2).day).millisecondsSinceEpoch == DateTime(startTime.year, startTime.month, startTime.day).millisecondsSinceEpoch && startTime.millisecondsSinceEpoch < element.$2).toList();
      } else {
        getMeetingTime = await FirebaseConfig().roomDirection.collection(room).doc(onYear).collection(onMonth).get();

        Iterable<(int, int)> allMeetDateTime = getMeetingTime.docs.map((e) {
          (int, int) dv = (
            DateTime.parse(e.data()['start_time'].toDate().toString().replaceAll(e.data()['start_time'].toDate().toString().split('.')[1], '000')).millisecondsSinceEpoch,
            DateTime.parse(e.data()['end_time'].toDate().toString().replaceAll(e.data()['end_time'].toDate().toString().split('.')[1], '000')).millisecondsSinceEpoch,
          );
          return dv;
        });

        // var asd = getMeetDateTime.where((element) => element.$1 == startTime.millisecondsSinceEpoch && element.$2 > endTime.millisecondsSinceEpoch).toList();
        existDateCheck = allMeetDateTime.where((element) => DateTime(DateTime.fromMillisecondsSinceEpoch(element.$2).year, DateTime.fromMillisecondsSinceEpoch(element.$2).month, DateTime.fromMillisecondsSinceEpoch(element.$2).day).millisecondsSinceEpoch == DateTime(startTime.year, startTime.month, startTime.day).millisecondsSinceEpoch && startTime.millisecondsSinceEpoch < element.$2).toList();
      }

      if (existDateCheck.isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('========== meeting room check avaliable date error ==========');
      log('========== $e ==========');
      return false;
    }
  }

  Future<bool> insertRoomData({
    required String room,
    required DateTime createDate,
    required String title,
    required String author,
    required int onDate,
    required DateTime startTime,
    required DateTime endTime,
    String? onYear,
    String? onMonth,
    List<String>? participants,
    String? graphColor,
  }) async {
    try {
      if (Platform.isWindows) {
        await FirebaseConfigForWindows().roomDirection.collection(room).document(onYear ?? DateTime.now().year.toString()).collection(onMonth ?? DateTime.now().month.toString()).add({
          'title': title,
          'author': author,
          'participants': participants,
          'create_date': createDate,
          'start_time': startTime,
          'end_time': endTime,
          'location': '$room 회의실',
          'graph_color': '0x$graphColor',
        });
      } else {
        await FirebaseConfig().roomDirection.collection(room).doc(onYear ?? DateTime.now().year.toString()).collection(onMonth ?? DateTime.now().month.toString()).doc().set({
          'title': title,
          'author': author,
          'participants': participants,
          'create_date': createDate,
          'start_time': startTime,
          'end_time': endTime,
          'location': '$room 회의실',
          'graph_color': '0x$graphColor',
        });
      }

      log('========== CreateRoom Success ==========');

      return true;
    } catch (e) {
      log('========== CreateRoom Error: $e ==========');

      return false;
    }
  }
}
