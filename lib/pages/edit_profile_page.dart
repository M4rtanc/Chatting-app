import 'package:chat_app/models/app_user.dart';
import 'package:chat_app/services/app_user_service.dart';
import 'package:chat_app/services/edit_profile_service.dart';
import 'package:chat_app/services/profile_image_service.dart';
import 'package:chat_app/shared/ioc_container.dart';
import 'package:chat_app/widgets/app_drawer.dart';
import 'package:chat_app/widgets/profile_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/authentication_service.dart';
import '../shared/const.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _auth = get<AuthenticationService>();
  final _appUserService = get<AppUserService>();
  final _profileImageService = get<ProfileImageService>();
  final _newUsernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  Image? _currentProfileImage;
  XFile? _selectedImage;

  @override
  initState() {
    super.initState();
    _initNewUsernameController();
    _initCurrentProfileImage();
    print("initState Called");
  }

  @override
  void dispose() {
    _newUsernameController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Edit profile"),
          centerTitle: true,
        ),
        body: Padding(
              padding: const EdgeInsets.all(BIG_PADDING),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: Container()),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: MEDIUM_PADDING,
                            ),
                            child: Column(
                              children: [
                                _selectedImage != null ?
                                FutureBuilder(
                                    future: _selectedImage!.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Image.memory(snapshot.data!, height: 120, width: 120);
                                      }
                                      return const Text("No data1");
                                    }) : FutureBuilder(
                                    future: _profileImageService.getCurrentProfImage(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Image.network(snapshot.data!, height: 120, width: 120);
                                      }
                                      if (snapshot.hasError) {
                                        return const Text("getCurrentProfImage(): error");
                                      }
                                      return const Text("No data2");
                                    }),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () => _selectImage(),
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () => setState(() {
                                        _selectedImage = null;
                                      }),
                                      icon: const Icon(Icons.refresh),
                                    ),
                                  ],
                                )
                              ],
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: MEDIUM_PADDING,
                          ),
                          child: TextField(
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(OPACITY),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: "Edit username"),
                              controller: _newUsernameController),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: MEDIUM_PADDING,
                            ),
                            child: TextFormField(
                              //enabled: false,
                                autovalidateMode: AutovalidateMode.always,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(OPACITY),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    labelText: "Enter new password"),
                                validator: (value) {
                                  if (value != null && value != "" && value.length < 6) {
                                    return "Password must have at least 6 characters";
                                  }
                                  if (value != null && value != "" && !value.contains(RegExp(r"[A-Z]"))) {
                                    return "Password must contain at least 1 UPPER CASE character A-Z";
                                  }
                                  if (value != null && value != "" && !value.contains(RegExp(r"[0-9]"))) {
                                    return "Password must contain at least 1 number 0-9";
                                  }
                                  return null;
                                },
                                controller: _newPasswordController)),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: MEDIUM_PADDING,
                            ),
                            child: TextFormField(
                                autovalidateMode: AutovalidateMode.always,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(OPACITY),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: "Confirm new password",
                                ),

                                validator: (value) {
                                  if (_confirmNewPasswordController.text != _newPasswordController.text) {
                                    print("validator value: $value");
                                    return "Passwords are different";
                                  }
                                  return null;
                                },
                                controller: _confirmNewPasswordController)),
                        Expanded(child: Container()),
                        FilledButton(
                            onPressed: () {
                              if (_isValid(_newPasswordController.text) &&
                                  _newPasswordController.text == _confirmNewPasswordController.text) {
                                _onSubmitChanges();
                                const successSnackBar = SnackBar(
                                  content: Text("Changes saved"),
                                  backgroundColor: Colors.green,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
                              } else {
                                const failureSnackBar = SnackBar(
                                  content: Text("New password is not valid or is not confirmed correctly"),
                                  backgroundColor: Colors.red,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(failureSnackBar);
                              }
                            },
                            //onPressed: _openPasswordInput,
                            child: const Text("Save changes")),
                      ],
                    )
                  ),
                ],
              )
              // child: Column(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: [
              //     Expanded(child: Container()),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(
              //         vertical: MEDIUM_PADDING,
              //       ),
              //       child: Column(
              //         children: [
              //           _selectedImage != null ?
              //               FutureBuilder(
              //               future: _selectedImage!.readAsBytes(),
              //               builder: (context, snapshot) {
              //                 if (snapshot.hasData) {
              //                   return Image.memory(snapshot.data!, height: 120, width: 120);
              //                 }
              //                 return const Text("No data1");
              //               }) : FutureBuilder(
              //               future: _profileImageService.getCurrentProfImage(),
              //               builder: (context, snapshot) {
              //                 if (snapshot.hasData) {
              //                   return Image.network(snapshot.data!, height: 120, width: 120);
              //                 }
              //                 if (snapshot.hasError) {
              //                   return const Text("getCurrentProfImage(): error");
              //                 }
              //                 return const Text("No data2");
              //               }),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               IconButton(
              //                 onPressed: () => _selectImage(),
              //                 icon: const Icon(Icons.edit),
              //               ),
              //               IconButton(
              //                 onPressed: () => setState(() {
              //                   _selectedImage = null;
              //                 }),
              //                 icon: const Icon(Icons.refresh),
              //               ),
              //             ],
              //           )
              //         ],
              //       )
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(
              //         vertical: MEDIUM_PADDING,
              //       ),
              //       child: TextField(
              //           decoration: InputDecoration(
              //               filled: true,
              //               fillColor: Colors.grey.withOpacity(OPACITY),
              //               border: const OutlineInputBorder(
              //                 borderSide: BorderSide.none,
              //               ),
              //               labelText: "Edit username"),
              //           controller: _newUsernameController),
              //     ),
              //     Padding(
              //         padding: const EdgeInsets.symmetric(
              //           vertical: MEDIUM_PADDING,
              //         ),
              //         child: TextFormField(
              //             //enabled: false,
              //             autovalidateMode: AutovalidateMode.always,
              //             obscureText: true,
              //             enableSuggestions: false,
              //             autocorrect: false,
              //             decoration: InputDecoration(
              //                 filled: true,
              //                 fillColor: Colors.grey.withOpacity(OPACITY),
              //                 border: const OutlineInputBorder(
              //                   borderSide: BorderSide.none,
              //                 ),
              //                 labelText: "Enter new password"),
              //             validator: (value) {
              //               if (value != null && value != "" && value.length < 6) {
              //                 return "Password must have at least 6 characters";
              //               }
              //               if (value != null && value != "" && !value.contains(RegExp(r"[A-Z]"))) {
              //                 return "Password must contain at least 1 UPPER CASE character A-Z";
              //               }
              //               if (value != null && value != "" && !value.contains(RegExp(r"[0-9]"))) {
              //                 return "Password must contain at least 1 number 0-9";
              //               }
              //               return null;
              //             },
              //             controller: _newPasswordController)),
              //     Padding(
              //         padding: const EdgeInsets.symmetric(
              //           vertical: MEDIUM_PADDING,
              //         ),
              //         child: TextFormField(
              //             autovalidateMode: AutovalidateMode.always,
              //             obscureText: true,
              //             enableSuggestions: false,
              //             autocorrect: false,
              //             decoration: InputDecoration(
              //                 filled: true,
              //                 fillColor: Colors.grey.withOpacity(OPACITY),
              //                 border: const OutlineInputBorder(
              //                   borderSide: BorderSide.none,
              //                 ),
              //                 labelText: "Confirm new password",
              //             ),
              //
              //             validator: (value) {
              //               if (_confirmNewPasswordController.text != _newPasswordController.text) {
              //                 print("validator value: $value");
              //                 return "Passwords are different";
              //               }
              //               return null;
              //             },
              //             controller: _confirmNewPasswordController)),
              //     Expanded(child: Container()),
              //     FilledButton(
              //         onPressed: () {
              //           if (_isValid(_newPasswordController.text) &&
              //               _newPasswordController.text == _confirmNewPasswordController.text) {
              //             _onSubmitChanges();
              //             const successSnackBar = SnackBar(
              //               content: Text("Changes saved"),
              //               backgroundColor: Colors.green,
              //             );
              //             ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
              //           } else {
              //             const failureSnackBar = SnackBar(
              //               content: Text("New password is not valid or is not confirmed correctly"),
              //               backgroundColor: Colors.red,
              //             );
              //             ScaffoldMessenger.of(context).showSnackBar(failureSnackBar);
              //           }
              //         },
              //         //onPressed: _openPasswordInput,
              //         child: const Text("Save changes")),
              //   ],
              // ),
            ),
    );
  }

  bool _isValid(String password) {
    if (password == "" ||
        (password.length >= 6 &&
            password.contains(RegExp(r"[A-Z]")) &&
            password.contains(RegExp(r"[0-9]"))
        )) {
      return true;
    }
    return false;
  }

  Future<void> _selectImage() async {
    final file = await ImagePicker().pickImage( // to avoid async setState() error
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    setState(() {
      _selectedImage = file;
    });
  }

  Future<void> _initNewUsernameController() async {
    final String userName = (await _appUserService.getCurrentUser()).username;
    _newUsernameController.text = userName;
  }

  Future<void> _initCurrentProfileImage() async {
    _currentProfileImage = Image.network(await _profileImageService.getCurrentProfImage(), height: 120, width: 120);
  }

  Future<void> _onSubmitChanges() async {
    final String newUserName = _newUsernameController.text;
    final String newPassword = _newPasswordController.text;
    String newUrl = "";

    if (_selectedImage != null) {
      //final newProfileImage = File.fromRawPath(await _selectedImage!.readAsBytes());
      newUrl = await _profileImageService.updateCurrentUserImage(_selectedImage!);
    }
    print("running _appUserService.editeUserProfile");
    _appUserService.editeUserProfile(newUrl, newUserName, newPassword);
    return;
  }
}
