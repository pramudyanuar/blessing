import 'package:blessing/core/global_components/base_widget_container.dart';
import 'package:flutter/material.dart';

class MainAdmin extends StatelessWidget {
  const MainAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidgetContainer(
      body: Center(
        child: Text(
          'Admin Main Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}