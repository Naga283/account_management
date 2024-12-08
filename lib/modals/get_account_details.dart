import 'dart:convert';

List<GetAccountDetails> getAccountDetailsFromJson(String str) =>
    List<GetAccountDetails>.from(
        json.decode(str).map((x) => GetAccountDetails.fromJson(x)));

String getAccountDetailsToJson(List<GetAccountDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAccountDetails {
  String firstName;
  String lastName;
  dynamic createdAt;
  String? password;
  String emailId;
  String? mobileNo;
  String accId;

  GetAccountDetails({
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.password,
    required this.emailId,
    this.mobileNo,
    required this.accId,
  });

  factory GetAccountDetails.fromJson(Map<String, dynamic> json) =>
      GetAccountDetails(
        firstName: json["firstName"],
        lastName: json["lastName"],
        createdAt: json["createdAt"],
        password: json["password"],
        emailId: json["emailId"],
        mobileNo: json["mobileNo"],
        accId: json['accountId'],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "createdAt": createdAt,
        "password": password,
        "emailId": emailId,
        "mobileNo": mobileNo,
        "accountId": accId,
      };
}
