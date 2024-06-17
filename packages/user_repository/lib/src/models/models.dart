export 'user.dart';

class MyUser {
  String userID;
  String email;
  String password;
  String name;
  bool hasActiveCart;

  MyUser({
    required this.userID,
    required this.email,
    required this.name,
    required this.hasActiveCart,
  });

  static final empty = MyUser(
    userID: '',
    email: '',
    name: '',
    hasActiveCart: false,
  );

  MyUserEntity toEntity() {
    return MyUserEntity(
      userID: userID,
      email: email,
      name: name,
      hasActiveCart: hasActiveCart,
    )
  }
}
