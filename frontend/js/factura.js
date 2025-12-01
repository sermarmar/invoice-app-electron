const invoiceRows = () => Array.from(document.querySelectorAll('#invoiceList .invoice-row'));
            const invoiceCountEl = document.getElementById('invoiceCount');
            const invoiceDetail = document.getElementById('invoiceDetail');
            const editBtn = document.getElementById('editInvoice');
            const printBtn = document.getElementById('printInvoice');
            const deleteBtn = document.getElementById('deleteInvoice');

function updateCount() {
    const visible = invoiceRows().filter(r => r.style.display !== 'none').length;
    invoiceCountEl.textContent = visible;
}

function clearSelection() {
    invoiceRows().forEach(r => r.classList.remove('table-active'));
    editBtn.disabled = printBtn.disabled = deleteBtn.disabled = true;
    invoiceDetail.innerHTML = '<p class="text-muted">Selecciona una factura para ver el detalle.</p>';
}

function showDetail(row) {
    const id = row.dataset.id;
    const client = row.dataset.client;
    const date = row.dataset.date;
    const total = row.dataset.total;
    invoiceDetail.innerHTML = `
        <h5>${id}</h5>
        <p><strong>Cliente:</strong> ${client}</p>
        <p><strong>Fecha:</strong> ${date}</p>
        <p><strong>Total:</strong> ${total} €</p>
        <hr>
        <p class="mb-0 text-muted">Aquí puede ir el detalle de líneas, impuestos y acciones.</p>
    `;
    editBtn.disabled = printBtn.disabled = deleteBtn.disabled = false;
}

    
function attachRowHandlers() {
    invoiceRows().forEach(row => {
        row.onclick = () => {
            invoiceRows().forEach(r => r.classList.remove('table-active'));
            row.classList.add('table-active');
            showDetail(row);
        };
    });
}

          
document.getElementById('applyFilter').onclick = () => {
    const from = document.getElementById('dateFrom').value;
    const to = document.getElementById('dateTo').value;
    const text = document.getElementById('searchText').value.trim().toLowerCase();

    invoiceRows().forEach(row => {
        const rowDate = row.dataset.date;
        const id = row.dataset.id.toLowerCase();
        const client = row.dataset.client.toLowerCase();
        let visible = true;

        if (from && rowDate < from) visible = false;
        if (to && rowDate > to) visible = false;
        if (text) {
            if (!(id.includes(text) || client.includes(text))) visible = false;
        }

        row.style.display = visible ? '' : 'none';
    });

    clearSelection();
    updateCount();
};

document.getElementById('clearFilter').onclick = () => {
    document.getElementById('dateFrom').value = '';
    document.getElementById('dateTo').value = '';
    document.getElementById('searchText').value = '';
    invoiceRows().forEach(r => r.style.display = '');
    clearSelection();
    updateCount();
};

// Initialize
attachRowHandlers();
updateCount();

function crearFactura() {
    const params = new URLSearchParams(window.location.search);
    const empresaId = params.get('empresa') || '';
    var url = 'crearFactura.html?empresa=' + encodeURIComponent(empresaId);
    window.location.href = url;
}