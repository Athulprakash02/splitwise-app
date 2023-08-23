import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splitwise_app/functions/avatar_pick_function.dart';
import 'package:splitwise_app/functions/group_functions.dart';
import 'package:splitwise_app/functions/participants_function.dart';
import 'package:splitwise_app/model/group%20model/group_model.dart';
import 'package:splitwise_app/model/participant%20model/participant_model.dart';
import 'package:splitwise_app/screens/homescreen/home_screen.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

String? path;

class SplitExpenseScreen extends StatefulWidget {
  const SplitExpenseScreen({
    super.key,
    required this.groupName,
  });

  final String groupName;
  @override
  State<SplitExpenseScreen> createState() => _SplitExpenseScreenState();
}

class _SplitExpenseScreenState extends State<SplitExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final List<TextEditingController> _percentageControllers = [];
  final TextEditingController _personNameController = TextEditingController();

  String? imagePath;
  String? imageUrl;
  XFile? imagePicked;

  Future<void> pickAvatar() async {
    imagePicked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imagePicked != null) {
      setState(() {
        imagePath = imagePicked!.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Split expense'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: const Text('Add participant'),
                      content: TextField(
                        controller: _personNameController,
                        decoration: InputDecoration(
                            hintText: 'Participant name',
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
                              if (_personNameController.text.isEmpty) {
                                showSnackBar(context, Colors.red,
                                    "Participant name can't be empty");
                              } else {
                                Participants newParticipant = Participants(
                                    groupName: widget.groupName,
                                    participantName:
                                        _personNameController.text.trim(),
                                    amount: 0);
                                createParticipant(newParticipant);
                                _percentageControllers
                                    .add(TextEditingController());
                                Navigator.of(ctx).pop();
                                _personNameController.clear();
                              }
                            },
                            child: const Text('Add',
                                style: TextStyle(fontSize: 16)))
                      ],
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.add,
                size: 32,
              ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width / 16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => pickAvatar(),
              child: imagePath == null
                  ? CircleAvatar(
                      radius: size.width / 10,
                      backgroundImage:
                          const AssetImage('assets/images/icon image.png'),
                    )
                  : CircleAvatar(
                      radius: size.width / 10,
                      backgroundImage: FileImage(File(imagePath!)),
                    ),
            ),
            SizedBox(
              height: size.width * .10,
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            Expanded(
                child: StreamBuilder<List<Participants>>(
              stream: streamParticipantsFromFirebase(widget.groupName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Text('no participants');
                } else {
                  List<Participants>? participantNames = snapshot.data;
                  return Padding(
                      padding: EdgeInsets.symmetric(vertical: size.width / 10),
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            // final user = participants[index];
                            return Container(
                              width: size.width,
                              height: size.width * .22,
                              decoration: BoxDecoration(
                                color: Colors.white, // Container color
                                borderRadius: BorderRadius.circular(
                                    8.0), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5), // Shadow color
                                    spreadRadius: 1, // Spread radius
                                    blurRadius: 5, // Blur radius
                                    offset: const Offset(
                                        0, 2), // Offset in the x, y direction
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: ListTile(
                                      title: Text(
                                        participantNames![index]
                                            .participantName,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      trailing: SizedBox(
                                        width: size.width * .15,
                                        height: size.width * .2,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          controller:
                                              _percentageControllers[index],
                                          decoration: InputDecoration(
                                              hintText: '%',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )),
                                        ),
                                      ))),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: snapshot.data!.length));
                }
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            double totalPercentage = 0;
            for (var controller in _percentageControllers) {
              if (controller.text.isNotEmpty) {
                totalPercentage += double.tryParse(controller.text) ?? 0;
              }
            }
            if (totalPercentage == 100) {
              imageUrl = await addAvatar(imagePicked!);
              num total = splitExpense();
              if (total == 100) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false);
              } else {
                // ignore: use_build_context_synchronously
                showSnackBar(
                    context, Colors.red, "Total percentage should be 100.");
              }
            } else {
              showSnackBar(
                  context, Colors.red, "Total percentage should be 100.");
            }
          },
          label: const Text('Split expense')),
    );
  }

  num splitExpense() {
    double totalAmount = double.tryParse(_amountController.text) ?? 0;
    double totalPercentage = 0;

    for (var controller in _percentageControllers) {
      if (controller.text.isNotEmpty) {
        totalPercentage += double.tryParse(controller.text) ?? 0;
      }
    }

    if (totalPercentage == 100) {
      List<double> sharedAmounts = [];
      for (int i = 0; i < _percentageControllers.length; i++) {
        double percentage =
            double.tryParse(_percentageControllers[i].text) ?? 0;
        double sharedAmount = (totalAmount * percentage) / 100;
        sharedAmounts.add(sharedAmount);
      }
      updateDataInFirestore(sharedAmounts, widget.groupName);

      Group newGroup = Group(
        amount: double.parse(_amountController.text.trim()),
        id: '',
        imageAvatar: imageUrl!,
        path: path!,
        groupName: widget.groupName,
      );
      createGroup(newGroup);

      path = '';

      _amountController.clear();
      for (var controller in _percentageControllers) {
        controller.clear();
      }
      return totalPercentage;
    } else {
      showSnackBar(context, Colors.red, "Total percentage should be 100.");
    }
    return 0;
  }
}
