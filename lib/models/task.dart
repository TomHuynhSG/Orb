class Task {
  late int? id;
  late String title;
  late String note;
  late int isCompleted;
  late String startDate;
  late String endDate;

  late int color;
  late int remind;
  late String repeat;

  Task({
    this.id,
    required  this.title,
    required  this.note,
    required  this.isCompleted,
    required  this.startDate,
    required  this.endDate,
    required  this.color,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['note'] = this.note;
    data['isCompleted'] = this.isCompleted;
    data['color'] = this.color;
    return data;
  }
}
