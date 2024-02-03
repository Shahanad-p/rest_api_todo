// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rest_api_todo_app/View/add_screen.dart';
import 'package:rest_api_todo_app/View/details.dart';
import 'package:rest_api_todo_app/service/todo_service.dart';
import 'package:rest_api_todo_app/utils/todo_snackbar.dart';
// import 'package:lottie/lottie.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> navigateToAddScreen() async {
    final route = MaterialPageRoute(builder: (context) => const AddScreen());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateToEditScreen(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddScreen(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: () => fetchData(),
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
                child: Lottie.asset('assets/Animation - 1703942875916.json',
                    height: 200, width: 200)),
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                            title: item['title'] ?? '',
                            description: item['description'] ?? '')));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 12, right: 12),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          item['title'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          item['description'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'edit') {
                              navigateToEditScreen(item);
                            } else if (value == 'delete') {
                              deleteById(id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddScreen,
        label: const Icon(Icons.add),
      ),
    );
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteTodoById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
      showSuccessMessage(context, message: 'Sucessfully Deleted');
    } else {
      showErrorMessage(context, message: 'Deletion Failed');
    }
  }

  Future<void> fetchData() async {
    final response = await TodoService.fetchTodoData();
    if (response != null) {
      setState(() {
        items = response;
      });
      showSuccessMessage(context, message: 'Successfully added');
    } else {
      showErrorMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
