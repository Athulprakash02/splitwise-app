import 'package:flutter/material.dart';
import 'package:splitwise_app/screens/split_expense_screen.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

class ExpenseScreen extends StatelessWidget {
  ExpenseScreen({
    super.key,
  });
  // final GroupModel group;
  // final int index;

  final TextEditingController _participantNameController =
      TextEditingController();

  // final List<ParticipantModel> list = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Expenses'),
        centerTitle: true,
      ),
      body: Padding(
            padding: EdgeInsets.all(size.width / 16),
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // final user = participants[index];
                  // list.add(user);
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
                            title: Text(
                              'user.participantName',
                              style: const TextStyle(fontSize: 20),
                            ),
                            trailing: Text(
                              "₹${'user.amount'}",
                              style: const TextStyle(fontSize: 20),
                            ))),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: 5),
          ),
      persistentFooterButtons: [
        ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    title: const Text('Add participant'),
                    content: TextField(
                      controller: _participantNameController,
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
                          child: const Text('Cancel',
                              style: TextStyle(fontSize: 16))),
                      TextButton(
                          onPressed: () {
                            if (_participantNameController.text.isEmpty) {
                              showSnackBar(context, Colors.red,
                                  "Participant name can't be empty");
                            } else {
                              // onAddParticipantClicked(
                              //     _participantNameController.text.trim(),
                              //     context);
                              
                              _participantNameController.clear();
                            }
                          },
                          child:
                              const Text('Add', style: TextStyle(fontSize: 16)))
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add participants')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SplitExpenseScreen(
                  
                    ),
              ));

              // if(users)
            },
            icon: const Icon(Icons.attach_money_sharp),
            label: const Text('Split expense')),
      ],
    );
  }
}
