class Employee {
  final String id;
  final String name;
  final String gender;
  final String birthday;
  final String phonenumber;
  final String email;
  final String imagelink;
  Employee(this.id, this.name, this.gender, this.birthday, this.phonenumber,
      this.email, this.imagelink);
}

class User_SignIn {
  final String username;
  final String password;

  User_SignIn(this.username, this.password);
}
