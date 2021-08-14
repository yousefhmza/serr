class PublicMessageModel {
  String? message;
  List<Result> result = [];

  PublicMessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    json['result'].forEach((element) {
      result.add(Result.fromJson(element));
    });
  }
}

class Result {
  String? comment;
  String? id;
  bool? isPublic;
  bool? isFavourite;
  String? userId;
  String? messageBody;
  String? date;

  Result.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    id = json['_id'];
    isPublic = json['isPublic'];
    isFavourite = json['isFavourite'];
    userId = json['userId'];
    messageBody = json['messageBody'];
    date = json['date'];
  }
}
