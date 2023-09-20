import 'dart:developer';
import 'dart:io';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meeting_room/common/color_schemes.dart';
import 'package:meeting_room/common/util/toast.dart';
import 'package:meeting_room/common/validator.dart';
import 'package:meeting_room/model/calender_event.dart';
import 'package:meeting_room/view/calender_screen/details/event_details_screen_controller.dart';
import 'package:meeting_room/view/login/login_screen_controller.dart';
import 'package:meeting_room/view/widget/dialogs.dart';
import 'package:meeting_room/view_model/firebase/room/delete_schedule.dart';
import 'package:provider/provider.dart';

class DetailsPageScreen extends StatefulWidget {
  final CalendarEventData event;

  const DetailsPageScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<DetailsPageScreen> createState() => _DetailsPageScreenState();
}

class _DetailsPageScreenState extends State<DetailsPageScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final viewModel = context.read<EventDetailsScreenController>();
      viewModel.eventInit(widget.event).then((value) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.read<LoginScreenController>();
    return Consumer<EventDetailsScreenController>(
      builder: (BuildContext context, controller, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              if(controller.event?.author == userViewModel.userInfo?.name || userViewModel.userInfo?.permission != null && userViewModel.userInfo!.permission != 2)
                TextButton(
                  onPressed: (){
                    showConfirmDialog(
                      context: context,
                      positiveButtonText: '확인',
                      negativeButtonText: '취소',
                      positiveButtonCallback: () {
                        // // TODO: 이벤트 삭제
                        DeleteScheduleApi().deleteSchedule(
                            roomNo: controller.firestoreRoot.split('/')[1],
                            selectedYear: controller.event!.startTime!.year.toString(),
                            selectedMonth: controller.event!.startTime!.month.toString(),
                            scheduleId: controller.firestoreRoot.split('/').last,
                        ).then((value) {
                          if(value){
                            showNormalToast(context: context, text: '삭제가 완료 되었습니다.', );
                            context.pop();
                            context.pop();
                          } else {
                            showNormalToast(context: context, text: '삭제에 실패 하였습니다.', );
                          }
                        });
                      },
                      // 취소
                      negativeButtonCallback: () {
                        context.pop();
                      },
                      body: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          '예약을 취소 하시겠습니까?',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,),
                      ),
                    );
                  },
                  child: const Text('삭제'),
                ),
              TextButton(
                  onPressed: (){
                    // context.push('/home/calender/weekly/event_details/fix_event');
                    controller.setInit().then((value) {
                      showFixDialog(
                        context: context,
                        controller: controller,
                        positiveButtonText: '수정',
                        positiveButtonCallback: () {  },
                        negativeButtonText: '취소',
                        negativeButtonCallback: () {
                          context.pop();
                        },
                      );
                    });

                  },
                  child: const Text('수정'),
              ),
            ],
          ),
          body: controller.event == null
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userInfo(
                    context: context,
                    title: '회의주제',
                    subTitle: controller.event!.title,
                ),
                userInfo(
                    context: context,
                    title: '시작일시',
                    subTitle: DateFormat("yyyy년 M월 d일(E) a h시 ${controller.event!.startTime!.minute != 0 ? '${controller.event!.startTime!.minute}분' : ''}", "ko").format(controller.event!.startTime!),
                ),
                userInfo(
                    context: context,
                    title: '종료일시',
                    subTitle: DateFormat("yyyy년 M월 d일(E) a h시 ${controller.event!.endTime!.minute != 0 ? '${controller.event!.endTime!.minute}분' : ''}", "ko").format(controller.event!.endTime!),
                ),
                userInfo(
                    context: context,
                    title: '컬러',
                    subTitle: '',
                    subWidget: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                              color: controller.event!.color,
                              borderRadius: BorderRadius.circular(16)
                          )
                      ),
                    )
                ),
                userInfo(
                  context: context,
                  title: '예약자',
                  subTitle: controller.event!.author,
                ),
                userInfo(
                  context: context,
                  title: '참석자',
                  subTitle: '',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget userInfo({required BuildContext context, required String title, required String subTitle, Widget? subWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),
          Expanded(
            flex: 2,
            child: subWidget ?? Text(subTitle, style: const TextStyle(fontSize: 14,),),
          ),
        ],
      ),
    );
  }

  void showFixDialog({
    required BuildContext context,
    required EventDetailsScreenController controller,
    required String positiveButtonText,
    required String negativeButtonText,
    required Function() positiveButtonCallback,
    required Function() negativeButtonCallback,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: StatefulBuilder(
          builder: (__, StateSetter setState) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height:  MediaQuery.of(context).size.height * 0.7,
              child: Form(
                key: controller.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                          child: TextFormField(
                            controller: controller.title,
                            validator: (v) => Validator().createRoomTitleValidator(v),
                            style: controller.fieldStyle,
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
                            controller: controller.participants,
                            // validator: (v) => Validator().createRoomTitleValidator(v),
                            style: controller.fieldStyle,
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
                            controller: controller.onDate,
                            validator: (v) => Validator().createRoomDateValidator(v),
                            style: controller.fieldStyle,
                            readOnly: true,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: controller.onDate.text.isEmpty ? DateTime.now() : DateTime(int.parse(controller.onYear), int.parse(controller.onMonth), int.parse(controller.onDay)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 2),
                                locale: const Locale('ko', 'KR'),
                                // initialEntryMode: DatePickerEntryMode.input,
                              ).then((date) {
                                if (date != null) {
                                  controller.getOnDate(date.year, date.month, date.day);
                                  controller.onDate.text = DateFormat('yyyy년 MM월 dd일').format(date);
                                }
                              });
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: "날짜",
                              border: OutlineInputBorder(
                                borderRadius: controller.fieldRadius,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                          child: TextFormField(
                            controller: controller.startTime,
                            validator: (v) => Validator().createRoomStartTimeValidator(v),
                            style: controller.fieldStyle,
                            readOnly: true,
                            onTap: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: controller.startTime.text.isEmpty ? TimeOfDay(hour: TimeOfDay.now().hour, minute: 0) : TimeOfDay(hour: int.parse(controller.onStartHour), minute: int.parse(controller.onStartMinute)),
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
                                  controller.getOnStartTime(time.hour, time.minute);
                                  controller.startTime.text = '${time.hour == 0 ? '오전 12시' : '${time.hour}시'} ${time.minute != 0 ? '${time.minute}분' : ''}';
                                }
                              });
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: "시작 시각",
                              constraints: BoxConstraints(
                                maxWidth: controller.dateFieldMaxWidth(context),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: controller.fieldRadius,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                          child: TextFormField(
                            controller: controller.endTime,
                            validator: (v) => Validator().createRoomEndTimeValidator(v),
                            style: controller.fieldStyle,
                            readOnly: true,
                            onTap: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: controller.endTime.text.isEmpty ? TimeOfDay(hour: TimeOfDay.now().hour, minute: 0) : TimeOfDay(hour: int.parse(controller.onEndHour), minute: int.parse(controller.onEndMinute)),
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
                                  controller.getOnEndTime(time.hour, time.minute);
                                  controller.endTime.text = '${time.hour == 0 ? '오전 12시' : '${time.hour}시'} ${time.minute != 0 ? '${time.minute}분' : ''}';
                                }
                              });
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: "종료 시각",
                              constraints: BoxConstraints(
                                maxWidth: controller.dateFieldMaxWidth(context),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: controller.fieldRadius,
                              ),
                            ),
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
                                            pickerColor: controller.eventGraphColor,
                                            onColorChanged: (value) {
                                              controller.changeEventGraphColor(value);
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
                                    ).then((value) => setState(() {}));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: controller.eventGraphColor
                                  ),
                                  child: Container(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: negativeButtonCallback,
                                child: Text(negativeButtonText),
                              ),
                              TextButton(
                                onPressed: () {
                                      if (controller.formKey.currentState!.validate()) {
                                        controller.sendRoomData(
                                          context,
                                          room: (controller.event!.event as CalenderEvent).title.split('/')[1],
                                          title: controller.title.text.trim(),
                                          year: int.parse(controller.onYear),
                                          month: int.parse(controller.onMonth),
                                          day: int.parse(controller.onDay),
                                          hour: int.parse(controller.onStartHour),
                                          minute: int.parse(controller.onStartMinute),
                                          endHour: int.parse(controller.onEndHour),
                                          endMinute: int.parse(controller.onEndMinute),
                                        );
                                      }
                                },
                                child: Text(positiveButtonText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}