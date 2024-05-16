import 'package:flutter/material.dart';
import 'tasks_service.dart';
import 'task_card.dart';
import 'task_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = TaskService().fetchTasks();
  }

  void _refreshTasks() {
    setState(() {
      futureTasks = TaskService().fetchTasks();
    });
  }

  void _handleDelete(String id) {
    setState(() {
      futureTasks = futureTasks.then((tasks) => tasks.where((task) => task.id != id).toList());
    });
  }

  void _handleEdit(Task updatedTask) {
    setState(() {
      futureTasks = futureTasks.then((tasks) {
        int index = tasks.indexWhere((task) => task.id == updatedTask.id);
        if (index != -1) {
          tasks[index] = updatedTask;
        }
        return tasks;
      });
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String taskName = '';
        String taskDescription = '';

        return AlertDialog(
          title: Text('Ajouter une nouvelle tâche'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nom de la tâche'),
                onChanged: (value) {
                  taskName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  taskDescription = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Ajouter'),
              onPressed: () async {
                try {
                  await TaskService().createTask(taskName, taskDescription);
                  _refreshTasks();
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add task: $e')),
                  );
                }
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
        title: Text('Task List'),
      ),
      body: FutureBuilder<List<Task>>(
        future: futureTasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Tasks found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: snapshot.data![index],
                  onDelete: _handleDelete,
                  onEdit: _handleEdit,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Ajouter une tâche',
        child: Icon(Icons.add),
      ),
    );
  }
}
