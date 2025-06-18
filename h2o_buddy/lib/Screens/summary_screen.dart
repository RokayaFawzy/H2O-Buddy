import 'package:flutter/material.dart';
import 'package:h2o_buddy/models/ingredient.dart';
import 'package:h2o_buddy/widgets/custom_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SummaryScreen extends StatefulWidget {
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

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late List<Ingredient> selected;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.selected);
  }

  void onAdd(int index) {
    setState(() {
      selected[index].count += 1;
    });
  }

  void onRemove(int index) {
    setState(() {
      if (selected[index].count > 1) {
        selected[index].count -= 1;
      }
    });
  }

  double get currentPrice =>
      selected.fold(0.0, (sum, ing) => sum + ing.price * ing.count);

  int get currentCalories =>
      selected.fold(0, (sum, ing) => sum + ing.calories * ing.count);

  Future<bool> placeOrder() async {
    final data = {
      'items':
          selected
              .map(
                (i) => {
                  "name": i.foodName,
                  "total_price": (i.price * i.count).round(),
                  "quantity": i.count,
                },
              )
              .toList(),
    };

    final res = await http.post(
      Uri.parse('https://uz8if7.buildship.run/placeOrder'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    try {
      final decoded = jsonDecode(res.body);
      return decoded["result"] == true;
    } catch (e) {
      print("Decoding error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order summary',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selected.length,
                itemBuilder: (context, index) {
                  final ing = selected[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListTile(
                      leading:
                          ing.imageUrl != null && ing.imageUrl!.isNotEmpty
                              ? Image.network(
                                ing.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : const SizedBox(
                                width: 50,
                                height: 50,
                                child: Icon(Icons.image_not_supported),
                              ),
                      title: Text(ing.foodName),
                      subtitle: Text(
                        '${ing.calories} Cal ',
                        style: const TextStyle(color: Colors.black38),
                      ),
                      trailing: SizedBox(
                        height: 90,
                        width: 120,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Text(
                                '\$${(ing.price * ing.count)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: SizedBox(
                                width: 110,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outlined,
                                        color: Color(0xFFF25700),
                                        size: 20,
                                      ),
                                      onPressed: () => onRemove(index),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    Text(
                                      '${ing.count}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outlined,
                                        color: Color(0xFFF25700),
                                        size: 20,
                                      ),
                                      onPressed: () => onAdd(index),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
                        style: const TextStyle(color: Colors.black38),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price:',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '\$${currentPrice}',
                        style: const TextStyle(color: Color(0xffF25700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  CustomButton(
                    text: 'Confirm',
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (context) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                      );

                      final ok = await placeOrder();
                      Navigator.of(context).pop(); // close the loading dialog

                      if (ok) {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Error placing order')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
