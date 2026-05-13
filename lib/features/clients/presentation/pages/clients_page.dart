import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/client_bloc.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClientBloc>()..add(const LoadClients()),
      child: const _ClientsView(),
    );
  }
}

class _ClientsView extends StatelessWidget {
  const _ClientsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: navegar a formulario nuevo cliente
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ClientBloc, ClientState>(
        builder: (context, state) => switch (state) {
          ClientInitial() || ClientLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          ClientError(:final message) => Center(child: Text(message)),
          ClientLoaded(:final clients) when clients.isEmpty => const Center(
              child: Text('No hay clientes todavía'),
            ),
          ClientLoaded(:final clients) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: clients.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, index) {
                final client = clients[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(client.name),
                  subtitle: client.phone != null ? Text(client.phone!) : null,
                  trailing: client.dni != null
                      ? Text(client.dni!,
                          style: Theme.of(context).textTheme.bodySmall)
                      : null,
                );
              },
            ),
        },
      ),
    );
  }
}
