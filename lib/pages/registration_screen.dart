import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picklaundry/services/auth_service.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() =>
      _RegistrationScreenState();
      
}

class _RegistrationScreenState
    extends State<RegistrationScreen> {

  final AuthService authService = AuthService();
  

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
      TextEditingController();

// final addressController =
//     TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool acceptTerms = false;
  
  String selectedRole = "Customer";


  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff07152F),
              Color(0xff1A1040),
              Color(0xff3F1E72),
            ],
          ),
        ),

        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),

                  child: Center(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(35),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 15,
                          sigmaY: 15,
                        ),

                        child: Container(
                          width: 500,
                          padding:
                              const EdgeInsets.all(25),

                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.08),

                            borderRadius:
                                BorderRadius.circular(
                                    35),

                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.15),
                            ),
                          ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .stretch,
                            children: [

                              const SizedBox(
                                  height: 10),

                              Center(
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape.circle,
                                    color: Colors.white
                                        .withOpacity(
                                            0.08),
                                  ),
                                  child: const Icon(
                                    Icons
                                        .local_laundry_service,
                                    size: 50,
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  height: 20),

                              Text(
                                "Create Account",
                                textAlign:
                                    TextAlign.center,
                                style:
                                    GoogleFonts.poppins(
                                  color:
                                      Colors.white,
                                  fontSize: 30,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 8),

                              Text(
                                "Join PickLaundry today",
                                textAlign:
                                    TextAlign.center,
                                style:
                                    GoogleFonts.poppins(
                                  color: Colors
                                      .white70,
                                ),
                              ),

                              const SizedBox(
                                  height: 30),
DropdownButtonFormField<String>(
  value: selectedRole,
  dropdownColor: const Color(0xff1A1040),
  style: const TextStyle(color: Colors.white),
  decoration: InputDecoration(
    labelText: "Account Type",
    labelStyle: const TextStyle(color: Colors.white70),
    prefixIcon: const Icon(
      Icons.person_outline,
      color: Colors.white70,
    ),
    filled: true,
    fillColor: Colors.white.withOpacity(0.08),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
    ),
  ),
  items: const [
    DropdownMenuItem(
      value: "Customer",
      child: Text("Customer"),
    ),
    DropdownMenuItem(
      value: "Delivery Partner",
      child: Text("Delivery Partner"),
    ),
    DropdownMenuItem(
      value: "Super Admin",
      child: Text("Super Admin"),
    ),
  ],
  onChanged: (value) {
    setState(() {
      selectedRole = value!;
    });
  },
),
const SizedBox(height: 15),

if (selectedRole == "Customer") ...[
  buildField(
    controller: fullNameController,
    label: "Full Name",
    icon: Icons.person,
  ),

  const SizedBox(height: 15),

  buildField(
    controller: emailController,
    label: "Email Address",
    icon: Icons.email_outlined,
  ),

  const SizedBox(height: 15),

  buildField(
    controller: mobileController,
    label: "Mobile Number",
    icon: Icons.phone,
  ),
],

if (selectedRole == "Delivery Partner") ...[
  buildField(
  controller: fullNameController,
  label: "Full Name",
  icon: Icons.person,
),
const SizedBox(height: 15),
buildField(
  controller: mobileController,
  label: "Mobile Number",
  icon: Icons.phone,
),
const SizedBox(height: 15),
buildField(
  controller: emailController,
  label: "Email Address",
  icon: Icons.email_outlined,
),


// const SizedBox(height: 15),

// buildField(
//   controller: addressController,
//   label: "Address",
//   icon: Icons.location_on_outlined,
// ),
const SizedBox(height: 15),
],

if (selectedRole == "Super Admin")
  Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.15),
      borderRadius:
          BorderRadius.circular(20),
    ),
    child: const Column(
      children: [

        Icon(
          Icons.admin_panel_settings,
          color: Colors.red,
          size: 60,
        ),

        SizedBox(height: 15),

        Text(
          "Super Admin Registration Disabled",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 10),

        Text(
          "Use authorized admin login credentials.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    ),
  ),
  
               const SizedBox(
                                  height: 10),
                              // buildField(
                              //   controller:
                              //       fullNameController,
                              //   label:
                              //       "Full Name",
                              //   icon:
                              //       Icons.person,
                              // ),

                              // const SizedBox(
                              //     height: 15),

                              // buildField(
                              //   controller:
                              //       emailController,
                              //   label:
                              //       "Email Address",
                              //   icon: Icons
                              //       .email_outlined,
                              // ),

                              // const SizedBox(
                              //     height: 15),

                              // buildField(
                              //   controller:
                              //       mobileController,
                              //   label:
                              //       "Mobile Number",
                              //   icon:
                              //       Icons.phone,
                              // ),

                              // const SizedBox(
                              //     height: 15),

                              buildPasswordField(
                                controller:
                                    passwordController,
                                label:
                                    "Password",
                                obscure:
                                    obscurePassword,
                                toggle: () {
                                  setState(() {
                                    obscurePassword =
                                        !obscurePassword;
                                  });
                                },
                              ),

                              const SizedBox(
                                  height: 15),

                              buildPasswordField(
                                controller:
                                    confirmPasswordController,
                                label:
                                    "Confirm Password",
                                obscure:
                                    obscureConfirmPassword,
                                toggle: () {
                                  setState(() {
                                    obscureConfirmPassword =
                                        !obscureConfirmPassword;
                                  });
                                },
                              ),


                              const SizedBox(
                                  height: 15),

                              CheckboxListTile(
                                value: acceptTerms,
                                activeColor:
                                    const Color(
                                        0xff00C896),
                                onChanged: (value) {
                                  setState(() {
                                    acceptTerms =
                                        value!;
                                  });
                                },
                                title: const Text(
                                  "I accept Terms & Conditions",
                                  style: TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity
                                        .leading,
                              ),

                              const SizedBox(
                                  height: 15),
const SizedBox(height: 20),

if (selectedRole != "Super Admin")
  SizedBox(
    height: 58,
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff00C896),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
     onPressed: () async {

  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (!acceptTerms) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Please accept Terms & Conditions",
        ),
      ),
    );

    return;
  }

  try {

    if (selectedRole == "Customer") {

      await authService.registerCustomer(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        mobile: mobileController.text.trim(),
        password: passwordController.text.trim(),
      );

    } else if (selectedRole ==
        "Delivery Partner") {

      await authService.registerPartner(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        mobile: mobileController.text.trim(),
        password: passwordController.text.trim(),
        
      );
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Registration Successful",
        ),
      ),
    );

    Navigator.pop(context);

  } catch (e) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
},
      child: Text(
        "REGISTER AS $selectedRole",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  ),

                              const SizedBox(
                                  height: 20),


                            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      "Already have an account?",
      style: TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
    ),

    TextButton(
      onPressed: () {
        Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const LoginScreen(),
  ),
);
      },
      child: const Text(
        "Login",
        style: TextStyle(
          color: Color(0xff00C896),
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
),

                           ]
                          ), // Column
                        ),   // Form
                      ),     // Container
                    ),       // BackdropFilter
                  ),         // ClipRRect
                ),           // Center
              ),             // ConstrainedBox
            );   
                         
            },
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style:
          const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white70,
        ),
        prefixIcon:
            Icon(icon, color: Colors.white70),
        filled: true,
        fillColor:
            Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style:
          const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white70,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.white70,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility
                : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: toggle,
        ),
        filled: true,
        fillColor:
            Colors.white.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(18),
        ),
      ),
    );
  }
}