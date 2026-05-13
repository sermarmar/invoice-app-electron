import 'package:get_it/get_it.dart';
import 'core/database/database.dart';
import 'features/invoices/data/datasources/invoice_local_datasource.dart';
import 'features/invoices/data/repositories/invoice_repository_impl.dart';
import 'features/invoices/domain/repositories/invoice_repository.dart';
import 'features/invoices/domain/usecases/get_invoices.dart';
import 'features/invoices/domain/usecases/create_invoice.dart';
import 'features/invoices/presentation/bloc/invoice_bloc.dart';
import 'features/clients/data/datasources/client_local_datasource.dart';
import 'features/clients/data/repositories/client_repository_impl.dart';
import 'features/clients/domain/repositories/client_repository.dart';
import 'features/clients/domain/usecases/get_clients.dart';
import 'features/clients/presentation/bloc/client_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Database
  final db = AppDatabase();
  sl.registerSingleton<AppDatabase>(db);

  // ── Invoices ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<InvoiceLocalDatasource>(
    () => InvoiceLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetInvoices(sl()));
  sl.registerLazySingleton(() => CreateInvoice(sl()));
  sl.registerFactory(() => InvoiceBloc(getInvoices: sl(), createInvoice: sl()));

  // ── Clients ───────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ClientLocalDatasource>(
    () => ClientLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<ClientRepository>(
    () => ClientRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetClients(sl()));
  sl.registerFactory(() => ClientBloc(getClients: sl()));
}
