import 'package:flutter/material.dart';


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
                  Navigator.pop(context);
                },
                child: const Text('Submit'))
          ],
        ),
      ),
    );
  }

  void dataSubmot() async {
    //get the data from the server//
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //submit the data to server//
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    // final response = await http.post(uri);
  }
}
