import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(BalancedMealApp());

class BalancedMealApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balanced Meal',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}
