class DisciplineCase {
  final String id;
  final String disciplineType;
  final String description;
  final String date; // Change the type to DateTime

  DisciplineCase({
    required this.id,
    required this.disciplineType,
    required this.description,
    required this.date,
  });
}