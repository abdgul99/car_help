import 'package:flutter/material.dart';

kSnakbar(BuildContext context, String message) {
  var snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
