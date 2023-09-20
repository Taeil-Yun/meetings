
import 'dart:developer';
import 'dart:io';
import 'package:meeting_room/view_model/firebase/firebase_config.dart';

class DeleteScheduleApi{
  Future<bool> deleteSchedule({required String roomNo, required String selectedYear, required String selectedMonth, required String scheduleId}) async {
    try {
      bool result = false;
      dynamic docRef;

      if (Platform.isWindows) {
        docRef = FirebaseConfigForWindows().roomDirection.collection(roomNo).document(selectedYear).collection(selectedMonth).document(scheduleId);
      } else {
        docRef = FirebaseConfig().roomDirection.collection(roomNo).doc(selectedYear).collection(selectedMonth).doc(scheduleId);
      }
      
      await docRef.delete().then((value) {
          log('========== deleteSchedule  ==========');
          log('========== result: Document deleted  ==========');
          result = true;
        },
        onError: (e) {
          log("Error updating document $e");
          result = false;
        },
      );

      return result;
    } catch(e) {
      log('========== deleteSchedule Error: $e ==========');
      return false;
    }

  }
}