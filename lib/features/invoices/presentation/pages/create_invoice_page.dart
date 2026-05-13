import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../clients/domain/entities/client.dart';
import '../../../clients/presentation/bloc/client_bloc.dart';
import '../../../users/domain/entities/user.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_item.dart';
import '../bloc/invoice_bloc.dart';

class CreateInvoicePage extends StatelessWidget {
  final User user;
  final int nextInvoiceNumber;
  final Invoice? invoice; // null = crear, non-null = editar

  const CreateInvoicePage({
    super.key,
    required this.user,
    required this.nextInvoiceNumber,
    this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClientBloc>()..add(const LoadClients()),
      child: _CreateInvoiceView(
        user: user,
        nextInvoiceNumber: nextInvoiceNumber,
        invoice: invoice,
      ),
    );
  }
}

class _ProductLine {
  final TextEditingController units;
  final TextEditingController name;
  final TextEditingController price;

  _ProductLine()
      : units = TextEditingController(text: '1'),
        name = TextEditingController(),
        price = TextEditingController(text: '0');

  _ProductLine.fromProduct(Product p)
      : units = TextEditingController(text: '${p.units}'),
        name = TextEditingController(text: p.name),
        price = TextEditingController(text: p.price.toString());

  void dispose() {
    units.dispose();
    name.dispose();
    price.dispose();
  }

  double get subtotal {
    final u = int.tryParse(units.text) ?? 0;
    final p = double.tryParse(price.text.replaceAll(',', '.')) ?? 0;
    return u * p;
  }
}

class _CreateInvoiceView extends StatefulWidget {
  final User user;
  final int nextInvoiceNumber;
  final Invoice? invoice;

  const _CreateInvoiceView({
    required this.user,
    required this.nextInvoiceNumber,
    this.invoice,
  });

  @override
  State<_CreateInvoiceView> createState() => _CreateInvoiceViewState();
}

class _CreateInvoiceViewState extends State<_CreateInvoiceView> {
  late String _date;
  final List<_ProductLine> _lines = [];
  Client? _selectedClient;
  bool _saving = false;

