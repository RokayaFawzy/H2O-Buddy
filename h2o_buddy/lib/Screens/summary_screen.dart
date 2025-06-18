import 'package:flutter/material.dart';
import 'package:h2o_buddy/models/ingredient.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'order_screen.dart';

class SummaryScreen extends StatelessWidget {
  final String gender;
  final double weight, height;
  final int age;
  final double dailyCalories;
  final List<Ingredient> selected;

  SummaryScreen({
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
    required this.dailyCalories,
    required this.selected,
  });

  Future<bool> placeOrder() async {
    final data = {
      'gender': gender,
      'weight': weight,
      'height': height,
      'age': age,
      'caloriesTarget': dailyCalories,
      'selectedIngredients':
          selected
              .map((i) => {'name': i.foodName, 'calories': i.calories})
              .toList(),
    };
    final res = await http.post(
      Uri.parse('https://uz8if7.buildship.run/placeOrder'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return res.body.toLowerCase() == 'true';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Summary')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children:
                    selected
                        .map(
                          (i) => ListTile(
                            title: Text(
                              '${i.foodName} x${i.count} = ${i.calories * i.count} kcal',
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            ElevatedButton(
              child: Text('Confirm'),
              onPressed: () async {
                final ok = await placeOrder();
                if (ok) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error placing order')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
