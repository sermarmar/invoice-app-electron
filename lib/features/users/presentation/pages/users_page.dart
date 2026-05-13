import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
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
      appBar: AppBar(title: const Text('Usuarios')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) => switch (state) {
          UserInitial() || UserLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          UserError(:final message) => Center(child: Text(message)),
          UserLoaded(:final users) when users.isEmpty => const Center(
              child: Text('No hay usuarios registrados'),
            ),
          UserLoaded(:final users) => Padding(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: users.map((u) => _UserCard(user: u)).toList(),
              ),
            ),
        },
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
      width: 240,
      child: Card(
        child: InkWell(
          onTap: () {
            // TODO: navegar a facturas del usuario
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.twilightIndigo900,
                  child: Icon(
                    Icons.person,
                    size: 36,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
