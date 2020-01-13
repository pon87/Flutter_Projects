import 'package:flutter/material.dart';
import 'package:news_app/HomeScreen.dart';


class HomeApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp(
      home: new HomeScreen(),
    );
  }
}

void main() => runApp(new HomeApp());
