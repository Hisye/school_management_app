import 'package:school_management_app/models/student.dart';

class Result {
  late String id;
  late Student matricNo;
  late String subject;
  late int marks;

  Result(this.id, this.matricNo, this.subject, this.marks);
}