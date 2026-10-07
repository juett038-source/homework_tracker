import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';
import '../presenters/course_presenter.dart';
import '../widgets/add_fab.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _assignmentpresenter = AssignmentPresenter();
  final CoursePresenter _coursePresenter = CoursePresenter();

  bool _isLoading = true;
  String? _selectedCourseFilter;
  String? _newAssignmentCourse;
  List<String> _courseNames = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
  await _coursePresenter.loadCourses();
  await _assignmentpresenter.loadAssignments();
  if (!mounted) return;
  
  setState(() { 
    _isLoading = false;
    _courseNames = _coursePresenter.courses.map((c) => c.name).toList(); 
    });
}

  final Set<Map<String, dynamic>> _selectedAssignments = {};

  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';
    _newAssignmentCourse = _courseNames.isNotEmpty ? _courseNames.first : null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Assignment'),

          content: Column( 
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter assignment title'),
                onChanged: (value) {
                  newAssignmentTitle = value;
                },
          ),
          const SizedBox(height: 12),
          DropdownButton<String>(
            value: _newAssignmentCourse,
            items:
            _courseNames.map((name) {
              return DropdownMenuItem(value: name, child: Text(name));
            }).toList(),
            onChanged: (value) => setState(() => _newAssignmentCourse = value),
          ),
            ]
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newAssignmentTitle.trim().isNotEmpty && _newAssignmentCourse != null) {
                  await _assignmentpresenter.addAssignment(newAssignmentTitle.trim(),
                  _newAssignmentCourse!,
                  );
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    final assignments = _assignmentpresenter.searchAssignments(_searchQuery);
    final displayedAssignments = 
    _selectedCourseFilter == null
    ? assignments
    : assignments
    .where((a) => a.courseName == _selectedCourseFilter)
    .toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          if (_courseNames.isNotEmpty)
          DropdownButton<String>(
            hint: const Text(
              'Filter by course',
              style: TextStyle(color: Colors.white),
            ),
            dropdownColor: Colors.blue[100],
            value: _selectedCourseFilter,
            onChanged: (value) {
              setState(() {
                _selectedCourseFilter = value;
              });
            },
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('All Courses'),
              ),
              ..._courseNames.map(
                (name) => DropdownMenuItem(value: name, child: Text(name)),
              ),
            ],
          ),
        ],
      ),

      body: 
      _isLoading
      ? const Center(child: CircularProgressIndicator())
      : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search assignments...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
      Expanded(
        child: ListView.builder(
        itemCount: displayedAssignments.length,
        itemBuilder: (context, index) {
          final assignment = displayedAssignments[index];
          return CheckboxListTile(
            title: Text(assignment.title),
            subtitle: Text('Course: ${assignment.courseName}'),
            value: assignment.isCompleted,
            onChanged: (_) async {
              await _assignmentpresenter.toggleCompleted(assignment);
              setState(() {});
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: AddFAB(onPressed: _showAddAssignmentDialog),
    );
  }
}


