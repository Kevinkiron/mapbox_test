import 'package:flutter/material.dart';
import 'package:mapbox_test/utils/colors/colors.dart';
import 'package:mapbox_test/utils/reusable_widgets/kstyles.dart';
import 'package:mapbox_test/utils/reusable_widgets/reused_text.dart';

class TopHeaderSection extends StatelessWidget {
  const TopHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: width,
        height: height * .25,
        decoration: BoxDecoration(
          color: AppColors.primaryblue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 40),
          child: Row(
            children: [
              Icon(Icons.account_circle, color: AppColors.whitecolor, size: 80),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Kstyles().med(
                    text: 'Robert Doe',
                    size: 18,
                    color: AppColors.whitecolor,
                  ),
                  Kstyles().med(
                    size: 14,
                    text: 'robertdoe@gmail.com',
                    color: AppColors.whitecolor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomLine extends StatelessWidget {
  const CustomLine({super.key, required this.width, required this.color});
  final double width;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 16,
      child: Divider(color: color, thickness: 1),
    );
  }
}
