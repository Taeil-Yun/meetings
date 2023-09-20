import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room/view/calender_screen/calender_screen.dart';
import 'package:meeting_room/view/calender_screen/details/event_details_screen.dart';
import 'package:meeting_room/view/calender_screen/details/event_details_screen_controller.dart';
import 'package:meeting_room/view/calender_screen/weekly_screen.dart';
import 'package:meeting_room/view/home_screen.dart';
import 'package:meeting_room/view/home_screen_controller.dart';
import 'package:meeting_room/view/login/login_screen.dart';
import 'package:meeting_room/view/login/signin/sign_in_screen.dart';
import 'package:meeting_room/view/login/signin/sign_in_screen_controller.dart';
import 'package:meeting_room/view/room/create/create_room.dart';
import 'package:meeting_room/view/room/create/create_room_controller.dart';
import 'package:meeting_room/view/setting/setting_screen.dart';
import 'package:provider/provider.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
          opaque: false,
          transitionDuration: const Duration(milliseconds: 150),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'signin',
          builder: (BuildContext context, GoRouterState state) {
            return ChangeNotifierProvider(
              create: (BuildContext context) => SignInScreenController(),
              child: const SignInScreen(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        // return const CalenderScreen();
        return ChangeNotifierProvider(
          create: (context) => HomeScreenController(),
          child: const HomeScreen(),
        );
      },
      // 서브 페이지
      routes: <RouteBase>[
        GoRoute(
          path: 'calender',
          builder: (BuildContext context, GoRouterState state) {
            final room = state.extra! as String;
            return CalenderScreen(
              room: room,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'weekly',
              builder: (BuildContext context, GoRouterState state) {
                Map<String, dynamic> args = state.extra as Map<String, dynamic>;
                DateTime date = args["date"] as DateTime;
                String room = args["room"] as String;

                return WeeklyScreens(
                  selectedDate: date,
                  room: room,
                );
              },
                routes: <RouteBase>[
                  // 상세
                  GoRoute(
                    path: 'event_details',
                    builder: (BuildContext context, GoRouterState state) {
                      return ChangeNotifierProvider(
                        create: (context) => EventDetailsScreenController(),
                        child: DetailsPageScreen(
                          event: state.extra! as CalendarEventData,
                        ),
                      );
                    },
                  ),
                ]
            ),
          ],
        ),
        // 회의실 생성 페이지
        GoRoute(
          path: 'create_room',
          builder: (BuildContext context, GoRouterState state) {
            Map<String, dynamic> args = state.extra as Map<String, dynamic>;
            DateTime? date = args["date"] as DateTime?;
            String room = args["room"] as String;
            
            return ChangeNotifierProvider(
              create: (context) => CreateRoomController(selectedDate: date),
              child: CreateRoom(room: room),
            );
          },
        ),
        // 설정 페이지
        GoRoute(
          path: 'setting',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingScreen();
          },
        ),
      ],
    ),
  ],
);
