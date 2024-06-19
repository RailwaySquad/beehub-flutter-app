import 'package:beehub_flutter_app/Provider/auth_provider.dart';
import 'package:beehub_flutter_app/Screens/Authentication/login.dart';
import 'package:beehub_flutter_app/Utils/page_navigator.dart';
import 'package:beehub_flutter_app/Utils/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/form_validation.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  String? _usernameValidator(String? value) {
    final validator = Validator(validators: [
      const RequiredValidator(),
      const MinLengthValidator(length: 6),
      const MaxLengthValidator(length: 20)
    ]);
    return validator.validate(label: 'Username', value: value);
  }

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

  String? _confirmValidator(String? value) {
    final validator = Validator(validators: [const RequiredValidator()]);
    if (_password.text != _confirm.text)
      return "Password confirm does not match";
    return validator.validate(label: 'Confirm', value: value);
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
              _registerForm(),
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

  Widget _registerForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 50),
          _inputField('Username', _username, validator: _usernameValidator),
          const SizedBox(height: 20),
          _inputField('Full name', _fullName, validator: _usernameValidator),
          const SizedBox(height: 20),
          _inputField('Email', _email, validator: _emailValidator),
          const SizedBox(height: 20),
          _inputField('Password', _password,
              isPassword: true, validator: _passwordValidator),
          const SizedBox(height: 20),
          _inputField('Confirm', _confirm,
              isPassword: true, validator: _confirmValidator),
          const SizedBox(height: 40),
          Consumer<AuthenticationProvider>(
            // Signin section
            builder: (context, auth, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (auth.resMessage != '') {
                  showMessage(message: auth.resMessage, context: context);
                  auth.clear(); // Clear the response message to avoid duplicate
                }
              });
              return _registerButton(
                  text: 'Sign up',
                  tap: () {
                    if (_formKey.currentState!.validate()) {
                      auth.registerUser(
                          username: _username.text,
                          fullName: _fullName.text,
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

  Widget _registerButton(
      {VoidCallback? tap,
      bool? status = false,
      String? text = 'Sign up',
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
          "Already have an account?",
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(width: 4),
        GestureDetector(
            onTap: () {
              PageNavigator(ctx: context).nextPage(page: const LoginPage());
            },
            child: const Text("Signin now",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)))
      ],
    );
  }
}
