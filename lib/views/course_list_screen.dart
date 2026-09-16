import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';
import '../presenters/course_presenter.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}
class _CourseListScreenState extends State<CourseListScreen> {
    final CoursePresenter presenter = CoursePresenter();

    void _showAddCourseDialog() {
      String name = '';
      String? description = '';
      
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Course'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Course Name'),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Course Description'),
                  onChanged: (value) => description = value,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (name.trim().isNotEmpty) {
                    setState(() {
                      presenter.addCourse(name.trim(), description);
                    });
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


    void showChangeCourseNameDialog(int index) {
      String newName = presenter.courses[index].name;
      String? newDescription = presenter.courses[index].description;
      
      showDialog(
         context: context,
         builder: (context) {
          return AlertDialog(
            title: const Text('Change Course Name'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(label: Text('New Course Name')),
                  onChanged: (value) => newName = value,
                ),
                TextField(
                  decoration: const InputDecoration(label: Text('New Course Description')),
                  onChanged: (value) => newDescription = value,
                ),
              ]
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (newName.trim().isNotEmpty) {
                    setState(() {
                      presenter.updateCourse(index, newName.trim(), newDescription);
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              )
            ]
          );
         });
    }

    @override
    Widget build(BuildContext context) {
      final courses = presenter.courses;

      return Scaffold(
        appBar: AppBar(title: const Text('Courses')),
        body: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return ListTile(
              title: Text(course.name),
              subtitle: course.description != null ? Text(course.description!) : null,
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => showChangeCourseNameDialog(index),
              )
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddCourseDialog,
          child: const Icon(Icons.add),
        ),
      );
    }
  }