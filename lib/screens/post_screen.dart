import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void postImage(String uid, String username, String profImage) async {
    try {
      setState(() {
        isLoading = true;
      });
      String res = await FirestoreMethods().uploadPost(
          description: _descriptionController.text,
          uid: uid,
          file: _file!,
          profImage: profImage,
          username: username);
      setState(() {
        isLoading = false;
      });
      if (res == 'success') {
        showSnackBar(context, 'Posted');
        setState(() {
          isLoading = false;
        });
        clearImage();
      } else {
        showSnackBar(context, res);
        setState(() {
          isLoading = false;
        });
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? _user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
          child: IconButton(
            onPressed: () {
              _selectImage(context);
            },
            icon: const Icon(Icons.upload_rounded),
          ),
        )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => clearImage(),
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      postImage(_user!.uid, _user.username, _user.photoUrl),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(_user!.photoUrl),
                      // radius: 64,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        maxLines: 8,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write a caption'),
                        controller: _descriptionController,
                      ),
                    ),
                    SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                            image: MemoryImage(_file!),
                          )),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}
