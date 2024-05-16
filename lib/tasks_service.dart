import 'dart:convert';
import 'package:http/http.dart' as http;
import 'task_model.dart';

String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InlvbG9zIiwic3ViIjoiNjY0NDk0ZDllMjE5Nzk1OTczMDhjNGI0IiwicGFzcyI6IiQyYSQxMCRKRC9Qbk9VMmhXRGhseExVMFdFUDFPVW8wLjEyVkt0UFlIL2RCYnVTaFRMbS9qQVRKaVpvTyIsImlhdCI6MTcxNTc3MDU4NSwiZXhwIjoxNzE1NzcyNjg1fQ.uOhfyRkmnvGlAeaHQO9FgUuLREXNIO43949EKHG2hYI";

class TaskService {
  Future<List<Task>> fetchTasks() async {
    const url =
        'http://taches-env.eba-s3zfdtr9.eu-west-3.elasticbeanstalk.com/task';
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> deleteTask(String id) async {
    final url = 'http://taches-env.eba-s3zfdtr9.eu-west-3.elasticbeanstalk.com/task/$id';
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  Future<void> createTask(String name, String description) async {
    final url = 'http://taches-env.eba-s3zfdtr9.eu-west-3.elasticbeanstalk.com/task';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'done': false,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTask(String id, String name, String description) async {
    final url = 'http://taches-env.eba-s3zfdtr9.eu-west-3.elasticbeanstalk.com/task/$id';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'done': false,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }
}
