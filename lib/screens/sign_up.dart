import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bioController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  navigateToSignIn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void userSignUp() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().userSignUp(
      email: _emailController.text,
      password: _passwordController.text,
      userName: _userNameController.text,
      bio: _bioController.text,
      file: _image,
    );

    if (res != 'success') {
      if (!mounted) return;
      showSnakeBar(context, res);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 16,
              ),
              //svg instagram image
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                color: primaryColor,
                height: MediaQuery.sizeOf(context).height / 14,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 16,
              ),
              //circular widget to accept and show out accepted file
              Center(
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64, backgroundImage: MemoryImage(_image!))
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage(
                              "assets/pp.jpg",
                            ),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo_rounded),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 36,
              ),
              //text form field for user name
              CustomTextField(
                hintText: "Enter Your Full Name ",
                textEditingController: _userNameController,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 36,
              ),
              //text form field for email
              CustomTextField(
                hintText: "Enter Your Email ",
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 36,
              ),
              //text form field for password
              CustomTextField(
                hintText: "Enter Your Password ",
                textEditingController: _passwordController,
                textInputType: TextInputType.visiblePassword,
                isPass: true,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 36,
              ),
              //text field for user bio
              CustomTextField(
                hintText: "Enter Your Bio ",
                textEditingController: _bioController,
                textInputType: TextInputType.text,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 36,
              ),
              //login button
              InkWell(
                onTap: userSignUp,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 7,
              ),
              //transition to sign up/in screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Already hava an account?  ",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToSignIn,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Sign in.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
