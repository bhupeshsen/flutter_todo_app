class Todos {
  String id;
  String title;
  String description;
  bool completed = false;

  Todos({this.id, this.title, this.description, this.completed});

  Todos.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    description = json['Description'];
    completed = json.containsKey("Completed") ? json['Completed'] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Completed'] = this.completed;
    return data;
  }
}
