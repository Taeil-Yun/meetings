import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room/model/calender_event.dart';
import 'package:meeting_room/view_model/firebase/firebase_config.dart';

class CalenderScreenController extends ChangeNotifier{
  EventController<CalenderEvent> scheduleController = EventController<CalenderEvent>();
  List<String> dataMonth = [];
  // Map<String, StreamSubscription<QuerySnapshot>> listListener = {};
  List<StreamSubscription<QuerySnapshot>> listListener = [];
  List<StreamSubscription<dynamic>> listListenerForWindows = [];


  Future<void> getDataAboutRoom({required String roomNo, required DateTime selectedDate}) async {
    if(!dataMonth.contains("${selectedDate.year} ${selectedDate.month}")){
      log('======== call calender data  ==========');
      log('======== selectedDate: $selectedDate  ==========');
      dataMonth.add('${selectedDate.year} ${selectedDate.month}');
      dynamic docRef;

      if (Platform.isWindows) {
        docRef = FirebaseConfigForWindows().roomDirection.collection(roomNo).document(selectedDate.year.toString()).collection(selectedDate.month.toString());

        listListenerForWindows.add(
          docRef.get().asStream().listen((event) {
            for (var change in event) {
              log('============ getDataAboutRoom listen ==============');
              log("신규 : ${change.map}");

              DateTime createDate = change['create_date'];
              DateTime startTime = change['start_time'];
              DateTime endTime = change['end_time'];

              print('startTime: ${startTime.toString()}, endTime: ${endTime.toString()}');
              
              scheduleController.add(
                CalendarEventData(
                  date: startTime,
                  event: CalenderEvent(title: '${createDate.toString()}/$roomNo/${change.id}'),
                  title: change['title'] ?? '무제',
                  description: "",
                  startTime: startTime,
                  endTime: endTime,
                  author: change['author'] ?? '',
                  participants: change['participants'] ?? [],
                  color: Color(int.parse(change['graph_color'])),
                )
              );
              notifyListeners();
            }
          }),
        );
      } else {
        docRef = FirebaseConfig().roomDirection.collection(roomNo).doc(selectedDate.year.toString()).collection(selectedDate.month.toString());

        listListener.add(
          docRef.snapshots().listen(
                (event) {
              for (var change in event.docChanges) {
                switch (change.type) {
                // 추가 이벤트
                  case DocumentChangeType.added:
                    log('============ getDataAboutRoom listen ==============');
                    log("신규 : ${change.doc.data()}");
                    DateTime createDate = change.doc['create_date'].toDate();
                    DateTime startTime = change.doc['start_time'].toDate();
                    DateTime endTime = change.doc['end_time'].toDate();
                    print('startTime: ${startTime.toString()}, endTime: ${endTime.toString()}');
                    scheduleController.add(
                        CalendarEventData(
                          date: startTime,
                          event: CalenderEvent(title: '${createDate.toString()}/$roomNo/${change.doc.id}'),
                          title: change.doc['title'] ?? '무제',
                          description: "",
                          startTime: startTime,
                          endTime: endTime,
                          author: change.doc['author'] ?? '',
                          participants: change.doc['participants'] ?? [],
                          color: Color(int.parse(change.doc['graph_color'])),
                        )
                    );
                    notifyListeners();
                    break;
                // 수정 이벤트
                  case DocumentChangeType.modified:
                    log('============ getDataAboutRoom listen ==============');
                    log("수정 : ${change.doc.data()}");

                    DateTime createDate = change.doc['create_date'].toDate();
                    DateTime startTime = change.doc['start_time'].toDate();
                    DateTime endTime = change.doc['end_time'].toDate();
                    scheduleController.removeWhere((element) => element.event!.title.split('/').last == change.doc.id);
                    scheduleController.add(
                        CalendarEventData(
                          date: startTime,
                          event: CalenderEvent(title: '${createDate.toString()}/$roomNo/${change.doc.id}'),
                          title: change.doc['title'] ?? '무제',
                          description: "",
                          startTime: startTime,
                          endTime: endTime,
                          author: change.doc['author'] ?? '',
                          participants: change.doc['participants'] ?? [],
                          color: Color(int.parse(change.doc['graph_color'])),
                        )
                    );
                    notifyListeners();
                    break;
                  case DocumentChangeType.removed:
                    log('============ getDataAboutRoom listen ==============');
                    log("삭제 : ${change.doc.id}");
                    scheduleController.removeWhere((element) => element.event!.title.split('/').last == change.doc.id);
                    // 예비 삭제
                    // scheduleController.removeWhere((element) => element.title == change.doc['title'] && element.author == change.doc['author']);
                    notifyListeners();
                    break;
                }
              }
            },
            onError: (error) => print("Listen failed: $error"),
          ),
        );
      }
    } else {
      log("getDataAboutRoom date contain");
    }

  }

  // 룸이 바뀌거나 했을때 리스너 변경
  Future<void> removeListenerDb() async {
    if (Platform.isWindows) {
      listListenerForWindows.map((e) => e.cancel());
    } else {
      listListener.map((e) => e.cancel());
    }
    scheduleController.removeListener(() { });
    scheduleController = EventController<CalenderEvent>();
    dataMonth = [];
    notifyListeners();
  }

}