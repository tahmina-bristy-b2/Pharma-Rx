import 'package:flutter/material.dart';

class CustomHomeButton extends StatelessWidget {
  final VoidCallback onClick;
  final IconData icon;
  final String title;
  final double sizeWidth;
  final Color inputColor;

  CustomHomeButton({
    
    Key? key,
    required this.onClick,
    required this.icon,
    required this.title,
    required this.sizeWidth,
    required this.inputColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        // color: Color.fromARGB(255, 165, 162, 162),
        elevation: 5,
        child: Container(
          height: MediaQuery.of(context).size.height / 8,
          width: sizeWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: inputColor,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Icon(
                icon,
                color: Colors.black,
                size: 28,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
