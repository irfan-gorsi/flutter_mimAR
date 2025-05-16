import 'package:flutter/material.dart';
import 'package:mimar/screens/home/AllUsers/users_controller.dart';

class UserTable extends StatefulWidget {
  const UserTable({super.key});

  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  final UserController _userController = UserController();

  List<dynamic> _users = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _userController.fetchAllUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load users: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (_users.isEmpty) {
      return const Center(
          child: Text(
        'No users found.',
        style: TextStyle(fontSize: 16),
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: DataTable(
          headingRowColor:
              WidgetStateColor.resolveWith((states) => Colors.grey[200]!),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.black87,
          ),
          dataTextStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          dividerThickness: 1,
          columns: const [
            DataColumn(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Name'),
              ),
            ),
            DataColumn(
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Email'),
              ),
            ),
          ],
          rows: List<DataRow>.generate(
            _users.length,
            (index) {
              final user = _users[index];
              return DataRow(
                cells: [
                  DataCell(Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(user['fullname'] ?? 'N/A'),
                  )),
                  DataCell(Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(user['email'] ?? 'N/A'),
                  )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
