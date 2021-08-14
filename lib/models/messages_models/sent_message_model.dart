class SentMessageModel {
  String? message;
  List<Result> result = [];

  SentMessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    json['result'].forEach((element) {
      result.add(Result.fromJson(element));
    });
  }
}

class Result {
  String? id;
  bool? isPublic;
  bool? isFavourite;
  String? userId;
  String? messageBody;
  String? date;
  String? comment;
  String? receiverUserName;


  Result.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    isPublic = json['isPublic'];
    isFavourite = json['isFavourite'];
    userId = json['userId'];
    messageBody = json['messageBody'];
    date = json['date'];
    comment = json['comment'];
    receiverUserName = json['receiverUserName'];
  }
}
