import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(32),
            child: buildForm(),
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
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Email',
            ),
            onChanged: (val) {
              setState(() => _email = val);
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => focus.nextFocus(),
          ),
          SizedBox(height: 32),
          TextFormField(
            validator: (val) => val.isEmpty ? 'Enter your password.' : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password',
            ),
            onChanged: (val) {
              setState(() => _password = val);
            },
            textInputAction: TextInputAction.done,
            onEditingComplete: () => focus.unfocus(),
            onFieldSubmitted: (value) async => _onSignInPressed(),
            obscureText: true,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async => _onSignInPressed(),
            child: Text('Log In'),
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
            onPressed: () {
              // Navigator.pushNamed(context, registerRoute);
            },
          ),
        ],
      ),
    );
  }

  void _onSignInPressed() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      print('no problem');
      /*
      showDialog(context: context, builder: (context) => LoadingDialog());
      FrostUser user = await _auth.signIn(email, password);
      Navigator.pop(context);
      if (user == null) {
        final snackBar = SnackBar(
          content: Text('Error'),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      */
    }
  }
}
