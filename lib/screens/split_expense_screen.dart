import 'package:flutter/material.dart';

import 'package:splitwise_app/screens/expense_screen.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

class SplitExpenseScreen extends StatefulWidget {
  const SplitExpenseScreen({
    super.key,
  });

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

    // print(list.length);
    // for (var i = 0; i < list.length; i++) {
    //   _percentageControllers.add(TextEditingController());
    // }
  }

  @override
  void dispose() {
    for (var controller in _percentageControllers) {
      controller.dispose();
    }
    super.dispose();
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
              child:  ListView.separated(
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
                                    'user.participantName',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  trailing: SizedBox(
                                    width: size.width * .15,
                                    height: size.width * .2,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: _percentageControllers[index],
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
                      itemCount: 5)
                
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            num total = splitExpense();
            if (total == 100) {
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(
              //       builder: (context) => ExpenseScreen(),
              //     ),
              //     (route) => false);
              // Navigator.of(context).pushReplacement(MaterialPageRoute(
              //   builder: (context) => ExpenseScreen(

              //   ),
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

    // if (totalPercentage == 100) {
    //   for (int i = 0; i < participantNotifier.value.length; i++) {
    //     double percentage =
    //         double.tryParse(_percentageControllers[i].text) ?? 0;
    //     double sharedAmount = (totalAmount * percentage) / 100;

    //     // Update the participant's balance with the shared amount.
    //     participantNotifier.value[i].amount += sharedAmount;
    //   }
    //   updateParticipantBalances(participantNotifier.value);

    //   _amountController.clear();
    //   for (var controller in _percentageControllers) {
    //     controller.clear();
    //   }
    //   return totalPercentage;
    // } else {
    //   showSnackBar(context, Colors.red, "Total percentage should be 100.");
    // }
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
