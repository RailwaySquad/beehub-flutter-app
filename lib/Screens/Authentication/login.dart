import 'package:beehub_flutter_app/Provider/auth_provider.dart';
import 'package:beehub_flutter_app/Screens/Authentication/register.dart';
import 'package:beehub_flutter_app/Utils/page_navigator.dart';
import 'package:beehub_flutter_app/Utils/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  String? _emailValidator(String? value) {
    final validator = Validator(
        validators: [const RequiredValidator(), const EmailValidator()]);
    return validator.validate(label: 'Email', value: value);
  }

  String? _passwordValidator(String? value) {
    final validator = Validator(validators: [
      const RequiredValidator(),
      const MinLengthValidator(length: 6),
      const MaxLengthValidator(length: 30)
    ]);
    if (!_containsNumber(value)) return "Password required at least 1 number";
    return validator.validate(label: 'Password', value: value);
  }

  bool _containsNumber(String? value) {
    if (value == null || value.isEmpty) return false;
    return value.contains(RegExp(r'[0-9]'));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.white,
            Theme.of(context).colorScheme.inversePrimary,
          ])),
      child: Scaffold(backgroundColor: Colors.transparent, body: _page()),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              _title(),
              _loginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      'B E E H U B',
      style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 50),
          _inputField('Email', _email, validator: _emailValidator),
          const SizedBox(height: 20),
          _inputField('Password', _password,
              isPassword: true, validator: _passwordValidator),
          const SizedBox(height: 40),

          Consumer<AuthenticationProvider>( // Signin section
            builder: (context, auth, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (auth.resMessage != '') {
                  showMessage(message: auth.resMessage, context: context);
                  auth.clear(); // Clear the response message to avoid duplicate
                }
              });
              return _loginButton(
                  text: 'Sign in',
                  tap: () {
                    if (_formKey.currentState!.validate()) {
                      auth.loginUser(
                          email: _email.text,
                          password: _password.text,
                          context: context);
                    }
                  },
                  status: auth.isLoading);
            },
          ),

          const SizedBox(height: 20),
          _extraText(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _inputField(String labelText, TextEditingController controller,
      {isPassword = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          labelText: labelText),
      obscureText: isPassword,
    );
  }

  Widget _loginButton(
      {VoidCallback? tap,
      bool? status = false,
      String? text = 'Save',
      BuildContext? context}) {
    return ElevatedButton(
      onPressed: status == true ? null : tap,
      style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16)),
      child: SizedBox(
          width: double.infinity,
          child: Text(
            status == false ? text! : 'Please wait...',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          )),
    );
  }

  Widget _extraText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Not a member?",
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(width: 4),
        GestureDetector(
            onTap: () {
              PageNavigator(ctx: context).nextPage(page: const RegisterPage());
            },
            child: const Text("Register now",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)))
      ],
    );
  }
}
