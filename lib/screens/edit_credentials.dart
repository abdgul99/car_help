import 'package:car_help_app/ui_helper/ui_helper.dart';
import 'package:flutter/material.dart';

class EditCredentials extends StatefulWidget {
  const EditCredentials({super.key});

  @override
  _EditCredentialsState createState() => _EditCredentialsState();
}

class _EditCredentialsState extends State<EditCredentials> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnicController = TextEditingController();

  // Method to show a dialog for editing a specific field
  void _showEditDialog({
    required String field,
    required TextEditingController controller,
    required String title,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _tempController = TextEditingController(text: controller.text);

        return AlertDialog(
          title: Text('Edit $title'),
          content: TextFormField(
            controller: _tempController,
            decoration: InputDecoration(
              labelText: title,
              border: const OutlineInputBorder(),
            ),
            keyboardType: field == 'email'
                ? TextInputType.emailAddress
                : TextInputType.text,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                if (_tempController.text.isNotEmpty) {
                  setState(() {
                    controller.text = _tempController.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Credentials'),
        backgroundColor: Colors.amber.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextFormField(
              controller: _emailController,
              label: 'Email',
              prefixIcon: Icons.email,
              field: 'email',
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _phoneController,
              label: 'Phone Number',
              prefixIcon: Icons.phone,
              field: 'phone',
            ),
            const SizedBox(height: 16),
            _buildTextFormField(
              controller: _cnicController,
              label: 'CNIC',
              prefixIcon: Icons.credit_card,
              field: 'cnic',
            ),
            const SizedBox(height: 20),
            LongButton(
              onPressed: () {
                // Here you can handle form submission or other actions
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Credentials updated')),
                );
              },
              text: 'Save Changes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    required String field,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showEditDialog(
            field: field,
            controller: controller,
            title: label,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
      readOnly: true, // Make the field read-only
    );
  }
}
