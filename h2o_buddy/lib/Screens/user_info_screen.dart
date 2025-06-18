import 'package:flutter/material.dart';
import 'package:h2o_buddy/widgets/labeled_text_field.dart';
import 'package:h2o_buddy/widgets/gender_dropdown.dart';
import 'order_screen.dart';
import '../utils/calculator.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  String? gender;
  final weightCtrl = TextEditingController();
  final heightCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  bool get isFormValid =>
      gender != null &&
      weightCtrl.text.isNotEmpty &&
      heightCtrl.text.isNotEmpty &&
      ageCtrl.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFBFBFB),

      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          'Enter your details',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomGenderDropdown(
              value: gender,
              items: ['Male', 'Female'],
              onChanged: (val) => setState(() => gender = val),
            ),

            const SizedBox(height: 24),

            LabeledTextField(
              label: "Weight",
              hint: "Enter your weight",
              unit: "Kg",
              controller: weightCtrl,
              onChanged: () => setState(() {}),
            ),

            const SizedBox(height: 24),

            LabeledTextField(
              label: "Height",
              hint: "Enter your height",
              unit: "Cm",
              controller: heightCtrl,
              onChanged: () => setState(() {}),
            ),

            const SizedBox(height: 24),

            LabeledTextField(
              label: "Age",
              hint: "Enter your age",
              unit: null,
              controller: ageCtrl,
              onChanged: () => setState(() {}),
            ),

            const SizedBox(height: 132),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isFormValid
                        ? () {
                          final w = double.tryParse(weightCtrl.text) ?? 0;
                          final h = double.tryParse(heightCtrl.text) ?? 0;
                          final a = int.tryParse(ageCtrl.text) ?? 0;
                          final daily = calculateCalories(
                            gender: gender!,
                            weight: w,
                            height: h,
                            age: a,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => OrderScreen(
                                    gender: gender!,
                                    weight: w,
                                    height: h,
                                    age: a,
                                    dailyCalories: daily,
                                  ),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isFormValid ? Color(0xFFFF5B28) : Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: isFormValid ? Colors.white : Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
