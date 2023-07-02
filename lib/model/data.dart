

class Data {
   String? id;
  final String name;
  final DateTime date;
  final String time;
  final String amount;
  final String? description;
  final String type;
  final String payment;

  Data(
      { this.id,
      required this.name,
      required this.date,
      required this.time,
      required this.amount,
      required this.type,
      this.description,
      required this.payment});

  factory Data.fromJson(Map<String, dynamic> json) {
   // Timestamp timestampDate = json['date'] as Timestamp;
    
    return Data(
        id: json["_id"],
        name: json["name"],
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
        "date": date,
        "time": time,
        "amount": amount,
        "description": description ?? '',
        "type": type,
        "payment": payment,
      };
}
