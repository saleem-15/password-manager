import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/controllers/password_controller.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../helpers/colors.dart';
import '../screens/reused_passwords_screen.dart';

class PasswordsAnalytics extends StatelessWidget {
  const PasswordsAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 7.0,
            percent: .8,
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            reverse: true,
            center: const Text(
              "80",
              style: TextStyle(fontSize: 24),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            progressColor: lightGreen,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GetBuilder<PasswordController>(
              builder: (controller) => InkWell(
                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                onTap: () => Get.to(() => const ReusedPasswordsScreen()),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.numOfSimilarPasswords().toString(),
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Reused',
                        style: TextStyle(
                          fontSize: 18,
                          color: lightRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '89',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Weak',
                  style: TextStyle(
                    fontSize: 18,
                    color: lightRed,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
