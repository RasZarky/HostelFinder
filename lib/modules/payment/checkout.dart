import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:hostel_finder/modules/payment/payment_success.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String publicKey = 'pk_test_fe2f83e57a677b515c71dfa029947515e094c1e1';
  final plugin = PaystackPlugin();
  String successMessage = '';

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  checkout() async {
    int price = int.parse(amountController.text) * 100;
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now().millisecondsSinceEpoch}'
      ..email = emailController.text
      ..currency = "GHS";
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    print(response);

    if (response.status == true) {
      print(response);
      successMessage = 'Payment was successful. Ref: ${response.reference}';

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PaymentSuccess(successMessage: successMessage)));

    } else {
      print(response.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Checkout Page')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: amountController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefix: Text(
                        'GHS',
                        style: TextStyle(color: Colors.black),
                      ),
                      hintText: '2000',
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'janedoe@who.com',
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          checkout();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Colors.white, //change background color of button
                        backgroundColor:
                            Colors.teal, //change text color of button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 5.0,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'Proceed to Pay',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
