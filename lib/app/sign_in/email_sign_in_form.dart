import 'package:flutter/material.dart';
import 'package:time_tracker_app/app/sign_in/validators.dart';
import 'package:time_tracker_app/common_widgets/form_submit_button.dart';
import 'package:time_tracker_app/services/auth.dart';

enum EmailSignInType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  final AuthBase auth;

  EmailSignInForm({@required this.auth});

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  EmailSignInType _formType = EmailSignInType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final primaryText =
        _formType == EmailSignInType.signIn ? 'Sign in' : "Create an account";
    final secondaryText = _formType == EmailSignInType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) && !_isLoading;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildEmailTextField(),
          SizedBox(
            height: 8.0,
          ),
          _buildPasswordTextField(),
          SizedBox(
            height: 8.0,
          ),
          FormSubmitButton(
            text: primaryText,
            onPressed: submitEnabled ? _submit : null,
          ),
          SizedBox(
            height: 8.0,
          ),
          FlatButton(
            child: Text(secondaryText),
            onPressed: !_isLoading ? _toggleFormType : null,
          )
        ],
      ),
    );
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
          labelText: 'Password',
          errorText: showErrorText ? widget.invalidPasswordErrorText : null,
          enabled: _isLoading == false),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'user@mail.com',
          errorText: showErrorText ? widget.invalidEmailErrorText : null,
          enabled: _isLoading == false),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingCompelte,
    );
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignInType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (error) {
      print(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInType.signIn
          ? EmailSignInType.register
          : EmailSignInType.signIn;
      _submitted = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _emailEditingCompelte() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  _updateState() {
    setState(() {});
  }
}
