import 'package:flutter/material.dart';

Widget TextDefault(String value, {bool bold}) {
  return Text(
    value ?? "",
    style: TextStyle(fontSize: 22, fontWeight: bold ? FontWeight.bold : null),
  );
}
