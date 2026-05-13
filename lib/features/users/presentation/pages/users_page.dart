import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../invoices/presentation/pages/invoices_page.dart';
import '../bloc/user_bloc.dart';
import '../../domain/entities/user.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserBloc>()..add(const LoadUsers()),
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
          UserLoaded(:final users) when users.isEmpty => const Center(
              child: Text('No hay usuarios registrados'),
            ),
          UserLoaded(:final users) => _UsersGrid(users: users),
        },
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
        ],
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
