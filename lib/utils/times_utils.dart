import 'package:flutter/material.dart';

String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'il y a ${difference.inSeconds} seconde${difference.inSeconds > 1 ? 's' : ''}';
  } else if (difference.inMinutes < 60) {
    return 'il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
  } else if (difference.inHours < 24) {
    return 'il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
  } else {
    return 'il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
  }
}
