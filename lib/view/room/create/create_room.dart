import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room/common/color_schemes.dart';
import 'package:meeting_room/common/validator.dart';
import 'package:meeting_room/view/room/create/create_room_controller.dart';
import 'package:provider/provider.dart';

class CreateRoom extends StatefulWidget {
  CreateRoom({
    super.key,
    required this.room,
  });

  final String room;

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('회의실 예약'),
      ),
      body: Consumer<CreateRoomController>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Form(
                  key: provider.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                            child: TextFormField(
                              controller: provider.title,
                              validator: (v) => Validator().createRoomTitleValidator(v),
                              style: provider.fieldStyle,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: "주제",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                            child: TextFormField(
                              controller: provider.participants,
                              // validator: (v) => Validator().createRoomTitleValidator(v),
                              style: provider.fieldStyle,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "참석자 (옵션사항)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                            child: TextFormField(
                              controller: provider.onDate,
                              validator: (v) => Validator().createRoomDateValidator(v),
                              style: provider.fieldStyle,
                              readOnly: true,
                              onTap: () {
                                // showCupertinoModalPopup(
                                //   context: context,
                                //   builder: (context) {
                                //     return Container(
                                //       width: MediaQuery.of(context).size.width,
                                //       height: MediaQuery.of(context).size.height / 2.5,
                                //       color: Colors.white,
                                //       child: Column(
                                //         mainAxisSize: MainAxisSize.min,
                                //         children: [
                                //           Row(
                                //             crossAxisAlignment: CrossAxisAlignment.center,
                                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //             children: [
                                //               CupertinoButton(
                                //                 child: const Text(
                                //                   '취소',
                                //                   style: TextStyle(
                                //                     color: Colors.red,
                                //                   ),
                                //                 ),
                                //                 onPressed: () {
                                //                   Navigator.pop(context);
                                //                 },
                                //               ),
                                //               CupertinoButton(
                                //                 child: Text(
                                //                   'Done',
                                //                 ),
                                //                 onPressed: () {
                                //                   Navigator.pop(context);
                                //                 },
                                //               ),
                                //             ],
                                //           ),
                                //           Expanded(
                                //             child: CupertinoDatePicker(
                                //               minimumYear: 1900,
                                //               maximumYear: DateTime.now().year,
                                //               initialDateTime: DateTime.now(),
                                //               maximumDate: DateTime(2024),
                                //               onDateTimeChanged: (value) {
                                //                 // print(value);
                                //               },
                                //               mode: CupertinoDatePickerMode.date,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // );
                                showDatePicker(
                                  context: context,
                                  initialDate: provider.onDate.text.isEmpty ? DateTime.now() : DateTime(int.parse(provider.onYear), int.parse(provider.onMonth), int.parse(provider.onDay)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 2),
                                  locale: const Locale('ko', 'KR'),
                                  // initialEntryMode: DatePickerEntryMode.input,
                                ).then((date) {
                                  if (date != null) {
                                    provider.getOnDate(date.year, date.month, date.day);
                                    provider.onDate.text = DateFormat('yyyy년 MM월 dd일').format(date);
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: "날짜",
                                border: OutlineInputBorder(
                                  borderRadius: provider.fieldRadius,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 16.0),
                                  child: TextFormField(
                                    controller: provider.startTime,
                                    validator: (v) => Validator().createRoomStartTimeValidator(v),
                                    style: provider.fieldStyle,
                                    readOnly: true,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: provider.startTime.text.isEmpty ? TimeOfDay(hour: TimeOfDay.now().hour, minute: 0) : TimeOfDay(hour: int.parse(provider.onStartHour), minute: int.parse(provider.onStartMinute)),
                                        helpText: '시작 시각',
                                        initialEntryMode: TimePickerEntryMode.input,
                                        builder: (context, child) {
                                          if (MediaQuery.of(context).alwaysUse24HourFormat) {
                                            return child!;
                                          } else {
                                            return Localizations.override(
                                              context: context,
                                              locale: const Locale('ko', 'KR'),
                                              child: child,
                                            );
                                          }
                                        }
                                      ).then((time) {
                                        if (time != null) {
                                          provider.getOnStartTime(time.hour, time.minute);
                                          provider.startTime.text = '${time.hour == 0 ? '오전 12시' : '${time.hour}시'} ${time.minute != 0 ? '${time.minute}분' : ''}';
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: "시작 시각",
                                      constraints: BoxConstraints(
                                        maxWidth: provider.dateFieldMaxWidth(context),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: provider.fieldRadius,
                                      ),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  controller: provider.endTime,
                                  validator: (v) => Validator().createRoomEndTimeValidator(v),
                                  style: provider.fieldStyle,
                                  readOnly: true,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(hour: TimeOfDay.now().hour, minute: 0),
                                      helpText: '종료 시각',
                                      initialEntryMode: TimePickerEntryMode.input,
                                      builder: (context, child) {
                                        if (MediaQuery.of(context).alwaysUse24HourFormat) {
                                          return child!;
                                        } else {
                                          return Localizations.override(
                                            context: context,
                                            locale: const Locale('ko', 'KR'),
                                            child: child,
                                          );
                                        }
                                      }
                                    ).then((time) {
                                      if (time != null) {
                                        provider.getOnEndTime(time.hour, time.minute);
                                        provider.endTime.text = '${time.hour == 0 ? '오전 12시' : '${time.hour}시'} ${time.minute != 0 ? '${time.minute}분' : ''}';
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "종료 시각",
                                    constraints: BoxConstraints(
                                      maxWidth: provider.dateFieldMaxWidth(context),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: provider.fieldRadius,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('컬러'),
                                Container(
                                  margin: const EdgeInsets.only(left: 8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return AlertDialog(
                                            content: BlockPicker(
                                              pickerColor: provider.eventGraphColor,
                                              onColorChanged: (value) {
                                                provider.changeEventGraphColor(value);
                          
                                                Navigator.pop(dialogContext);
                                              },
                                              availableColors: colorPickerColorList,
                                              layoutBuilder: (lcontext, colors, child) {
                                                Orientation orientation = MediaQuery.of(lcontext).orientation;
                          
                                                return SizedBox(
                                                  width: Platform.isAndroid || Platform.isIOS ? MediaQuery.of(lcontext).size.width : MediaQuery.of(lcontext).size.width / 3,
                                                  height: Platform.isAndroid || Platform.isIOS ? orientation == Orientation.portrait ? 360 : 240 : 400,
                                                  child: GridView.count(
                                                    physics: const ClampingScrollPhysics(),
                                                    crossAxisCount: Platform.isAndroid || Platform.isIOS ? orientation == Orientation.portrait ? 4 : 5 : 8,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5,
                                                    children: [
                                                      for (Color color in colors) child(color),
                                                    ],
                                                  ),
                                                );
                                              },
                                              itemBuilder: (color, isCurrentColor, changeColor) {
                                                return Container(
                                                  margin: const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(MediaQuery.of(dialogContext).size.width),
                                                    color: color,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: color.withOpacity(0.6),
                                                        blurRadius: 2.0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: changeColor,
                                                      borderRadius: BorderRadius.circular(MediaQuery.of(dialogContext).size.width),
                                                      child: AnimatedOpacity(
                                                        opacity: isCurrentColor ? 1 : 0,
                                                        duration: const Duration(milliseconds: 150),
                                                        child: Icon(
                                                          Icons.done,
                                                          size: 24.0,
                                                          color: useWhiteForeground(color) ? Colors.white : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: provider.eventGraphColor
                                    ),
                                    child: Container(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                              ),
                              onPressed: () {
                                if (provider.formKey.currentState!.validate()) {
                                  provider.sendRoomData(
                                    context,
                                    room: widget.room,
                                    title: provider.title.text.trim(),
                                    year: int.parse(provider.onYear),
                                    month: int.parse(provider.onMonth),
                                    day: int.parse(provider.onDay),
                                    hour: int.parse(provider.onStartHour),
                                    minute: int.parse(provider.onStartMinute),
                                    endHour: int.parse(provider.onEndHour),
                                    endMinute: int.parse(provider.onEndMinute),
                                  );
                                }
                              },
                              child: const Center(
                                child: Text('예약'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              provider.isLoading
                ? Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                : Container(),
            ],
          );
        },
      ),
    );
  }
}
