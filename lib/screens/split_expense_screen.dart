import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splitwise_app/functions/avatar_pick_function.dart';
import 'package:splitwise_app/functions/group_functions.dart';
import 'package:splitwise_app/model/group%20model/group_model.dart';
import 'package:splitwise_app/screens/widgets/homescreen/home_screen.dart';
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
  // final list = participantNotifier.value.toList();
  @override
  void initState() {
    super.initState();
    print(widget.groupName);

    // print(list.length);
    for (var i = 0; i < 3; i++) {
      _percentageControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in _percentageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  
  String? imagePath;
  String? imageUrl;
   XFile? imagePicked;
  
  Future<void> pickAvatar() async{
  
  imagePicked = await ImagePicker().pickImage(source: ImageSource.gallery);

  if(imagePicked!=null){
    print('vann');
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
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width / 16),
        child: Column(
          children: [

             GestureDetector(
              onTap: () => pickAvatar(),
                        child:imagePath == null?  CircleAvatar(radius: size.width/10,
                        backgroundImage:  AssetImage('assets/images/icon image.png'),): CircleAvatar(radius: 28,
                        backgroundImage:  FileImage(File(imagePath!)),),
                      ),
                      SizedBox(height: size.width*.10,),
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
                child: Padding(
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
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
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
                                      "person ${index+1}",
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
                        itemCount: 3)))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            imageUrl = await addAvatar(imagePicked!);
            num total = splitExpense();
            if (total == 100) {
              print(total);
              for (int i = 0; i < 3; i++) {
                print(_percentageControllers[i].text);
              }
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false);
              // Navigator.of(context).pushReplacement(MaterialPageRoute(
              //   builder: (context) => ExpenseScreen(

              //   )
              // ));
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
      for (int i = 0; i < 3; i++) {
        double percentage =
            double.tryParse(_percentageControllers[i].text) ?? 0;
        double sharedAmount = (totalAmount * percentage) / 100;
        sharedAmounts.add(sharedAmount);
        print(sharedAmount);

        // Update the participant's balance with the shared amount.
        // participantNotifier.value[i].amount += sharedAmount;
      }
      print(widget.groupName);
      // updateParticipantBalances(participantNotifier.value);
      
      Group newGroup = Group(
        amount: double.parse(_amountController.text.trim()),
        id: '',
        imageAvatar: imageUrl!,
        path: path!,
        groupName: widget.groupName,
        amountPersonOne: sharedAmounts[0],
        amountPersonTwo: sharedAmounts[1],
        amountPersonThree: sharedAmounts[2],
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

  // Future<void> updateParticipantBalances(
  //     List<ParticipantModel> participants) async {
  //   // final participantBox = await Hive.openBox<ParticipantModel>('participants');
  //   // for (int i = 0; i < participants.length; i++) {
  //   //   await participantBox.putAt(i, participants[i]);
  //   // }
  // }
}
