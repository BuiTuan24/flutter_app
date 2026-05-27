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
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  DateTime? selectedDate;
  String gender = "male";

  bool obscurePass = true;
  bool obscureConfirmPass = true;

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ngày sinh")),
      );
      return;
    }

    context.read<AuthBloc>().add(
      RegisterSubmitted(
        fullName: fullNameController.text,
        phone: phoneController.text,
        email: emailController.text,
        password: passController.text,
        birthYear: selectedDate!.year,
        gender: gender,
        avatar: "",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
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
            if (state is AuthSuccess && mounted) {
              Navigator.pushReplacement(
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 10),

                _buildInput(
                  context: context,
                  controller: fullNameController,
                  label: "Họ tên",
                  validator: (v) =>
                  v == null || v.isEmpty ? "Nhập họ tên" : null,
                ),

                _buildInput(
                  context: context,
                  controller: phoneController,
                  label: "SĐT",
                  keyboard: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Nhập SĐT";
                    if (!RegExp(r'^[0-9]{9,11}$').hasMatch(v)) {
                      return "SĐT không hợp lệ";
                    }
                    return null;
                  },
                ),

                _buildInput(
                  context: context,
                  controller: emailController,
                  label: "Email",
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Nhập email";
                    if (!v.contains("@")) return "Email không hợp lệ";
                    return null;
                  },
                ),

                _buildInput(
                  context: context,
                  controller: passController,
                  label: "Mật khẩu",
                  obscure: obscurePass,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePass
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePass = !obscurePass;
                      });
                    },
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Nhập mật khẩu";
                    if (v.length < 6) return "Mật khẩu ≥ 6 ký tự";
                    return null;
                  },
                ),

                _buildInput(
                  context: context,
                  controller: confirmPassController,
                  label: "Nhập lại mật khẩu",
                  obscure: obscureConfirmPass,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirmPass
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirmPass = !obscureConfirmPass;
                      });
                    },
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Nhập lại mật khẩu";
                    }
                    if (v != passController.text) {
                      return "Mật khẩu không khớp";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      setState(() => selectedDate = picked);
                    }
                  },
                  child: Text(
                    selectedDate == null
                        ? "Chọn ngày sinh"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                  ),
                ),

                const SizedBox(height: 15),

                Text("Giới tính"),

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
                      setState(() => gender = value);
                    }
                  },
                ),

                const SizedBox(height: 20),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Đăng ký"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscure,
        keyboardType: keyboard,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.85),

          labelText: label,
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          suffixIcon: suffixIcon,

          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 1.5,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thành công")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Đăng ký thành công!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(),
                  ),
                      (route) => false,
                );
              },
              child: const Text("Hoàn thành"),
            ),
          ],
        ),
      ),
    );
  }
}