  bool get _isEditing => widget.invoice != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _date = widget.invoice!.date;
      for (final p in widget.invoice!.products) {
        _lines.add(_ProductLine.fromProduct(p));
      }
      if (_lines.isEmpty) _addLine();
    } else {
      _date = DateTime.now().toIso8601String().split('T')[0];
      _addLine();
    }
  }

  @override
  void dispose() {
    for (final l in _lines) {
      l.dispose();
    }
    super.dispose();
  }

  void _addLine() {
    setState(() => _lines.add(_ProductLine()));
  }

  void _removeLine(int i) {
    _lines[i].dispose();
    setState(() => _lines.removeAt(i));
  }

  double get _subtotal => _lines.fold(0, (s, l) => s + l.subtotal);
  double get _iva => _subtotal * 0.21;
  double get _retencion => _subtotal * 0.19;
  double get _total => _subtotal + _iva - _retencion;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(_date),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked.toIso8601String().split('T')[0]);
    }
  }

  void _save() {
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un cliente')),
      );
      return;
    }
    if (_lines.isEmpty || _lines.every((l) => l.name.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Añade al menos un producto')),
      );
      return;
    }

    setState(() => _saving = true);

    final products = _lines
        .where((l) => l.name.text.trim().isNotEmpty)
        .map(
          (l) => Product(
            name: l.name.text.trim(),
            price: double.tryParse(l.price.text.replaceAll(',', '.')) ?? 0,
            units: int.tryParse(l.units.text) ?? 1,
            invoiceId: 0,
          ),
        )
        .toList();

    final invoice = Invoice(
      id: widget.invoice?.id,
      invoiceId: widget.invoice?.invoiceId ?? widget.nextInvoiceNumber,
      userId: widget.user.id!,
      clientId: _selectedClient!.id!,
      date: _date,
      total: _total,
      products: products,
    );

    if (_isEditing) {
      context.read<InvoiceBloc>().add(UpdateInvoiceEvent(invoice));
    } else {
      context.read<InvoiceBloc>().add(CreateInvoiceEvent(invoice));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing
                  ? 'Editar factura #${widget.invoice!.invoiceId.toString().padLeft(3, '0')}'
                  : 'Nueva factura #${widget.nextInvoiceNumber.toString().padLeft(3, '0')}',
            ),
            Text(
              widget.user.fullName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('Guardar'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderRow(
              user: widget.user,
              date: _date,
              onPickDate: _pickDate,
              selectedClient: _selectedClient,
              onClientChanged: (c) => setState(() => _selectedClient = c),
              preselectedClientId: widget.invoice?.clientId,
            ),
            const SizedBox(height: 24),
            _ProductsTable(
              lines: _lines,
              onAdd: _addLine,
              onRemove: _removeLine,
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 24),
            _TotalsPanel(
              subtotal: _subtotal,
              iva: _iva,
              retencion: _retencion,
              total: _total,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header: datos usuario + fecha + cliente ───────────────────────────────

class _HeaderRow extends StatelessWidget {
  final User user;
  final String date;
  final VoidCallback onPickDate;
  final Client? selectedClient;
  final ValueChanged<Client?> onClientChanged;
  final int? preselectedClientId;

  const _HeaderRow({
    required this.user,
    required this.date,
    required this.onPickDate,
    required this.selectedClient,
    required this.onClientChanged,
    this.preselectedClientId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _UserInfoCard(user: user)),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ClientDropdown(
                selected: selectedClient,
                onChanged: onClientChanged,
                preselectedClientId: preselectedClientId,
              ),
              const SizedBox(height: 12),
              _DateField(date: date, onTap: onPickDate),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  final User user;
  const _UserInfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.fullName, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('NIF: ${user.dni}', style: theme.textTheme.bodySmall),
            if (user.address != null) ...[
              const SizedBox(height: 2),
              Text(user.address!, style: theme.textTheme.bodySmall),
            ],
            if (user.postalCode != null) ...[
              const SizedBox(height: 2),
              Text('CP: ${user.postalCode}', style: theme.textTheme.bodySmall),
            ],
            if (user.phone != null) ...[
              const SizedBox(height: 2),
              Text('Tel: ${user.phone}', style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 4),
            Text(user.account, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ClientDropdown extends StatelessWidget {
  final Client? selected;
  final int? preselectedClientId;
  final ValueChanged<Client?> onChanged;

  const _ClientDropdown({
    required this.selected,
    required this.onChanged,
    this.preselectedClientId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientBloc, ClientState>(
      listenWhen: (_, s) => s is ClientLoaded && selected == null && preselectedClientId != null,
      listener: (_, state) {
        if (state is ClientLoaded) {
          final match = state.clients.where((c) => c.id == preselectedClientId).firstOrNull;
          if (match != null) onChanged(match);
        }
      },
      builder: (context, state) {
        final clients = state is ClientLoaded ? state.clients : <Client>[];
        return InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Cliente',
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: DropdownButton<Client>(
            value: selected,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            isDense: true,
            hint: state is ClientLoading
                ? const Text('Cargando...')
                : const Text('Selecciona un cliente'),
            items: clients
                .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                .toList(),
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}

class _DateField extends StatelessWidget {
  final String date;
  final VoidCallback onTap;

  const _DateField({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Fecha',
          border: OutlineInputBorder(),
          isDense: true,
          suffixIcon: Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(date),
      ),
    );
  }
}

// ── Tabla de productos ────────────────────────────────────────────────────

class _ProductsTable extends StatelessWidget {
  final List<_ProductLine> lines;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final VoidCallback onChanged;

  const _ProductsTable({
    required this.lines,
    required this.onAdd,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Productos', style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Añadir línea'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Table(
              columnWidths: const {
                0: FixedColumnWidth(80),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(110),
                3: FixedColumnWidth(110),
                4: FixedColumnWidth(40),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  children: const [
                    _TableHeader('Uds.'),
                    _TableHeader('Descripción'),
                    _TableHeader('Precio', align: TextAlign.right),
                    _TableHeader('Subtotal', align: TextAlign.right),
                    _TableHeader(''),
                  ],
                ),
                for (int i = 0; i < lines.length; i++)
                  TableRow(
                    children: [
                      _NumCell(controller: lines[i].units, onChanged: onChanged),
                      _TextCell(
                        controller: lines[i].name,
                        hint: 'Descripción',
                        onChanged: onChanged,
                      ),
                      _NumCell(
                        controller: lines[i].price,
                        onChanged: onChanged,
                        decimal: true,
                        align: TextAlign.right,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: Text(
                          '${lines[i].subtotal.toStringAsFixed(2)} €',
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: AppColors.burntPeach,
                        onPressed: lines.length > 1 ? () => onRemove(i) : null,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  final TextAlign align;

  const _TableHeader(this.text, {this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Text(
        text,
        textAlign: align,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _NumCell extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool decimal;
  final TextAlign align;

  const _NumCell({
    required this.controller,
    required this.onChanged,
    this.decimal = false,
    this.align = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: TextField(
        controller: controller,
        textAlign: align,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        onChanged: (_) => onChanged(),
      ),
    );
  }
}

class _TextCell extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback onChanged;

  const _TextCell({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        onChanged: (_) => onChanged(),
      ),
    );
  }
}

// ── Panel de totales ──────────────────────────────────────────────────────

class _TotalsPanel extends StatelessWidget {
  final double subtotal;
  final double iva;
  final double retencion;
  final double total;
  final ThemeData theme;

  const _TotalsPanel({
    required this.subtotal,
    required this.iva,
    required this.retencion,
    required this.total,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 300,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _TotalRow('Subtotal', subtotal, theme),
                _TotalRow('IVA (21%)', iva, theme),
                _TotalRow('Retención (19%)', retencion, theme, negative: true),
                const Divider(),
                _TotalRow('Total', total, theme, bold: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  final ThemeData theme;
  final bool bold;
  final bool negative;

  const _TotalRow(
    this.label,
    this.amount,
    this.theme, {
    this.bold = false,
    this.negative = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? theme.textTheme.titleSmall
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            '${negative ? '-' : ''}${amount.toStringAsFixed(2)} €',
            style: style,
          ),
        ],
      ),
    );
  }
}
