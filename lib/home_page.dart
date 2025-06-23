import 'package:db_exp_395/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    ///DbHelper dbHelper = DbHelper();
    DbHelper dbHelper = DbHelper.getInstance();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
    );
  }
}
