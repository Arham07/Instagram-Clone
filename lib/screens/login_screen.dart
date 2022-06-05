import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/screens/signup_sceen.dart';
import '../resources/auth_method.dart';
import '../responsive_layout/mobile_screen_layout.dart';
import '../responsive_layout/responsive_layout_screen.dart';
import '../responsive_layout/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        password: _passwordController.text, email: _emailController.text);
    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobScreenLayout: MobScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      //
      showSnackBar(context, res);
    }
    setState(() {
      isLoading = false;
    });
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
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Password',
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                isPass: true,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              InkWell(
                onTap: loginUser,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Container(
                        child: const Text('Log In'),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.020,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: blueColor),
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
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Container(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account ?",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text: ' Sign Up',
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
