import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:splitwise_app/functions/participants_function.dart';
import 'package:splitwise_app/model/group%20model/group_model.dart';
import 'package:splitwise_app/model/participant_model.dart';
import 'package:splitwise_app/screens/edit_details_screen.dart';
import 'package:splitwise_app/screens/homescreen/home_screen.dart';

class ExpenseScreen extends StatefulWidget {
  ExpenseScreen({
    super.key,
    required this.group,
  });
  final Group group;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  var _razorpay = Razorpay();
  @override
  void initState() {
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("PaymentSuccsess");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("PaymentFailed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear();
    super.dispose();
  }
  List<Participants>? users = [];

  // final int index;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.groupName),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (route) => false);
            },
            icon: const Icon(Icons.home)),
      ),
      body: StreamBuilder<List<Participants>>(
        stream: streamParticipantsFromFirebase(widget.group.groupName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('No users'),
            );
          } else {
             users = snapshot.data;
            return Padding(
              padding: EdgeInsets.all(size.width / 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      // Spacer(),
                      Text('₹${widget.group.amount}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: size.width * .03,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return SplitAmounts(
                            size: size,
                            name: users![index].participantName,
                            amount: users![index].amount.toString(),
                            index: index);
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: snapshot.data!.length,
                      // children: [
                      //
                      // Column(
                      //   children: [
                      // GestureDetector(
                      //   onTap: () {
                      //     var options = {
                      //       'key': 'rzp_test_TVuRoan6e8ILQX',
                      //       'amount': 5*100,
                      //       'name': 'Person 1',
                      //       'description': 'Fine T-Shirt',
                      //       'timeout': 300,
                      //       'prefill': {
                      //         'contact': '8888888888',
                      //         'email': 'test@razorpay.com'
                      //       }
                      //     };
                      //     _razorpay.open(options);
                      //   },
                      //   child: SplitAmounts(
                      //       size: size,
                      //       amount:
                      //           widget.group.amountPersonOne.toString(),
                      //       index: 1),
                      // ),
                      // SizedBox(
                      //   height: size.width * .03,
                      // ),
                      // SplitAmounts(
                      //     size: size,
                      //     amount: widget.group.amountPersonTwo.toString(),
                      //     index: 2),
                      // SizedBox(
                      //   height: size.width * .03,
                      // ),
                      // SplitAmounts(
                      //     size: size,
                      //     amount:
                      //         widget.group.amountPersonThree.toString(),
                      //     index: 3),
                      // ],
                      //   )
                      // ],
                    ),
                    // child: ListView.separated(
                    //     physics: const BouncingScrollPhysics(),
                    //     itemBuilder: (context, index) {
                    //       double value = group.amount / 3;
                    //       String balanceAmount = value.toStringAsFixed(2);
                    //       // final user = snapshot.data![index];
                    //       // list.add(user);
                    //       return SplitAmounts(
                    //           size: size,

                    //           amount: persons[index].toString(),
                    //           index: index + 1);
                    //     },
                    //     separatorBuilder: (context, index) => const Divider(),
                    //     itemCount: 3),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditDetailsScreen(group: widget.group,users: users!),
          ));
        },
        label: const Text('Edit details'),
        icon: const Icon(Icons.edit),
      ),
      // persistentFooterButtons: [
      //   ElevatedButton.icon(
      //       onPressed: () {
      //         showDialog(
      //           context: context,
      //           builder: (ctx) {
      //             return AlertDialog(
      //               shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(15)),
      //               title: const Text('Add participant'),
      //               content: TextField(
      //                 controller: _participantNameController,
      //                 decoration: InputDecoration(
      //                     hintText: 'Participant name',
      //                     border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(20))),
      //               ),
      //               actions: [
      //                 TextButton(
      //                     onPressed: () {
      //                       Navigator.of(ctx).pop();
      //                     },
      //                     child: const Text('Cancel',
      //                         style: TextStyle(fontSize: 16))),
      //                 TextButton(
      //                     onPressed: () async {
      //                       if (_participantNameController.text.isEmpty) {
      //                         showSnackBar(context, Colors.red,
      //                             "Participant name can't be empty");
      //                       } else {
      //                         final _participant = Participants(
      //                             groupName: group.groupName,
      //                             participantName:
      //                                 _participantNameController.text.trim(),
      //                             amount: 0);

      //                         await createParticipant(group.groupName, _participant);
      //                         // onAddParticipantClicked(
      //                         //     _participantNameController.text.trim(),
      //                         //     context);
      //                         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ExpenseScreen(group: group),));
      //                         _participantNameController.clear();
      //                       }
      //                     },
      //                     child:
      //                         const Text('Add', style: TextStyle(fontSize: 16)))
      //               ],
      //             );
      //           },
      //         );
      //       },
      //       icon: const Icon(Icons.add),
      //       label: const Text('Add participants')),
      //   ElevatedButton.icon(
      //       onPressed: () {
      //         Navigator.of(context).push(MaterialPageRoute(
      //           builder: (context) => const SplitExpenseScreen(),
      //         ));

      //         // if(users)
      //       },
      //       icon: const Icon(Icons.attach_money_sharp),
      //       label: const Text('Split expense')),
      // ],
    );
  }
}

class SplitAmounts extends StatelessWidget {
  const SplitAmounts({
    super.key,
    required this.size,
    required this.amount,
    required this.index, required this.name,
  });

  final Size size;
  // final List<double> persons;
  final String amount;
  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.width * .22,
      decoration: BoxDecoration(
        color: Colors.white, // Container color
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 1, // Spread radius
            blurRadius: 5, // Blur radius
            offset: const Offset(0, 2), // Offset in the x, y direction
          ),
        ],
      ),
      child: Center(
          child: ListTile(
              title: Text(
                name,
                style: const TextStyle(fontSize: 20),
              ),
              trailing: Text(
                "₹$amount",
                style: const TextStyle(fontSize: 20),
              ))),
    );
  }
}
