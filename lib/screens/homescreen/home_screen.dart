import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splitwise_app/functions/auth.dart';
import 'package:splitwise_app/functions/group_functions.dart';
import 'package:splitwise_app/main.dart';
import 'package:splitwise_app/model/group%20model/group_model.dart';
import 'package:splitwise_app/screens/expenses/expense_screen.dart';
import 'package:splitwise_app/screens/auth/login/login_screen.dart';
import 'package:splitwise_app/screens/speech_to_text.dart';
import 'package:splitwise_app/screens/expenses/split_expense_screen.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

var userType = '';

 Map<String, dynamic>? userData;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  bool visibility = false;

  @override
  void initState() {
    super.initState();


    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher',
                ),
              ));

          FirebaseMessaging.onMessageOpenedApp.listen(
            (RemoteMessage message) {
              RemoteNotification? notification = message.notification;
              AndroidNotification? android = message.notification?.android;
              if (notification != null && android != null) {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(notification.title.toString()),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(notification.body.toString())],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  void showNotification() {
    flutterLocalNotificationsPlugin.show(
        0,
        "testing",
        'LoggedOut',
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  // final TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // fetchCurrentUser();
    Size size = MediaQuery.sizeOf(context);
    // final groupProvider = Provider.of<GroupProvider>(context,listen: false);
    // fetchAllGroups();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => const WebView(),
              // ));
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SpeechToTextScreen(),
              ));
            },
            icon: const Icon(Icons.language)),
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                showNotification();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (route) => false);
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder<List<Group>>(
        future:fetchGroupsFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('no groups available'),
            );
          } else {
            List<Group>? groups = snapshot.data;
            return Padding(
              padding: EdgeInsets.all(size.width / 16),
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    // final group = snapshot.data?[index];

                    return Container(
                      width: size.width,
                      height: size.width * .22,
                      decoration: BoxDecoration(
                        color: Colors.white, // Container color
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 1, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: const Offset(
                                0, 2), // Offset in the x, y direction
                          ),
                        ],
                      ),
                      child: Center(
                          child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ExpenseScreen(group: groups[index]);
                            },
                          ));
                        },
                        leading: CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                NetworkImage(groups![index].imageAvatar)),
                        title: Text(
                          groups[index].groupName,
                          style: const TextStyle(fontSize: 20),
                        ),
                        style: ListTileStyle.drawer,
                      )),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: snapshot.data!.length),
            );
          } 
        },
      ),
      floatingActionButton: FutureBuilder(
        future: getUserTypeByEmail(FirebaseAuth.instance.currentUser!.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            return const SizedBox();
          } else {
             userData = snapshot.data?.data();
            if(userData == null){
              userType = 'Super Admin';
            }else{
              userType = userData!['User type'];
            }
            return Visibility(
              visible: userType != 'User',
              child: FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        title: const Text('Create group'),
                        content: TextField(
                          controller: _groupNameController,
                          decoration: InputDecoration(
                              hintText: 'Group name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 16),
                              )),
                          TextButton(
                              onPressed: () async {
                                if (_groupNameController.text.isEmpty) {
                                  showSnackBar(context, Colors.red,
                                      "Group name can't be empty");
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SplitExpenseScreen(
                                        groupName:
                                            _groupNameController.text.trim()),
                                  ));
                                  // _groupNameController.clear();
                                }
                              },
                              child: const Text('Create',
                                  style: TextStyle(fontSize: 16)))
                        ],
                      );
                    },
                  );
                },
                label: const Text(
                  'create group',
                  style: TextStyle(fontSize: 16),
                ),
                icon: const Icon(Icons.create),
              ),
            );
          }
        },
      ),
    );
  }
}
