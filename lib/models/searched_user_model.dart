class SearchedUserModel {
  String? img;
  String? name;
  String? username;

  SearchedUserModel.fromJson(Map<String, dynamic> json) {
    name = json['result']['name'];
    img = json['result']['img'];
    username = json['result']['username'];
  }
}
