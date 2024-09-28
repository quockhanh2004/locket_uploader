import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app/app_cubit.dart';
import '../constants/constants.dart';

class LoginScreen extends StatelessWidget {
  static const route = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreenView();
  }
}

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final usernameFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  late var _autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<AppCubit, AppState>(
        listener: (context, state) {
          if (state is AuthenticationLoading) {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          } else if (state is AuthenticationSuccess) {
            Navigator.pop(context);
          } else if (state is AuthenticationFailure) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${state.message}"),
              ),
            );
          }
        },
        child: SafeArea(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTextTitle(),
          _buildFormLogin(),
          const SizedBox(height: 20),
          _buildFormPassword(),
          _buildLoginButton(),
          _buildResetPasswordButton(),
          _buildInformationApp(),
        ],
      ),
    );
  }

  Widget _buildTextTitle() {
    return const Text(
      'Login',
      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
    );
  }

  Widget _buildFormPassword() {
    return Form(
      key: passwordFormKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Password",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: _passwordTextController,
              obscureText: true,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
                }
                if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(Constants.yellowColor), width: 2.0),
                ),
                hintText: "Enter your password",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _login();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(Constants.yellowColor),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        child: const Text(
          "Login",
          style: TextStyle(color: Color(0xff1f1d1a), fontSize: 22, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _buildFormLogin() {
    return Form(
      key: usernameFormKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: _emailTextController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                }
                final emailValid = RegExp(
                  Constants.emailRegex,
                ).hasMatch(value);
                if (!emailValid) {
                  return "Please enter a valid email";
                }
                return null;
              },
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(Constants.yellowColor), width: 2.0),
                ),
                hintText: "Enter your email",
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                fillColor: Colors.grey.withOpacity(0.2),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationApp() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: const Text(
        "",
        style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _buildResetPasswordButton(){
    return Container(
      margin: const EdgeInsets.only(top: 30),
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _resetPassword();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(0.2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        child: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  void _login() async {
    if (_autoValidateMode == AutovalidateMode.disabled) {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
    final isEmailValid = usernameFormKey.currentState?.validate() ?? false;
    final isPasswordValid = passwordFormKey.currentState?.validate() ?? false;
    final isValid = isEmailValid && isPasswordValid;
    if (!isValid) {
      return;
    } else {
      final email = _emailTextController.text;
      final password = _passwordTextController.text;
      try {
        context.read<AppCubit>().login(email, password);
      } catch (error) {
        print(error.toString());
        return null;
      }
    }
  }

  void _resetPassword(){
    final isEmailValid = usernameFormKey.currentState?.validate() ?? false;
    final isValid = isEmailValid;
    if (!isValid) {
      return;
    } else {
      final email = _emailTextController.text;
      try {
        context.read<AppCubit>().resetPassword(email);
        // Show a SnackBar or a Dialog indicating success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset request sent successfully')),
        );
      } catch (error) {
        print(error.toString());
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send password reset request')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<AppCubit>().autoLogin();
  }
}
