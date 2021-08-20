class SearchModel {
  String? message;
  List<Result> result = [];

  SearchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    json['result'].forEach((element) {
      result.add(Result.fromJson(element));
    });
  }
}

class Result {
  String? id;
  String? name;
  String? username;
  String? img;

  Result.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    username = json['username'];
    img = json['img'];
  }
}
