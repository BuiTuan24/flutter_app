import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bloc_auth/auth_bloc.dart';
import 'package:flutter_application_1/Bloc_auth/auth_event.dart';
import 'package:flutter_application_1/Bloc_auth/auth_state.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  DateTime? selectedDate;
  String gender = "male";

  void submit() {
  if (selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Vui lòng chọn ngày sinh")),
    );
    return;
  }

  context.read<AuthBloc>().add(
    RegisterSubmitted(
      fullName: fullNameController.text,
      phone: phoneController.text,
      email: emailController.text,
      password: passController.text,
      birthYear: selectedDate!.year, // ✅ FIX
      gender: gender,
      avatar: "",
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng ký")),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 243, 244, 247),
              Color.fromARGB(255, 125, 134, 158),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SuccessPage(),
                ),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Column(
            children: [
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: "Họ tên"),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "SĐT"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Mật khẩu"),
              ),
            SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );

                  if (picked != null) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Text(
                  selectedDate == null
                      ? "Chọn ngày sinh"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                ),
              ),
              SizedBox(height: 10),

              /// ✅ Label + Dropdown
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Chọn giới tính",
                  style: TextStyle(color: const Color.fromARGB(255, 12, 12, 12), fontSize: 16),
                ),
              ),

              DropdownButton<String>(
                value: gender,
                isExpanded: true,
                items: ["male", "female", "other"]
                    .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(g),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      gender = value;
                    });
                  }
                },
              ),

              SizedBox(height: 20),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return CircularProgressIndicator();
                  }

                  return ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Đăng ký"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thành công")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              "Đăng ký thành công!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                /// quay về trang login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(),
                  ),
                  (route) => false,
                );
              },
              child: Text("Hoàn thành"),
            ),
          ],
        ),
      ),
    );
  }
}