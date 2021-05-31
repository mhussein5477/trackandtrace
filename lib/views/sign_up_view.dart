import 'package:flutter/material.dart';
import 'package:trackandtrace/services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:trackandtrace/widgets/provider_widget.dart';



// TODO move this to tone location
final primaryColor = const Color(0xFF2196F3);

enum AuthFormType { signIn, signUp, reset }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;

  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (authFormType == AuthFormType.signIn) {
          String uid = await auth.signInWithEmailAndPassword(_email, _password);
          print("Signed In with ID $uid");
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (authFormType == AuthFormType.reset) {
          await auth.sendPasswordResetEmail(_email);
          print("Password reset email sent");
          _warning = "A password reset link has been sent to $_email";
          setState(() {
            authFormType = AuthFormType.signIn;
          });
        } else {
          String uid = await auth.createUserWithEmailAndPassword(
              _email, _password, _name);
          print("Signed up with New ID $uid");
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        print(e);
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration:  BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/image/background.jpeg"), fit: BoxFit.cover)),
        height: _height,
        width: _width,
        child: SafeArea(
          child: Column(

            children: <Widget>[
              SizedBox(height: _height * 0.025),
              showAlert(),
              SizedBox(height: _height * 0.025),

              Padding(
                padding: const EdgeInsets.only(top:18.0, bottom: 48),
                child: Text(
                  "Track and Trace",
                  style: TextStyle(fontSize: 32, color: Colors.blue , fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                ),
              ),
              Row(
                children: [
                  Padding(padding:  const EdgeInsets.only(left:19.0, ),
                  child:  buildHeaderText(),)

                ],
              ),


              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: buildInputs() + buildButtons(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signUp) {
      _headerText = "Sign Up";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Sign In";
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 21,
        color: Colors.blue,
        fontWeight: FontWeight.w600
      ),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];
    if (authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          style: TextStyle(fontSize: 18.0),
          decoration: buildSignUpInputDecoration("Email"),
          onSaved: (value) => _email = value.trim(),
        ),
      );
      textFields.add(SizedBox(height: 20));
      return textFields;
    }

    // if were in the sign up state add name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 15.0),
          decoration: buildSignUpInputDecoration("First Name .. Middle Name .. Last Name"),
          onSaved: (value) => _name = value,
        ),
      );
      textFields.add(SizedBox(height: 20));
    }

    // add email & password
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 18.0),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value.trim(),
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 18.0),
        decoration: buildSignUpInputDecoration("Password"),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(SizedBox(height: 20));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
      const EdgeInsets.only(left: 17.0, bottom: 15.0, top: 15.0),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Sign Up";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Submit";
    } else {
      _switchButtonText = "Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      Padding(
        padding: const EdgeInsets.only(bottom:8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: RaisedButton(

            color: Colors.white,
            textColor: primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _submitButtonText,
                style: TextStyle(fontSize: 20.0, color: Colors.blue),
              ),
            ),
            onPressed: submit,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(

          color: Colors.white,
          textColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(

              _switchButtonText,
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
          onPressed: () {
            switchFormState(_newFormState);
          },
        ),
      ),
      showForgotPassword(_showForgotPassword),

    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }
}