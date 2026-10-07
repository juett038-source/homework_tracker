import '../models/course_model.dart';

class CoursePresenter {
  final List<Course> _courses = [];

  List<Course> get courses => _courses;

  List<Course> searchCourses(String query) {
    if(query.trim().isEmpty) {
      return _courses;
    }
    
    return _courses.where((courses) {
      final nameMatches = courses.name.toLowerCase().contains(query.toLowerCase());
      final descriptionMatches = courses.description?.toLowerCase().contains(query.toLowerCase()) ?? false;
      return nameMatches || descriptionMatches;
    }).toList();
  }

  Future<void> loadCourses() async {
    final fetched = await Course.fetchCourses();
    _courses
    ..clear()
    ..addAll(fetched);
  }


  Future<void> addCourse(String name, String? description) async {
    await Course.addCourse(name, description);
    _courses.add(Course(name: name, description: description));
  }

  
    void updateCourse(int index, String newName, String? newDescription) {
        _courses[index].name = newName;
        _courses[index].description = newDescription;
      
    }
}