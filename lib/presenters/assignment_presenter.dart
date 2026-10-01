import '../models/assignment_model.dart';

class AssignmentPresenter {
  final List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  List<Assignment> searchAssignments(String query) {
    if(query.trim().isEmpty) {
      return _assignments;
    }

    return _assignments.where((assignment) {
      return assignment.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void _deleteAssignments(int index) {
      _assignments.removeWhere((assignment) => _assignments.contains(assignment),
    );
  }

  Future<void> loadAssignments() async {
    final fetched = await Assignment.fetchAssignments();
    _assignments
    ..clear()
    ..addAll(fetched);
  }

  Future<void> addAssignment(String title) async {
    await Assignment.addAssignment(title);
    _assignments.add(Assignment(title: title));
  }

  Future<void> toggleCompleted(Assignment assignment) async {
    final index = _assignments.indexOf(assignment);

    if (index == -1) return;

    await Assignment.updateCompletionStatus(index, _assignments);
    assignment.isCompleted = !assignment.isCompleted;
  }
}