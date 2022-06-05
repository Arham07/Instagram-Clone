import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../resources/auth_method.dart';
import '../utils/utils.dart';

class EditProfile extends StatefulWidget {
  final String uid;

  const EditProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  Uint8List? image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  var userData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_outlined),
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Stack(
                      children: [
                        image != null
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(image!),
                                radius: 64,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userData['photoUrl'],
                                ),
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
                        )
                      ],
                    ),
                    buildTextFormField(
                      _nameController,
                      userData['username'],
                      'Enter your name',
                      TextInputAction.next,
                      TextInputType.name,
                      const Icon(Icons.email),
                    ),
                    buildTextFormField(
                      _bioController,
                      userData['bio'],
                      'Enter your bio',
                      TextInputAction.next,
                      TextInputType.name,
                      const Icon(Icons.laptop_chromebook_outlined),
                    ),
                    buildTextFormField(
                      _emailController,
                      userData['email'],
                      'Enter valid email',
                      TextInputAction.next,
                      TextInputType.emailAddress,
                      const Icon(Icons.email),
                    ),
                    buildTextFormField(
                      _passController,
                      userData['password'],
                      'Password should contain 7 character',
                      TextInputAction.done,
                      TextInputType.text,
                      const Icon(Icons.password),
                    ),
                    InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        AuthMethods().updateData(
                            _nameController.text,
                            _bioController.text,
                            _emailController.text,
                            _passController.text,
                            image!);
                        // setState(() {
                        //   Navigator.of(context).pop();
                        // });
                        showSnackBar(context, 'Updated');
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.blueAccent),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: const Text(
                          'update',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Form buildTextFormField(
      TextEditingController controller,
      String hintText,
      String validatorError,
      TextInputAction action,
      TextInputType type,
      Icon icon) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          textInputAction: action,
          keyboardType: type,
          decoration: InputDecoration(
              prefixIcon: icon,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderSide: Divider.createBorderSide(context),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white)),
          controller: controller,
          validator: (controller) {
            if (controller != null && controller.length < 7) {
              return validatorError;
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}
