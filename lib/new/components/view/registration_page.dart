// import 'dart:io';
// import 'package:account_management/new/services/local_storage_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class RegistrationPage extends StatefulWidget {
//   final LocalAccountManager accountManager;

//   RegistrationPage({required this.accountManager});

//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }

// class _RegistrationPageState extends State<RegistrationPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   File? _profilePic;
//   bool _isRegistering = false;

 
//   Future<void> _registerUser() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty || _profilePic == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content:
//                 Text('Please fill all fields and select a profile picture')),
//       );
//       return;
//     }

//     setState(() {
//       _isRegistering = true;
//     });

//     try {
//       await widget.accountManager.registerUser(
//         email,
//         password,
//         profilePicPath: _profilePic?.path,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Registration successful!')),
//       );
//       Navigator.pop(context); // Go back to login page
//     } catch (e, sT) {
//       print(e.toString() + "stack Trace :: $sT");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     } finally {
//       setState(() {
//         _isRegistering = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Register')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             GestureDetector(
//               onTap: _pickProfilePicture,
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: _profilePic != null
//                     ? FileImage(_profilePic!)
//                     : AssetImage('assets/default_profile.png') as ImageProvider,
//                 child: _profilePic == null
//                     ? Icon(Icons.camera_alt, size: 30)
//                     : null,
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isRegistering ? null : _registerUser,
//               child: _isRegistering
//                   ? CircularProgressIndicator(color: Colors.white)
//                   : Text('Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
