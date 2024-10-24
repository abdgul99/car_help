// import 'package:car_help_app/models/users.dart';
// import 'package:car_help_app/repo/user_profile.dart';
// import 'package:car_help_app/ui_helper/ui_helper.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class EditCredentials extends StatefulWidget {
//   EditCredentials({super.key, required this.userModel});
//   UserModel userModel;
//   @override
//   _EditCredentialsState createState() => _EditCredentialsState();
// }

// class _EditCredentialsState extends State<EditCredentials> {
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _nameController = TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     _emailController.text = widget.userModel.email;
//     _phoneController.text = widget.userModel.phoneNumber;
//     _nameController.text = widget.userModel.name;
//     super.initState();
//   }

//   // Method to show a dialog for editing a specific field
//   void _showEditDialog({
//     required String field,
//     required TextEditingController controller,
//     required String title,
//   }) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final _tempController = TextEditingController(text: controller.text);

//         return AlertDialog(
//           title: Text('Edit $title'),
//           content: TextFormField(
//             controller: _tempController,
//             decoration: InputDecoration(
//               labelText: title,
//               border: const OutlineInputBorder(),
//             ),
//             keyboardType: field == 'email'
//                 ? TextInputType.emailAddress
//                 : TextInputType.text,
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Save'),
//               onPressed: () {
//                 if (_tempController.text.isNotEmpty) {
//                   setState(() {
//                     controller.text = _tempController.text;
//                   });
//                 }
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Credentials'),
//         backgroundColor: Colors.amber.shade300,
//       ),
//       body: Consumer(builder: (context, ref, _) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildTextFormField(
//                 controller: _nameController,
//                 label: 'Name',
//                 prefixIcon: Icons.person,
//                 field: 'name',
//               ),
//               const SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _emailController,
//                 label: 'Email',
//                 prefixIcon: Icons.email,
//                 enabled: false,
//                 field: 'email',
//               ),
//               const SizedBox(height: 16),
//               _buildTextFormField(
//                 controller: _phoneController,
//                 label: 'Phone Number',
//                 prefixIcon: Icons.phone,
//                 field: 'phone',
//               ),
//               const SizedBox(height: 16),
//               Divider(),
//               Text("User Type:"),
//               Row(
//                 children: [
//                   Radio(
//                       value: widget.userModel.userType,
//                       groupValue: UserType.normalUser,
//                       onChanged: (v) {
//                         print(v);
//                         widget.userModel = widget.userModel
//                             .copyWith(userType: UserType.normalUser);
//                         setState(() {});
//                       }),
//                   Text("Normal User"),
//                   Radio(
//                       value: widget.userModel.userType,
//                       groupValue: UserType.serviceProvider,
//                       onChanged: (v) {
//                         widget.userModel = widget.userModel
//                             .copyWith(userType: UserType.serviceProvider);
//                         setState(() {});
//                       }),
//                   Text("Service Provider"),
//                 ],
//               ),
//               Divider(),
//               const SizedBox(height: 20),
//               LongButton(
//                 onPressed: () async {
//                   // Here you can handle form submission or other actions
//                   final user = widget.userModel.copyWith(
//                       name: _nameController.text,
//                       phoneNumber: _phoneController.text,
//                       modifiedAt: Timestamp.now());

//                   FirebaseFirestore.instance
//                       .collection("users")
//                       .doc(FirebaseAuth.instance.currentUser!.uid)
//                       .update(user.toMap())
//                       .whenComplete(() {
//                     ref.refresh(userProfileProvider.future);
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Credentials updated')),
//                   );
//                 },
//                 text: 'Save Changes',
//               ),
//               const SizedBox(height: 10),
//               LongButton(
//                 onPressed: () async {
//                   // Here you can handle form submission or other actions
//                   try {
//                     await FirebaseAuth.instance.sendPasswordResetEmail(
//                         email: widget.userModel.email.trim());
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                           content: Text(
//                               'Password Reset link is sent to ${widget.userModel.email}')),
//                     );
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(e.toString())),
//                     );
//                   }
//                 },
//                 text: 'Reset Password',
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     required IconData prefixIcon,
//     required String field,
//     bool? enabled,
//   }) {
//     return TextFormField(
//       controller: controller,
//       enabled: enabled,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(prefixIcon),
//         suffixIcon: IconButton(
//           icon: const Icon(Icons.edit),
//           onPressed: () => _showEditDialog(
//             field: field,
//             controller: controller,
//             title: label,
//           ),
//         ),
//         border: const OutlineInputBorder(),
//       ),
//       readOnly: true, // Make the field read-only
//     );
//   }
// }
