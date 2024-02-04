// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:rest_api_todo_app/service/todo_service.dart';
import 'package:rest_api_todo_app/utils/todo_snackbar.dart';

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
        padding: const EdgeInsets.all(15.10),
        child: ListView(
          padding: const EdgeInsets.all(16.10),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.10),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  contentPadding: EdgeInsets.all(10.10),
                  border: InputBorder.none,
                ),
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  contentPadding: EdgeInsets.all(10.10),
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
                padding: const EdgeInsets.all(12.10),
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
      return;
    }
    final id = todo['_id'];

    //submit update data to the server//
    final isSuccess = await TodoService.updateTodoData(id, body);
    if (isSuccess) {
      showSuccessMessage(context, message: 'Successfully Upadated');
    } else {
      showErrorMessage(context, message: 'Update Failed');
    }
  }

  Future<void> dataSubmit() async {
    //submit the data to server//
    final isSuccess = await TodoService.addTodoData(body);

    //show success or fauiled message based on status//
    if (isSuccess) {
      showSuccessMessage(context, message: 'Successfully created');
    } else {
      showErrorMessage(context, message: 'Creation Filed');
    }
  }

  Map get body {
    //get the data from the server//
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}
