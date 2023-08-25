import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:splitwise_app/functions/auth.dart';
import 'package:splitwise_app/functions/participants_function.dart';
import 'package:splitwise_app/model/group%20model/group_model.dart';
import 'package:splitwise_app/model/participant%20model/participant_model.dart';
import 'package:splitwise_app/screens/expenses/edit_expense_screen.dart';
import 'package:splitwise_app/screens/homescreen/home_screen.dart';

import '../widgets/show_snackbar.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({
    super.key,
    required this.group,
  });
  final Group group;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final _razorpay = Razorpay();
  final TextEditingController _personNameController = TextEditingController();
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }
  @override
  void dispose() {
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
            actions: [
              IconButton(onPressed: () {
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
                                    groupName: widget.group.groupName,
                                    participantName:
                                        _personNameController.text.trim(),
                                    amount: 0);
                                createParticipant(newParticipant);
                                
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
                
              }, icon: const Icon(Icons.add))
            ],
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
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Tap on any name card to pay'),
                  ),
                  SizedBox(
                    height: size.width * .03,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            var options = {
                              'key': 'rzp_test_TVuRoan6e8ILQX',
                              'amount': users![index].amount * 100,
                              'name': 'Person 1',
                              'description': 'Fine T-Shirt',
                              'timeout': 300,
                              'prefill': {
                                'contact': '8888888888',
                                'email': 'test@razorpay.com'
                              }
                            };
                            _razorpay.open(options);
                          },
                          child: SplitAmounts(
                              size: size,
                              name: users![index].participantName,
                              amount: users![index].amount.toString(),
                              index: index),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: snapshot.data!.length,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FutureBuilder(
        future: getUserTypeByEmail(FirebaseAuth.instance.currentUser!.email!),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const SizedBox();
          }else if(snapshot.hasError){
            return const SizedBox();
          }else{
           final Map<String, dynamic>? userData = snapshot.data?.data();
            if(userData == null){
              
              userType = 'Super Admin';
            }else{
              userType = userData['User type'];
            }
            return Visibility(
          visible: userType!= 'User',
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    EditDetailsScreen(group: widget.group, users: users!),
              ));
            },
            label: const Text('Edit details'),
            icon: const Icon(Icons.edit),
          ),
        );
        }}
       
      ),
    );
  }
}

class SplitAmounts extends StatelessWidget {
  const SplitAmounts({
    super.key,
    required this.size,
    required this.amount,
    required this.index,
    required this.name,
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
