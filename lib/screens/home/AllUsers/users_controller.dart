import 'package:mimar/screens/home/AllUsers/usersapi_service.dart';

class UserController {
  Future<List<dynamic>> fetchAllUsers() async {
    return await UserApiService.getAllUsers();
  }
}
