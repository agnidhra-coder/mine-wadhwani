import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';

class _DummyUser {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String role;
  final String mine;
  final bool isActive;

  const _DummyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.role,
    required this.mine,
    this.isActive = true,
  });
}

const _dummyUsers = [
  _DummyUser(
    id: '1',
    name: 'Rajesh Kumar',
    email: 'rajesh@wadhwani.com',
    mobile: '+91 98765 43210',
    role: 'SUPERVISOR',
    mine: 'Mine A',
  ),
  _DummyUser(
    id: '2',
    name: 'Priya Sharma',
    email: 'priya@wadhwani.com',
    mobile: '+91 87654 32109',
    role: 'MINE_ADMIN',
    mine: 'Mine B',
  ),
  _DummyUser(
    id: '3',
    name: 'Amit Patel',
    email: 'amit@wadhwani.com',
    mobile: '+91 76543 21098',
    role: 'SUPERVISOR',
    mine: 'Mine C',
    isActive: false,
  ),
  _DummyUser(
    id: '4',
    name: 'Sunita Verma',
    email: 'sunita@wadhwani.com',
    mobile: '+91 65432 10987',
    role: 'SUPERVISOR',
    mine: 'Mine A',
  ),
  _DummyUser(
    id: '5',
    name: 'Vikram Singh',
    email: 'vikram@wadhwani.com',
    mobile: '+91 54321 09876',
    role: 'MINE_ADMIN',
    mine: 'Mine D',
  ),
  _DummyUser(
    id: '6',
    name: 'Neha Gupta',
    email: 'neha@wadhwani.com',
    mobile: '+91 43210 98765',
    role: 'SUPERVISOR',
    mine: 'Mine B',
    isActive: false,
  ),
  _DummyUser(
    id: '7',
    name: 'Rahul Mehta',
    email: 'rahul@wadhwani.com',
    mobile: '+91 32109 87654',
    role: 'SUPER_ADMIN',
    mine: 'All Mines',
  ),
  _DummyUser(
    id: '8',
    name: 'Deepak Yadav',
    email: 'deepak@wadhwani.com',
    mobile: '+91 21098 76543',
    role: 'SUPERVISOR',
    mine: 'Mine C',
  ),
];

@RoutePage()
class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  String _searchQuery = '';
  String _roleFilter = 'All';

  List<_DummyUser> get _filteredUsers {
    return _dummyUsers.where((user) {
      final matchesSearch = user.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole =
          _roleFilter == 'All' || user.role == _roleFilter;
      return matchesSearch && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final users = _filteredUsers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          FilledButton.icon(
            onPressed: () => _showAddUserDialog(context),
            icon: const Icon(Icons.person_add, size: 18),
            label: const Text('Add User'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Search & filter bar
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _roleFilter,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: const [
                      DropdownMenuItem(
                          value: 'All', child: Text('All Roles')),
                      DropdownMenuItem(
                          value: 'SUPER_ADMIN',
                          child: Text('Super Admin')),
                      DropdownMenuItem(
                          value: 'MINE_ADMIN',
                          child: Text('Mine Admin')),
                      DropdownMenuItem(
                          value: 'SUPERVISOR',
                          child: Text('Supervisor')),
                    ],
                    onChanged: (v) =>
                        setState(() => _roleFilter = v ?? 'All'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stats row
            Row(
              children: [
                Text(
                  '${users.length} users',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 24),
                _StatChip(
                  label: 'Active',
                  count: users.where((u) => u.isActive).length,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _StatChip(
                  label: 'Inactive',
                  count: users.where((u) => !u.isActive).length,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Table
            Expanded(
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey[100],
                      ),
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Mobile')),
                        DataColumn(label: Text('Role')),
                        DataColumn(label: Text('Mine')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: users.map((user) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.1),
                                    child: Text(
                                      user.name[0],
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(user.name),
                                ],
                              ),
                            ),
                            DataCell(Text(user.email)),
                            DataCell(Text(user.mobile)),
                            DataCell(_RoleChip(role: user.role)),
                            DataCell(Text(user.mine)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: user.isActive
                                      ? Colors.green[50]
                                      : Colors.red[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user.isActive ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    color: user.isActive
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 20),
                                    tooltip: 'Edit',
                                    onPressed: () =>
                                        _showEditDialog(context, user),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      user.isActive
                                          ? Icons.block
                                          : Icons.check_circle_outline,
                                      size: 20,
                                    ),
                                    tooltip: user.isActive
                                        ? 'Deactivate'
                                        : 'Activate',
                                    onPressed: () =>
                                        _showToggleStatusDialog(
                                            context, user),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: Colors.red),
                                    tooltip: 'Delete',
                                    onPressed: () =>
                                        _showDeleteDialog(context, user),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New User'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'SUPERVISOR', child: Text('Supervisor')),
                  DropdownMenuItem(
                      value: 'MINE_ADMIN', child: Text('Mine Admin')),
                  DropdownMenuItem(
                      value: 'SUPER_ADMIN', child: Text('Super Admin')),
                ],
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User added (dummy)')),
              );
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, _DummyUser user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit ${user.name}'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: user.name),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: TextEditingController(text: user.email),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: user.role,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                      value: 'SUPERVISOR', child: Text('Supervisor')),
                  DropdownMenuItem(
                      value: 'MINE_ADMIN', child: Text('Mine Admin')),
                  DropdownMenuItem(
                      value: 'SUPER_ADMIN', child: Text('Super Admin')),
                ],
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.name} updated (dummy)')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showToggleStatusDialog(BuildContext context, _DummyUser user) {
    final action = user.isActive ? 'Deactivate' : 'Activate';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$action ${user.name}?'),
        content: Text(
          user.isActive
              ? 'This user will no longer be able to log in.'
              : 'This user will be able to log in again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor:
                  user.isActive ? Colors.orange : Colors.green,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('${user.name} ${action.toLowerCase()}d (dummy)'),
                ),
              );
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, _DummyUser user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${user.name}?'),
        content: const Text(
          'This action cannot be undone. All data associated with this user will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.name} deleted (dummy)')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;

  const _RoleChip({required this.role});

  @override
  Widget build(BuildContext context) {
    final (label, color, darkColor) = switch (role) {
      'SUPER_ADMIN' => ('Super Admin', Colors.purple, Colors.purple[700]!),
      'MINE_ADMIN' => ('Mine Admin', Colors.blue, Colors.blue[700]!),
      _ => ('Supervisor', Colors.grey, Colors.grey[700]!),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: darkColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$count $label',
        style: TextStyle(
          color: color.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }
}
