import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/template_viewmodel.dart';
import 'views/template_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TemplateViewModel()),
      ],
      child: MaterialApp(
        home: TemplateView(),
      ),
    );
  }
}
