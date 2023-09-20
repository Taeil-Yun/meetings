import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeting_room/view_model/firebase/firebase_config.dart';

class FixRoomAPI {
  Future<bool> checkAvaliableDate({required String room, required String eventId, required String onYear, required String onMonth, required DateTime startTime, required DateTime endTime}) async {
    QuerySnapshot<Map<String, dynamic>> getMeetingTime = await FirebaseConfig().roomDirection.collection(room).doc(onYear).collection(onMonth).get();

    bool isTimeRangeEmpty(DateTime startTime, DateTime endTime, QuerySnapshot<Map<String, dynamic>> docs) {
      for (var bookedSlot in docs.docs) {
        if (bookedSlot.id != eventId && (bookedSlot["start_time"].toDate()).isBefore(endTime) && (bookedSlot['end_time'].toDate()).isAfter(startTime)) {
          return false;
        }
      }
      return true;
    }

    if (isTimeRangeEmpty(startTime, endTime, getMeetingTime)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> fixRoomData({
    required String room,
    required String eventId,
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
      await FirebaseConfig().roomDirection.collection(room).doc(onYear ?? DateTime.now().year.toString()).collection(onMonth ?? DateTime.now().month.toString()).doc(eventId).update({
        'title': title,
        'author': author,
        'participants': participants,
        'create_date': createDate,
        'start_time': startTime,
        'end_time': endTime,
        'location': '$room 회의실',
        'graph_color': '0x$graphColor',
      });

      log('========== CreateRoom Success ==========');

      return true;
    } catch (e) {
      log('========== CreateRoom Error: $e ==========');

      return false;
    }
  }
}
