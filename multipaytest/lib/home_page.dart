import 'package:flutter/material.dart';
import 'package:multipay/multipay.dart';
import 'package:multipaytest/home_page_controller.dart';
import 'package:multipaytest/page_args.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HomePage extends StatefulWidget {
  final PageArgs? args;
  HomePage(this.args, {Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(args);
}

class _HomePageState extends StateMVC<HomePage> {
  late HomePageController _con;
  PageArgs? args;
  _HomePageState(PageArgs? _args) : super(HomePageController(_args)) {
    _con = HomePageController.con;
    args = _args;
  }
  @override
  void initState() {
    _con.initPage(arguments: args);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TEST"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MultiPay().getPaymentButtonsRack(
              _con.client,
              totalPrice: 50,
              description: "Choripan en polvo",
            ),
          ],
        ),
      ),
    );
  }
}
