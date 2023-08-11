import 'package:flutter/material.dart';
import 'package:splitwise_app/functions/group_functions.dart';
import 'package:splitwise_app/model/group%20model/group_model.dart';
import 'package:splitwise_app/screens/expense_screen.dart';
import 'package:splitwise_app/screens/split_expense_screen.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController _groupNameController = TextEditingController();
  // final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    // final groupProvider = Provider.of<GroupProvider>(context,listen: false);
    // fetchAllGroups();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Group>>(
        future: fetchGroupsFromFirebase(),
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
                              return ExpenseScreen(group:  groups[index]);
                            },
                          ));
                        },
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              AssetImage('assets/images/icon image.png'),
                        ),
                        title: Text(
                          groups![index].groupName,
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
      floatingActionButton: FloatingActionButton.extended(
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
                          showSnackBar(
                              context, Colors.red, "Group name can't be empty");
                        } else {
                          // final _group = Group(
                          //     id: '',
                          //     groupName: _groupNameController.text.trim(),
                          //     amount: double.parse(_amountController.text));
                          // await createGroup(_group);
                          //  await groupProvider.createGroup(_group);
                          // onCreateGroupClicked(
                          //     _groupNameController.text.trim(), context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SplitExpenseScreen(groupName: _groupNameController.text.trim()),
                          ));
                          // _groupNameController.clear();
                        }
                      },
                      child:
                          const Text('Create', style: TextStyle(fontSize: 16)))
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
}
