import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../resources/auth_method.dart';
import '../responsive_layout/mobile_screen_layout.dart';
import '../responsive_layout/responsive_layout_screen.dart';
import '../responsive_layout/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  void singupUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: image!);
    setState(() {
      isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobScreenLayout: MobScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'assets/images/instagram.svg',
                height: 120,
                color: primaryColor,
              ),
              Stack(
                children: [
                  image != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(image!),
                          radius: 64,
                        )
                      : const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://www.planetware.com/wpimages/2020/02/france-in-pictures-beautiful-places-to-photograph-eiffel-tower.jpg'),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                      onPressed: () {
                        selectImage();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter your name',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Password',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                isPass: true,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              InkWell(
                onTap: singupUser,
                child: Container(
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.020,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), color: blueColor),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Divider(
                    height: MediaQuery.of(context).size.height * 0.0001,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account ?",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text: ' Log In',
                              style: TextStyle(
                                  color: blueColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
