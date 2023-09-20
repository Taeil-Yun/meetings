import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room/view/home_screen_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('회의실'),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/home/setting");
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<HomeScreenController>(
        builder: (context, provider, _) {
          if (provider.roomList != null) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: provider.roomList['number'].length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //1 개의 행에 보여줄 item 개수
                  childAspectRatio: 1 / 1, //item 의 가로 1, 세로 1 의 비율
                  mainAxisSpacing: 30, //수평 Padding
                  crossAxisSpacing: 30, //수직 Padding
                ),
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                    onPressed: () {
                      context.push("/home/calender", extra: provider.roomList['number'][index]);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage('assets/images/${provider.roomList['number'][index]}.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // child: Image.asset(
                            //   'assets/images/${provider.roomList['number'][index]}.jpg',
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                '${provider.roomList['number'][index]}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    
                  );
                },
              ),
            );
          } else {
            return Container(
              color: Colors.white,
            );
          }
        },
      ),
    );
  }
}
