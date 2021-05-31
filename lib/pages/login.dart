import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/styles.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/auth.dart';
import 'package:hoot/views/loading_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService.getInstance();
  final _formKey = GlobalKey<FormState>();
  bool _checked = false;

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(systemNavigationBarColor: primaryColor),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32),
              child: buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm() {
    final focus = FocusScope.of(context);

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(height: 32),
          TextFormField(
            validator: (val) => val.isEmpty ? 'Enter your email.' : null,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(largePadding),
            ),
            onChanged: (val) {
              _email = val;
              if (_checked) _formKey.currentState.validate();
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => focus.nextFocus(),
          ),
          SizedBox(height: 32),
          TextFormField(
            validator: (val) => val.isEmpty ? 'Enter your password.' : null,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(largePadding),
            ),
            onChanged: (val) {
              _password = val;
              if (_checked) _formKey.currentState.validate();
            },
            textInputAction: TextInputAction.done,
            onEditingComplete: () => focus.unfocus(),
            onFieldSubmitted: (value) async => _onSignInPressed(),
            obscureText: true,
          ),
          SizedBox(height: 32),
          TextButton(
            onPressed: () async => _onSignInPressed(),
            child: Text('Log In'),
            style: defaultButtonStyle,
          ),
          SizedBox(height: 16),
          TextButton(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Don\'t have an account? '),
                  TextSpan(
                    text: 'Sign up.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, '/register'),
          ),
        ],
      ),
    );
  }

  void _onSignInPressed() async {
    _checked = true;
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      showDialog(
        context: context,
        builder: (context) => LoadingDialog(),
      );
      dynamic result = await _auth.signIn(_email, _password);
      Navigator.pop(context);
      if (result is HootUser) {
        Map args = {'user': result};
        Navigator.pushReplacementNamed(context, '/home', arguments: args);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(buildErrorSnackBar(result, context));
      }
    }
  }
}
