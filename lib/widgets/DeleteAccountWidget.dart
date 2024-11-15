import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rpgl/bases/api/deleteaccount.dart';
import 'package:rpgl/bases/api/ownerLogin.dart';
import 'package:rpgl/bases/webservice.dart';
import 'package:rpgl/screens/home_screen.dart';

class DeleteAccountWidget extends StatefulWidget {
  final String memberId;

  const DeleteAccountWidget({Key? key, required this.memberId})
      : super(key: key);

  @override
  _DeleteAccountWidgetState createState() => _DeleteAccountWidgetState();
}

class _DeleteAccountWidgetState extends State<DeleteAccountWidget> {
  bool _isLoading = false;

  // Method to delete account using API
  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DeleteAccountAPI response =
          await DeleteAccountAPI.deleteaccount(widget.memberId);

      setState(() {
        _isLoading = false;
      });

      // Check the status from the response and show appropriate feedback
      if (response.processStatus == 'YES') {
        _showMessage('Account deleted successfully');
        await OwnerLoginAPI.deleteAllData();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } else {
        _showMessage(response.processMessage ?? 'Failed to delete account');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showMessage('Error occurred: $e');
    }
  }

  // Helper method to show a Snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isLoading ? null : _deleteAccount,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Delete Account',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
