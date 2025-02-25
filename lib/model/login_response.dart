import 'dart:convert';

class LoginResponse {
  final bool response;
  final String responseCode;
  final Data data;

  LoginResponse({
    required this.response,
    required this.responseCode,
    required this.data,
  });

  // Factory method to create an instance from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      response: json["response"],
      responseCode: json["responseCode"],
      data: Data.fromJson(json["data"]),
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "response": response,
      "responseCode": responseCode,
      "data": data.toJson(),
    };
  }
}

class Data {
  final String customerID;
  final String userName;
  final String fullName;
  final String branchID;
  final String clientID;
  final String wireTransferRefNumber;
  final String custRefNumber;
  final String docUploadCount;
  final String mobileVerificationFlag;
  final String currencyCode;
  final String currencyID;
  final String currencySign;
  final String countryFlag;
  final String countryName;
  final String countryID;
  final String? agentUserID;
  final String? agentBranch;
  final String? newAgentBranch;
  final String stepComplete;
  final String payoutCountryId;
  final String customerProfileImage;
  final String token;

  Data({
    required this.customerID,
    required this.userName,
    required this.fullName,
    required this.branchID,
    required this.clientID,
    required this.wireTransferRefNumber,
    required this.custRefNumber,
    required this.docUploadCount,
    required this.mobileVerificationFlag,
    required this.currencyCode,
    required this.currencyID,
    required this.currencySign,
    required this.countryFlag,
    required this.countryName,
    required this.countryID,
    this.agentUserID,
    this.agentBranch,
    this.newAgentBranch,
    required this.stepComplete,
    required this.payoutCountryId,
    required this.customerProfileImage,
    required this.token,
  });

  // Factory method to create an instance from JSON
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      customerID: json["customerID"],
      userName: json["userName"],
      fullName: json["fullName"],
      branchID: json["branchID"],
      clientID: json["clientID"],
      wireTransferRefNumber: json["WireTransferRefNumber"],
      custRefNumber: json["custRefNumber"],
      docUploadCount: json["docUploadCount"],
      mobileVerificationFlag: json["mobileVerificationFlag"],
      currencyCode: json["currencyCode"],
      currencyID: json["currencyID"],
      currencySign: json["currencySign"],
      countryFlag: json["countryFlag"],
      countryName: json["countryName"],
      countryID: json["countryID"],
      agentUserID: json["agentUserID"],
      agentBranch: json["agentBranch"],
      newAgentBranch: json["newAgentBranch"],
      stepComplete: json["stepComplete"],
      payoutCountryId: json["payoutCountryId"],
      customerProfileImage: json["customer_profileimage"],
      token: json["token"],
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      "customerID": customerID,
      "userName": userName,
      "fullName": fullName,
      "branchID": branchID,
      "clientID": clientID,
      "WireTransferRefNumber": wireTransferRefNumber,
      "custRefNumber": custRefNumber,
      "docUploadCount": docUploadCount,
      "mobileVerificationFlag": mobileVerificationFlag,
      "currencyCode": currencyCode,
      "currencyID": currencyID,
      "currencySign": currencySign,
      "countryFlag": countryFlag,
      "countryName": countryName,
      "countryID": countryID,
      "agentUserID": agentUserID,
      "agentBranch": agentBranch,
      "newAgentBranch": newAgentBranch,
      "stepComplete": stepComplete,
      "payoutCountryId": payoutCountryId,
      "customer_profileimage": customerProfileImage,
      "token": token,
    };
  }
}

// Function to parse JSON string into LoginResponse object
LoginResponse loginResponseFromJson(String str) {
  return LoginResponse.fromJson(json.decode(str));
}

// Function to convert LoginResponse object back to JSON string
String loginResponseToJson(LoginResponse data) {
  return json.encode(data.toJson());
}
