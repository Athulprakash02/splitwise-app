import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app/model/group%20model/group_model.dart';
import 'package:splitwise_app/screens/expense_screen.dart';
import 'package:splitwise_app/screens/widgets/homescreen/home_screen.dart';

import 'widgets/details_edit_widget.dart';

class EditDetailsScreen extends StatefulWidget {
  EditDetailsScreen({super.key, required this.group});
  final Group group;

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  late final TextEditingController _groupNameController;
  //  final groupName;
  late final TextEditingController _amountController;
  late final TextEditingController _amountPersonOneController;

  late final TextEditingController _amountPersonTwoController;

  late final TextEditingController _amountPersonThreeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // groupName = widget.group.groupName;
    _groupNameController = TextEditingController(text: widget.group.groupName);
    _amountController =
        TextEditingController(text: widget.group.amount.toString());
    _amountPersonOneController = TextEditingController(
        text: (widget.group.amountPersonOne / widget.group.amount * 100)
            .toString());
    _amountPersonTwoController = TextEditingController(
        text: (widget.group.amountPersonTwo / widget.group.amount * 100)
            .toString());
    _amountPersonThreeController = TextEditingController(
        text: (widget.group.amountPersonThree / widget.group.amount * 100)
            .toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Details'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(size.width / 16),
            child: Column(
              children: [
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
                DetailsFeild(
                    amountController: _amountPersonOneController,
                    text: 'person 1',
                    hintText: 'percentage'),
                SizedBox(
                  height: size.width * .03,
                ),
                DetailsFeild(
                    amountController: _amountPersonTwoController,
                    text: 'person 2',
                    hintText: 'percentage'),
                SizedBox(
                  height: size.width * .03,
                ),
                DetailsFeild(
                    amountController: _amountPersonThreeController,
                    text: 'person 3',
                    hintText: 'percentage'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          print("aaaaaa ${_amountPersonOneController.text}");
          double percentage = double.parse(_amountPersonOneController.text) +
              double.parse(_amountPersonTwoController.text) +
              double.parse(_amountPersonThreeController.text);
          // double sharedAmount = (totalAmount * percentage) / 100;
          print(percentage);
          if (percentage == 100) {
            Group updated = Group(
                amount: double.parse(_amountController.text),
                id: '',
                groupName: _groupNameController.text.trim(),
                amountPersonOne: double.parse(_amountPersonOneController.text),
                amountPersonTwo: double.parse(_amountPersonTwoController.text),
                amountPersonThree:
                    double.parse(_amountPersonThreeController.text));
           await updateDate(updated, widget.group.groupName);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false);
          }
        },
        label: Text('Update details'),
        icon: Icon(Icons.update),
      ),
    );
  }

  Future<void> updateDate(Group updatedGroup, String groupName) async {
    double amountOne =
        (updatedGroup.amountPersonOne / 100) * updatedGroup.amount;
    double amountTwo =
        (updatedGroup.amountPersonTwo / 100) * updatedGroup.amount;
    double amountThree =
        (updatedGroup.amountPersonThree / 100) * updatedGroup.amount;
    print(amountOne);
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
          "person one amount": amountOne,

          "person two amount": amountTwo,
          "person three amount": amountThree,
          // Add other fields you want to update
        };

        double.parse(_amountPersonThreeController.text);
        await docSnapshot.reference.update(updatedData);
      }
    } catch (e) {}
  }
}
