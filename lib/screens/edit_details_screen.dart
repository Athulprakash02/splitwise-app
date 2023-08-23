import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splitwise_app/functions/avatar_pick_function.dart';
import 'package:splitwise_app/functions/participants_function.dart';
import 'package:splitwise_app/model/group%20model/group_model.dart';
import 'package:splitwise_app/model/participant_model.dart';
import 'package:splitwise_app/screens/split_expense_screen.dart';
import 'package:splitwise_app/screens/homescreen/home_screen.dart';

import 'widgets/details_edit_widget.dart';

class EditDetailsScreen extends StatefulWidget {
  const EditDetailsScreen(
      {super.key, required this.group, required this.users});
  final Group group;
  final List<Participants> users;

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  late final TextEditingController _groupNameController;
  late final TextEditingController _amountController;

  final List<TextEditingController> _percentageControllers = [];

  List<double> splits = [];

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController(text: widget.group.groupName);
    _amountController =
        TextEditingController(text: widget.group.amount.toString());
    for (int i = 0; i < widget.users.length; i++) {
      double value = widget.users[i].amount / widget.group.amount * 100;
      splits.add(value);
      print(value);
      _percentageControllers.add(TextEditingController(text: value.toString()));
    }
    
  }

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
        title: const Text('Edit Details'),
        centerTitle: true,
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
                          NetworkImage(widget.group.imageAvatar),
                    )
                  : CircleAvatar(
                      radius: size.width / 10,
                      backgroundImage: FileImage(File(imagePath!)),
                    ),
            ),
            DetailsFeild(
                amountController: _groupNameController,
                text: 'Group name',
                hintText: 'Group name'),
            SizedBox(
              height: size.width * .03,
            ),
            DetailsFeild(
                amountController: _amountController,
                text: 'Total amount',
                hintText: 'Total amount'),
            SizedBox(
              height: size.width * .03,
            ),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (context, index) => DetailsFeild(
                      amountController: _percentageControllers[index],
                      text: widget.users[index].participantName,
                      hintText: 'percentage'),
                  itemCount: widget.users.length),
            )
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          imageUrl = imagePicked == null
              ? widget.group.imageAvatar
              : await addAvatar(imagePicked!);
          await delete(widget.group.imageAvatar);
          double percentage =0;
          List<double> sharedAmounts = [];
          for(int i = 0;i<widget.users.length;i++){
            double _percentage = double.parse(_percentageControllers[i].text);
            double sharedAmount = (widget.group.amount * _percentage) / 100;
        sharedAmounts.add(sharedAmount);
            percentage = percentage+ _percentage;

          }
      updateDataInFirestore(sharedAmounts, widget.group.groupName);
          if (percentage == 100) {
            Group updated = Group(
              amount: double.parse(_amountController.text),
              id: '',
              imageAvatar: imageUrl ?? widget.group.imageAvatar,
              path: path ?? widget.group.path,
              groupName: _groupNameController.text.trim(),
              // amountPersonOne: double.parse(_amountPersonOneController.text),
              // amountPersonTwo: double.parse(_amountPersonTwoController.text),
              // amountPersonThree:
              //     double.parse(_amountPersonThreeController.text)
            );
            await updateDate(updated, widget.group.groupName);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
          }
        },
        label: const Text('Update details'),
        icon: const Icon(Icons.update),
      ),
    );
  }

  Future<void> updateDate(Group updatedGroup, String groupName) async {
    // double amountOne =
    //     (updatedGroup.amountPersonOne / 100) * updatedGroup.amount;
    // double amountTwo =
    //     (updatedGroup.amountPersonTwo / 100) * updatedGroup.amount;
    // double amountThree =
    //     (updatedGroup.amountPersonThree / 100) * updatedGroup.amount;
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('groups');

      QuerySnapshot querrySnapshot =
          await collectionRef.where('group name', isEqualTo: groupName).get();
      for (QueryDocumentSnapshot docSnapshot in querrySnapshot.docs) {
        // Define the fields you want to update
        Map<String, dynamic> updatedData = {
          "group name": updatedGroup.groupName,
          "amount": updatedGroup.amount,
          "image path": updatedGroup.path,
          // "person one amount": amountOne,
          "image avatar url": updatedGroup.imageAvatar,

          // "person two amount": amountTwo,
          // "person three amount": amountThree,
          // Add other fields you want to update
        };

        // double.parse(_amountPersonThreeController.text);
        await docSnapshot.reference.update(updatedData);
      }
      // ignore: empty_catches
    } catch (e) {}
  }
}
