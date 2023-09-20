import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meeting_room/view_model/firebase/firebase_config.dart';

class HomeScreenController with ChangeNotifier {
  get roomList => _roomList;
  Map<String, dynamic>? _roomList;

  HomeScreenController() {
    _getMeetingRoomList();
  }

  Future<void> _getMeetingRoomList() async {
    dynamic room;

    if (Platform.isWindows) {
      room = await FirebaseConfigForWindows().roomDirection.get();
      _roomList = {'number' : room['number']};
    } else {
      room = await FirebaseConfig().roomDirection.get();
      _roomList = room.data()!;
    }
    
    notifyListeners();
  }
}
