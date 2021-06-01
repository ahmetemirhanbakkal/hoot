import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/styles.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/auth.dart';
import 'package:hoot/services/firestore.dart';
import 'package:hoot/views/loading_dialog.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService.getInstance();
  final FirestoreService _firestore = FirestoreService.getInstance();
  final _formKey = GlobalKey<FormState>();
  bool _checked = false;
  bool _passwordVisible = false;

  String _email = '';
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(systemNavigationBarColor: primaryColor),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
        ),
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
              'Register',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          SizedBox(height: 32),
          TextFormField(
            validator: (val) =>
                val.isEmpty ? 'Please use a valid email.' : null,
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
            validator: (val) =>
                val.isEmpty ? 'Username can\'t be empty.' : null,
            decoration: InputDecoration(
              hintText: 'Username',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(largePadding),
            ),
            onChanged: (val) {
              _username = val;
              if (_checked) _formKey.currentState.validate();
            },
            textInputAction: TextInputAction.next,
            onEditingComplete: () => focus.nextFocus(),
          ),
          SizedBox(height: 32),
          TextFormField(
            obscureText: !_passwordVisible,
            validator: (val) => val.length < 6
                ? 'Your password eat least must be 6 character.'
                : null,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(largePadding),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
            onChanged: (val) {
              _password = val;
              if (_checked) _formKey.currentState.validate();
            },
            textInputAction: TextInputAction.done,
            onEditingComplete: () => focus.unfocus(),
            onFieldSubmitted: (value) async => _onSignUpPressed(),
          ),
          SizedBox(height: 32),
          TextButton(
            onPressed: () async => _onSignUpPressed(),
            child: Text('Sign Up'),
            style: defaultButtonStyle,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void _onSignUpPressed() async {
    _checked = true;
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      showDialog(
        context: context,
        builder: (context) => LoadingDialog(),
      );
      dynamic result = await _auth.signUp(_email, _password);
      if (result is HootUser) {
        String firestoreError =
            await _firestore.createUser(result.id, _username);
        Navigator.pop(context);
        if (firestoreError == null) {
          result.username = _username;
          Map args = {'user': result};
          Navigator.pushReplacementNamed(
            context,
            '/home',
            arguments: args,
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(buildErrorSnackBar(firestoreError, context));
        }
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(buildErrorSnackBar(result, context));
      }
    }
  }
}
