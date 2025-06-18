// order_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:h2o_buddy/Screens/intredient_card.dart';
import 'package:h2o_buddy/models/ingredient.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:h2o_buddy/widgets/custom_button.dart';
import 'package:h2o_buddy/widgets/botton_select.dart';
import 'summary_screen.dart';

class OrderScreen extends StatefulWidget {
  final String gender;
  final double weight, height;
  final int age;
  final double dailyCalories;

  const OrderScreen({
    super.key,
    required this.gender,
    required this.weight,
    required this.height,
    required this.age,
    required this.dailyCalories,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Ingredient> vegetables = [];
  List<Ingredient> meats = [];
  List<Ingredient> carbs = [];

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  Future<void> loadIngredients() async {
    try {
      final vegString = await rootBundle.loadString(
        'assets/json/vegetable_json.json',
      );
      final meatString = await rootBundle.loadString(
        'assets/json/meat_json.json',
      );
      final carbString = await rootBundle.loadString(
        'assets/json/carb_json.json',
      );

      setState(() {
        vegetables =
            (json.decode(vegString) as List)
                .map((json) => Ingredient.fromJson(json))
                .toList();
        meats =
            (json.decode(meatString) as List)
                .map((json) => Ingredient.fromJson(json))
                .toList();
        carbs =
            (json.decode(carbString) as List)
                .map((json) => Ingredient.fromJson(json))
                .toList();
      });
    } catch (e) {
      print('Error loading JSON: $e');
    }
  }

  int get currentCalories => [
    ...vegetables,
    ...meats,
    ...carbs,
  ].fold(0, (sum, ing) => sum + ing.calories * ing.count);

  double get currentPrice => [
    ...vegetables,
    ...meats,
    ...carbs,
  ].fold(0.0, (sum, ing) => sum + ing.price * ing.count);

  int get totalItems => [
    ...vegetables,
    ...meats,
    ...carbs,
  ].fold(0, (sum, ing) => sum + ing.count);

  double get percent => currentCalories / widget.dailyCalories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create your order',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildCategoryRow("Vegetables", vegetables),
                _buildCategoryRow("Meats", meats),
                _buildCategoryRow("Carbs", carbs),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Cals:',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '$currentCalories Cal of ${widget.dailyCalories.toStringAsFixed(0)} Cal',
                      style: TextStyle(color: Colors.black38),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      ' Price:',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      ' \$${currentPrice}',
                      style: TextStyle(color: Color(0xffF25700)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                totalItems > 0
                    ? CustomButton(
                      text: 'Place Order',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SummaryScreen(
                                  gender: widget.gender,
                                  weight: widget.weight,
                                  height: widget.height,
                                  age: widget.age,
                                  dailyCalories: widget.dailyCalories,
                                  selected:
                                      [
                                        ...vegetables,
                                        ...meats,
                                        ...carbs,
                                      ].where((i) => i.count > 0).toList(),
                                ),
                          ),
                        );
                      },
                    )
                    : ButtonSelect(text: 'Place Order', onPressed: () {}),
                const SizedBox(height: 19),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String title, List<Ingredient> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child:
              items.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final ing = items[index];
                      return IngredientCard(
                        ingredient: ing,
                        onAdd: () {
                          setState(() => ing.count++);
                        },
                        onRemove: () {
                          setState(
                            () => ing.count > 0 ? ing.count-- : ing.count,
                          );
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
