class ReportType{
  final int id;
  final String title;
  final String description;

  ReportType({required this.id, required this.title, required this.description});
  factory ReportType.fromJson(Map<String, dynamic> json){
    final id = json["id"];
    final title= json['title'];
    final description = json["description"];
    return ReportType(
      id: id, 
      title: title, 
      description: description);
  }
}