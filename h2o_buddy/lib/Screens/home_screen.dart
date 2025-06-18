import 'package:flutter/material.dart';
import 'package:h2o_buddy/widgets/custom_button.dart';
import 'user_info_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/girl.jpg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Text(
                        'Balanced Meal',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'AbhayaLibre',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  Spacer(),

                  Container(
                    width: 327,
                    height: 120,
                    margin: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Craft your ideal meal effortlessly with our app. Select nutritious ingredients tailored to your taste and well-being.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins',
                        height: 1.5,
                        letterSpacing: 0.0,
                        color: Color(0xFFDADADA),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  CustomButton(
                    text: 'Order Food',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => UserInfoScreen()),
                      );
                    },
                  ),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
