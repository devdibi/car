
class UserData{
  final int id;
  final String email;
  final String name;
  final int role;

  UserData({required this.id, required this.email, required this.name, required this.role});

  int getId(){
    return id;
  }

}