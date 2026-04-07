import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_dashboard/screens/admin_shell.dart'; 

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color cityfixBlue = Color(0xFF2563EB); // Bleu vibrant de la photo
    const Color darkSidebar = Color(0xFF0F172A);
    const Color textGrey = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // --- PARTIE GAUCHE (LARGE) ---
          Expanded(
            flex: 65, 
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 23, 54, 157), 
                    Color.fromARGB(255, 31, 96, 235), 
                    Color(0xFF1E3A8A)
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_city, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("CityFix", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const Text("ADMIN CONSOLE", style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  // Texte Principal
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(fontSize: 56, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1),
                      children: const [
                        TextSpan(text: "Manage your "),
                        TextSpan(text: "city", style: TextStyle(color: Color(0xFFFBBF24))),
                        TextSpan(text: "\nsmarter & faster."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(
                    width: 500,
                    child: Text(
                      "Track civic reports, monitor infrastructure issues, and coordinate city-wide resolutions — all from a single powerful dashboard.",
                      style: TextStyle(color: Colors.white70, fontSize: 18, height: 1.6),
                    ),
                  ),
                  const Spacer(),
                  // Stats en bas
                  Row(
                    children: [
                      _buildStatItem("864", "Total Reports"),
                      const SizedBox(width: 60),
                      _buildStatItem("78%", "Resolution Rate"),
                      const SizedBox(width: 60),
                      _buildStatItem("58", "Wilayas"),
                    ],
                  )
                ],
              ),
            ),
          ),

          // --- PARTIE DROITE (FORMULAIRE) ---
          Expanded(
            flex: 35, // 3.5/10 de l'écran
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome back 👋", style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w800, color: darkSidebar)),
                  const SizedBox(height: 10),
                  const Text("Sign in to the CityFix admin portal to continue.", style: TextStyle(color: textGrey, fontSize: 15)),
                  const SizedBox(height: 48),

                  const Text("Email address", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: darkSidebar)),
                  const SizedBox(height: 10),
                  _buildInput(
                    hint: "email address", 
                    icon: Icons.email_outlined,
                    controller: _emailController,
                  ),
                  
                  const SizedBox(height: 24),

                  const Text("Password", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: darkSidebar)),
                  const SizedBox(height: 10),
                  _buildInput(
                    hint: "password", 
                    icon: Icons.lock_outline, 
                    isPassword: true,
                    controller: _passwordController,
                    suffix: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: textGrey),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    )
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: Checkbox(
                              value: _rememberMe, 
                              onChanged: (v) => setState(() => _rememberMe = v!),
                              activeColor: cityfixBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text("Remember me", style: TextStyle(color: textGrey, fontSize: 14)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {}, 
                        child: const Text("Forgot password?", style: TextStyle(color: cityfixBlue, fontWeight: FontWeight.w600, fontSize: 14))
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),

                  // BOUTON COMME SUR LA PHOTO
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: cityfixBlue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_emailController.text == "admin@cityfix.dz" && _passwordController.text == "admin123") {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminShell()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect credentials")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cityfixBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.login_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Text("Sign in to Dashboard", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  // Demo credentials
                  Center(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: textGrey, fontSize: 12),
                        children: [
                          TextSpan(text: "Demo credentials: "),
                          TextSpan(text: "admin@cityfix.dz / admin123", style: TextStyle(color: darkSidebar, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildInput({required String hint, required IconData icon, bool isPassword = false, Widget? suffix, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF64748B)),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
    );
  }
}