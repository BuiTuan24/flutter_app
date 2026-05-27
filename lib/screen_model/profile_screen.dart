import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen_model/theme_provider.dart';
import 'package:flutter_application_1/screens/change_password.dart';
import 'package:flutter_application_1/screens/support_page.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:provider/provider.dart';
class ProfileScreen extends StatelessWidget {

  final VoidCallback onReload;

  const ProfileScreen({
    super.key,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        // 🌄 Background image
        Positioned.fill(
          child: Opacity(
            opacity: 0.22,
            child: Image.asset(
              "assets/images/image4.png",
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 🔥 overlay
        Positioned.fill(
          child: Container(
            color: Theme
                .of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.45),
          ),
        ),

        // 📋 content
        ListView(
          padding: const EdgeInsets.all(16),
          children: [

            // Avatar card
            Card(
              elevation: 8,
              color: Theme
                  .of(context)
                  .cardColor
                  .withOpacity(0.82),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                ),

                child: Column(
                  children: const [

                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        size: 42,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      "Tài khoản",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Menu card
            Card(
              elevation: 8,

              color: Theme
                  .of(context)
                  .cardColor
                  .withOpacity(0.82),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text("Đổi mật khẩu"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangePasswordPage(),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.support_agent),
                    title: const Text("Trợ giúp & hỗ trợ"),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SupportPage(),
                        ),
                      );

                      if (result == true) {
                        onReload();
                      }
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Đăng xuất"),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginPage(),
                        ),
                            (route) => false,
                      );
                    },
                  ),

                  const Divider(height: 1),

                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode),
                    title: const Text("Dark Mode"),

                    value:
                    Provider
                        .of<ThemeProvider>(context)
                        .isDark,

                    onChanged: (_) {
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleTheme();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }}