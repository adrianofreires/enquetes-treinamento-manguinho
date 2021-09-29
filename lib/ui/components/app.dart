import 'package:flutter/material.dart';

import '../pages/pages.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enquete',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
