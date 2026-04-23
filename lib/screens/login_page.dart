import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bloc_auth/auth_bloc.dart';
import 'package:flutter_application_1/Bloc_auth/auth_event.dart';
import 'package:flutter_application_1/Bloc_auth/auth_state.dart';
import 'package:flutter_application_1/screens/detail_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  LoginPage({super.key}); // OTP

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {

              if (state is AuthSuccess) {
                final prefs = await SharedPreferences.getInstance();

                prefs.setInt("userId", state.userId);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen()),
                      (route) => false,
                );

              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
              child: Column(
            children: [
              SizedBox(height: 20),

              // Email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Password
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mật khẩu",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // OTP (mẫu thôi)
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: "Nhập OTP (mẫu, không check)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),

              // Button + Loading
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginSubmitted(
                          email: emailController.text,
                          password: passController.text,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Đăng nhập"),
                  );
                },
              ),
              SizedBox(height: 15),

              // Link Đăng ký
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Chưa có tài khoản? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: Text(
                      "Đăng ký ngay",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}