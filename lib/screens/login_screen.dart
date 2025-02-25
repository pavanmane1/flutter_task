import 'package:flutter/material.dart';
import 'package:flutter_task/provider/auth_provider.dart';
import 'package:flutter_task/provider/getcurrencyData_provider.dart';
import 'package:flutter_task/utils/app_colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false; // State variable

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final countryProvider = Provider.of<CountryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 250,
                child: const Text("Login", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500)),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 0),
                child: const Text(
                  "welcome Back ,lets login",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                ),
              ),
              const Divider(color: AppColors.textHint, thickness: 2, indent: 5, endIndent: 10),
              CustomTextInput(controller: emailController, hintText: "EmailAddress", isPassword: false),
              CustomTextInput(controller: passwordController, hintText: "Enter Youre Password", isPassword: true),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isChecked = newValue!;
                          });
                        },
                        activeColor: Colors.blue, // Checkbox color when checked
                      ),
                      const Text("Remember me"),
                    ],
                  ),
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: AppColors.textinfo),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0544CA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: authProvider.isLoading ? null : () => _login(authProvider, countryProvider),
                    child:
                        authProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Log In', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Container(
                margin: const EdgeInsets.only(left: 100),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Check Rates", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(
                      "Create a free account ",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Color(0xFF295ADF)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login(AuthProvider authProvider, CountryProvider countryProvider) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Email and Password cannot be empty!")));
      }
      return;
    }

    try {
      await authProvider.login(emailController.text, passwordController.text);

      if (authProvider.token != null) {
        // Fetch country data if userData is available
        if (authProvider.userData != null) {
          await countryProvider.fetchCountries(
            authProvider.userData!.clientID,
            authProvider.userData!.branchID,
            authProvider.userData!.countryID,
          );
          await countryProvider.fetchCountryRates(
            authProvider.userData!.clientID,
            authProvider.userData!.payoutCountryId,
            authProvider.userData!.clientID,
            authProvider.userData!.clientID,
            authProvider.userData!.stepComplete,
            "NGN",
            authProvider.userData!.branchID,
            authProvider.userData!.currencyID,
          );
        }

        // Ensure the widget is still mounted before navigating
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed: $error")));
      }
    }
  }
}

class CustomTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const CustomTextInput({super.key, required this.controller, required this.hintText, required this.isPassword});

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  bool _isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.all(15),
          suffixIcon:
              widget.isPassword
                  ? IconButton(
                    icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}
