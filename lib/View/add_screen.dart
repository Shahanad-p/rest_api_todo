import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddScreen extends StatefulWidget {
  final Map? todo;
  const AddScreen({super.key, this.todo});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final fillTodo = widget.todo;
    if (fillTodo != null) {
      isEdit = true;
      final title = fillTodo['title'];
      final description = fillTodo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
    if (widget.todo != null) {
      isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
                minLines: 4,
                maxLines: 5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                isEdit ? dataEdit() : dataSubmit();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(isEdit ? 'Update' : 'Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> dataEdit() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call update without todo data');
      return;
    }
    final id = todo['_id'];
    // final isCompleted = todo['is_Completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //submit update data to the server//
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage('Update Success');
    } else {
      showErrorMessage('Update Failed');
    }
  }

  Future<void> dataSubmit() async {
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
