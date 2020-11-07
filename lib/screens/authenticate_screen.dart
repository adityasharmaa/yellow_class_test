import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:yellow_class_test/screens/home_screen.dart';
import 'package:yellow_class_test/widgets/interactive_text.dart';

import '../providers/current_user_provider.dart';
import '../widgets/fancy_button.dart';
import '../widgets/grey_text_field.dart';

class Authenticate extends StatefulWidget {
  static final route = "/authenticate";

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _scaffold = GlobalKey<ScaffoldState>();
  bool _logInMode = true;
  bool _loading = false;

  void _authenticate() async {
    setState(() {
      _loading = true;
    });

    var response =
        await Provider.of<CurrentUserProvider>(context, listen: false)
            .authenticate(
      logInMode: _logInMode,
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );

    setState(() {
      _loading = false;
    });

    action(response);
  }

  void action(AuthenticateResponse response) {
    switch (response) {
      case AuthenticateResponse.INVALID_EMAIL:
        _showMessage("Invalid email!");
        break;
      case AuthenticateResponse.SHORT_PASSWORD:
        _showMessage("Password must have atleast 6 characters!");
        break;
      case AuthenticateResponse.PASSWORD_MISMATCH:
        _showMessage("Passwords do not match!");
        break;
      case AuthenticateResponse.ERROR:
        _showMessage(
            "Error authenticating user. Make sure credentials are correct.");
        break;
      case AuthenticateResponse.SUCCESS:
        Navigator.of(context).pushReplacementNamed(HomeScreen.route);
        break;
    }
  }

  void _showMessage(String message) {
    _scaffold.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 2000),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: AbsorbPointer(
        absorbing: _loading,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(child: SizedBox()),
              Text(
                _logInMode ? "Log In" : "Sign Up",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 20),
              GreyTextField(
                controller: _emailController,
                hint: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              GreyTextField(
                controller: _passwordController,
                hint: "Password",
                obscured: true,
              ),
              SizedBox(height: 10),
              if (!_logInMode)
                GreyTextField(
                  controller: _confirmPasswordController,
                  hint: "Confirm Password",
                  obscured: true,
                ),
              if (!_logInMode) SizedBox(height: 10),
              FancyButton(
                label: _logInMode ? "Log In" : "Sign Up",
                action: _authenticate,
                isLoading: _loading,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Divider()),
                    Text(
                      "  OR  ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              SizedBox(height: 10),
              InteractiveText(
                normalText: _logInMode
                    ? "Don't have an account? "
                    : "Already have an account? ",
                boldText: _logInMode ? "Sign up." : "Log in.",
                action: () {
                  setState(() {
                    _logInMode = !_logInMode;
                  });
                },
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
