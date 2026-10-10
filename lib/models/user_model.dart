class UserModel {

  final int id;
  final String fullName;
  final String email;
  final String mobile;
  final String role;
  final bool active;


  UserModel({

    required this.id,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.role,
    required this.active,

  });



  factory UserModel.fromJson(
      Map<String,dynamic> json){

    return UserModel(

      id: json["id"] ?? 0,


      fullName:
      json["fullName"] ?? "Unknown",


      email:
      json["email"] ?? "",


      mobile:
      json["mobile"] ?? "",


      role:
      json["role"] ?? "CUSTOMER",


      active:
      json["active"] ?? true,

    );

  }

}