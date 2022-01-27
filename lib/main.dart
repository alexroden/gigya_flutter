import 'package:flutter/material.dart';
import './routes/account_information.dart';
import './routes/forgot_password.dart';
import './routes/home_page.dart';
import './routes/login_with_credentials.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: _exampleRoutes(),
    );
  }

  /// Each route demonstrates a different flow.
  ///
  /// Specific implementation available in every route widget.
  Map<String, WidgetBuilder> _exampleRoutes() {
    return {
      '/': (context) => HomePageWidget(),
      '/login_credentials': (context) => LoginWidthCredentialsWidget(),
      '/account_information': (context) => AccountInformationWidget(),
      '/forgot_password': (context) => ForgotPasswordPageWidget(),
    };
  }
}
