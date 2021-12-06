class Task {
  late int? id;
  late String title;
  late String note;
  late int isCompleted;
  late String date;
  late String startTime;
  late String endTime;
  late int color;
  late int remind;
  late String repeat;

  Task({
    this.id,
    required  this.title,
    required  this.note,
    required  this.isCompleted,
    required  this.date,
    required  this.startTime,
    required  this.endTime,
    required  this.color,
    required  this.remind,
    required  this.repeat,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['note'] = this.note;
    data['isCompleted'] = this.isCompleted;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['repeat'] = this.repeat;
    return data;
  }
}
