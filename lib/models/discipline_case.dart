import 'lecturer.dart';
import 'student.dart';

class DisciplineCase {
  late String id;
  late Student matricNo;
  late Lecturer staffId;
  late String description;
  late DateTime date;

  DisciplineCase(this.id, this.matricNo, this.staffId, this.description, this.date);
}