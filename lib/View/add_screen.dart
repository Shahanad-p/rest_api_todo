import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  dataSubmot();
                  Navigator.pop(context);
                },
                child: const Text('Submit'))
          ],
        ),
      ),
    );
  }

  Future<void> dataSubmot() async {
    //get the data from the server//
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    //submit the data to server//
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //show success or fauiled message based on status//
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage('Creation Success');
    } else {
      showErrorMessage('Creation Filed');
    }
  }

  void showSuccessMessage(message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
