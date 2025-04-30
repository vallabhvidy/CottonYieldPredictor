import 'package:cotton/cotton_form.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cotton Yield Predictor'),
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CottonForm(),
      )),
    );
  }
}