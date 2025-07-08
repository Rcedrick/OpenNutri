import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 40),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Align(
        alignment: Alignment.center,
        child: IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.purple.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 28,
                    width: 28,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}

PreferredSizeWidget buildCustomAppBar(String titleText) {
  return AppBar(
    title: Text(
      titleText,
      style: const TextStyle(
        fontSize: 22,
        color: Colors.purple,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

