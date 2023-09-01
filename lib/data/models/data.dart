class Data {
  String? id;
  final String name;
  final String role;
  final DateTime date;
  final String time;
  final String amount;
  final String? description;
  final String type;
  final String payment;

  Data(
      {this.id,
      required this.name,
      required this.role,
      required this.date,
      required this.time,
      required this.amount,
      required this.type,
      this.description,
      required this.payment});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json["_id"],
        name: json["name"],
        role: json["role"] ?? '',
        date: json["date"].toDate(),
        time: json["time"],
        amount: json["amount"],
        type: json["type"],
        payment: json["payment"],
        description: json["description"]);
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "role": role,
        "date": date,
        "time": time,
        "amount": amount,
        "description": description ?? '',
        "type": type,
        "payment": payment,
      };
}
