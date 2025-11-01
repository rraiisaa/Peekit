import 'package:flutter/material.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/utils/validators.dart';
import 'package:peekit_app/auth/components/auth_button.dart';
import 'package:peekit_app/auth/components/auth_form_field.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); 
  final _emailController = TextEditingController(); 
  final _passwordController = TextEditingController(); 
  final _confirmPasswordController = TextEditingController(); 

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Text(
              "Hoolaa! Make a New Account",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Peek the World!",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthFormField(
                    controller: _nameController,
                    label: "Full Name",
                    hintText: "Enter your full name",
                    validator: Validators.validateFullName,
                  ),
                  SizedBox(height: 20),
                  AuthFormField(
                    controller: _emailController,
                    label: "Email",
                    hintText: "Enter your Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(height: 20),
                  AuthFormField(
                    controller: _passwordController,
                    label: "Password",
                    hintText: "Enter your Password",
                    obscureText: true,
                    suffixIcon: Icon(Icons.visibility),
                    validator: Validators.validatePassword,
                  ),
                  SizedBox(height: 20),
                  AuthFormField(
                    controller: _confirmPasswordController,
                    label: "Confirm Password",
                    hintText: "Re-enter your password",
                    obscureText: true,
                    suffixIcon: Icon(Icons.visibility),
                    validator: (value) => Validators.validateConfirmPassword(
                      value,
                      _passwordController.text
                    ),
                  ),
                  SizedBox(height: 50),
                  AuthButton(
                    text: "Register",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacementNamed(context, Routes.HOME);
                      }
                    },
                    backgroundColor: AppColors.primary,
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: AppColors.textPrimary
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: Text("Login"),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}