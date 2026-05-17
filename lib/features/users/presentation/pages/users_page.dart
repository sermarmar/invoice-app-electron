import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../clients/domain/entities/client.dart';
import '../../../clients/presentation/bloc/client_bloc.dart';
import '../../../invoices/presentation/pages/invoices_page.dart';
import '../bloc/user_bloc.dart';
import '../../domain/entities/user.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<UserBloc>()..add(const LoadUsers())),
        BlocProvider(create: (_) => sl<ClientBloc>()),
      ],
      child: const _UsersView(),
    );
  }
}

class _UsersView extends StatelessWidget {
  const _UsersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.eggshell,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) => switch (state) {
          UserInitial() || UserLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          UserError(:final message) => Center(child: Text(message)),
          UserLoaded(:final users) when users.isEmpty => _EmptyUsersView(),
          UserLoaded(:final users) => _UsersGrid(users: users),
        },
      ),
    );
  }
}

class _EmptyUsersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Invoice App', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 32),
          Icon(Icons.person_off_outlined, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'No hay usuarios registrados',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Crea un usuario para empezar a gestionar facturas',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 32),
          _ActionButtons(),
        ],
      ),
    );
  }
}

class _UsersGrid extends StatelessWidget {
  final List<User> users;
  const _UsersGrid({required this.users});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Invoice App',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona un usuario para gestionar sus facturas',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: users.map((u) => _UserCard(user: u)).toList(),
          ),
          const SizedBox(height: 48),
          _ActionButtons(),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => _showCreateUserDialog(context),
          icon: const Icon(Icons.person_add),
          label: const Text('Crear usuario'),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: () => _showCreateClientDialog(context),
          icon: const Icon(Icons.group_add),
          label: const Text('Crear cliente'),
        ),
      ],
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<UserBloc>(),
        child: const _CreateUserDialog(),
      ),
    );
  }

  void _showCreateClientDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ClientBloc>(),
        child: const _CreateClientDialog(),
      ),
    );
  }
}

class _CreateUserDialog extends StatefulWidget {
  const _CreateUserDialog();

  @override
  State<_CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<_CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _dniCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _postalCodeCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _nameCtrl.dispose();
    _apellidosCtrl.dispose();
    _dniCtrl.dispose();
    _accountCtrl.dispose();
    _addressCtrl.dispose();
    _postalCodeCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final user = User(
      username: _usernameCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      dni: _dniCtrl.text.trim(),
      account: _accountCtrl.text.trim(),
      address: _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
      postalCode: _postalCodeCtrl.text.trim().isEmpty ? null : _postalCodeCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
    );
    context.read<UserBloc>().add(CreateUserEvent(user));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo usuario'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(_usernameCtrl, 'Usuario', required: true),
                _field(_nameCtrl, 'Nombre', required: true),
                _field(_apellidosCtrl, 'Apellidos', required: true),
                _field(_dniCtrl, 'DNI/NIF', required: true),
                _field(_accountCtrl, 'Cuenta bancaria', required: true),
                _field(_addressCtrl, 'Dirección'),
                _field(_postalCodeCtrl, 'Código postal'),
                _field(_phoneCtrl, 'Teléfono'),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Crear'),
        ),
      ],
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null
            : null,
      ),
    );
  }
}

class _CreateClientDialog extends StatefulWidget {
  const _CreateClientDialog();

  @override
  State<_CreateClientDialog> createState() => _CreateClientDialogState();
}

class _CreateClientDialogState extends State<_CreateClientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dniCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _postalCodeCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dniCtrl.dispose();
    _addressCtrl.dispose();
    _postalCodeCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final client = Client(
      name: _nameCtrl.text.trim(),
      dni: _dniCtrl.text.trim().isEmpty ? null : _dniCtrl.text.trim(),
      address: _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
      postalCode: _postalCodeCtrl.text.trim().isEmpty ? null : _postalCodeCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
    );
    context.read<ClientBloc>().add(CreateClientEvent(client));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo cliente'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(_nameCtrl, 'Nombre', required: true),
                _field(_dniCtrl, 'DNI/NIF'),
                _field(_addressCtrl, 'Dirección'),
                _field(_postalCodeCtrl, 'Código postal'),
                _field(_phoneCtrl, 'Teléfono'),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Crear'),
        ),
      ],
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null
            : null,
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;
  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 220,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => InvoicesPage(user: user),
            ),
          ),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.twilightIndigo900,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.twilightIndigo,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'NIF: ${user.dni}',
                  style: theme.textTheme.bodySmall,
                ),
                if (user.address != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.address!,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (user.phone != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Tel: ${user.phone}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => InvoicesPage(user: user),
                    ),
                  ),
                  icon: const Icon(Icons.receipt_long, size: 16),
                  label: const Text('Ver facturas'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
