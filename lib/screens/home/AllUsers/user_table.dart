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
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          strokeWidth: 3,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    if (_users.isEmpty) {
      return const Center(
        child: Text(
          'No users found.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.blue.shade50),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DataTable(
            headingRowHeight: 60,
            dataRowHeight: 58,
            horizontalMargin: 24,
            columnSpacing: 32,
            headingRowColor: MaterialStateProperty.all(
              Colors.blue.shade50,
            ),
            headingTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue.shade800,
            ),
            dataTextStyle: const TextStyle(
              fontSize: 15,
              color: Colors.black87,
            ),
            dividerThickness: 0.5,
            border: TableBorder(
              verticalInside: BorderSide(
                color: Colors.grey.shade200,
                width: 0.5,
              ),
              horizontalInside: BorderSide(
                color: Colors.grey.shade200,
                width: 0.5,
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
            ),
            columns: [
              DataColumn(
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ),
            ],
            rows: List<DataRow>.generate(
              _users.length,
              (index) {
                final user = _users[index];
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.blue.shade50.withOpacity(0.3);
                    }
                    return index.isEven
                        ? Colors.white
                        : Colors.grey.shade50;
                  }),
                  cells: [
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          user['fullname'] ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          user['email'] ?? 'N/A',
                          style: TextStyle(
                            color: Colors.blueGrey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}