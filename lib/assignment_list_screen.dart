import 'package:flutter/material.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {

  final List<Map<String, dynamic>> _assignments = [];
  final Set<Map<String, dynamic>> _selectedAssignments = {};
  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Assignment'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter assignment title'),
            onChanged: (value) {
              newAssignmentTitle = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newAssignmentTitle.trim().isNotEmpty) {
                  setState(() {
                    _assignments.add({
                      'title': newAssignmentTitle.trim(),
                      'completed': false,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
  void _toggleCompleted(int index, bool? value) {
    setState(() {
      _assignments[index]['completed'] = value ?? false;
    });
  }
  void _deleteSelectedAssignments() {
    setState(() {
      _assignments.removeWhere((assignment) => _selectedAssignments.contains(assignment),
    );
    _selectedAssignments.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Delete Selected',
          onPressed: _selectedAssignments.isEmpty ? null : _deleteSelectedAssignments,
        ),
      ]
      ),
      body: ListView.builder(
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(_assignments[index]['title']),
            value: _assignments[index]['completed'],
            onChanged: (value) => _toggleCompleted(index, value),

            secondary: Checkbox(
              value: _selectedAssignments.contains(_assignments[index]),
              onChanged: (value) {
                setState(() {
                  if(value == true) {
                    _selectedAssignments.add(_assignments[index]);

                  }else {
                    _selectedAssignments.remove(_assignments[index]);
                  }
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssignmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
