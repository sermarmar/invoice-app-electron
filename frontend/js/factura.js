const facturas = [];
const empresa = JSON.parse(sessionStorage.getItem('empresa'));
$('#facturaContainer').hide();

$('#companyName').text(empresa.name + " " + empresa.apellidos);

$.ajax({
    url: 'http://localhost:3001/api/invoices/user/' + empresa.id,
    method: 'GET',
    datatype: 'json',
    success: function(response) {
        $('#invoiceList').empty();
        if(response.length === 0) {
            $('#invoiceTable').html('<p class="h-100 d-flex align-items-center justify-content-center">No hay facturas disponibles.</p>');
        }
        response.forEach(factura => {
            facturas.push(factura);
            $('#invoiceList').append(`
                <tr class="invoice-row" data-id="${factura.id}" data-invoiceId="${factura.invoiceId}" data-client='${JSON.stringify(factura.client)}' data-date="${factura.date}" data-products='${JSON.stringify(factura.products)}' data-total="${factura.total}">
                    <td>${factura.invoiceId}</td>
                    <td>${factura.client.name}</td>
                    <td>${factura.date}</td>
                    <td>${factura.total.toFixed(2)} €</td>
                </tr>
            `);
        })
        attachRowHandlers();
        updateCount();
    }
})

const invoiceRows = () => Array.from(document.querySelectorAll('#invoiceList .invoice-row'));
const invoiceCountEl = document.getElementById('invoiceCount');
const invoiceDetail = document.getElementById('invoiceDetail');
const editBtn = $('#editInvoice');
const printBtn = $('#printInvoice');

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
    $('#facturaContainer').show();
    $('#selectInvoiceMessage').hide();
    $('#datosEmpresa').html(`
        <h2>${empresa.name || ''} ${empresa.apellidos || ''}</h2>
        <h5>NIF: ${empresa.dni || ''}</h5>
        <p>Dirección: ${empresa.address || ''}</p>
        <p>Código Postal: ${empresa.postal_code || ''}</p>
        <p>Teléfono: ${empresa.phone || ''}</p>
    `);
    $('#cuentasBancarias').html(`
        <p><strong>Cuenta Bancaria: </strong>${empresa.account || ''}</p>
    `);
    $('#numFactura').text(row.dataset.invoiceid);
    $('#fechaFactura').text(row.dataset.date);
    const client = JSON.parse(row.dataset.client);
    $('#cliente').html(`
        <div class="col-4"><b>Cliente: ${client.name}</b></div>
        <div class="col-2">CIF: ${client.dni}</div>
        <div class="col-6">Dirección: ${client.address || ''}, ${client.postal_code || ''}</div>
    `);
    const products = JSON.parse(row.dataset.products);
    $('#tablaPrecios').empty();
    products.forEach(product => {
        $('#tablaPrecios').append(`
            <tr>
                <td class="text-end">${product.units}</td>    
                <td>${product.name}</td>
                <td class="text-end">${product.price} €</td>
                <td class="text-end subtotal">${(parseInt(product.units) * parseFloat(product.price)).toFixed(2)} €</td>
            </tr>
        `);
    });
    recalcularTotales(products);
    $('#printInvoice').prop('disabled', false);
    //editBtn.disabled = printBtn.disabled = deleteBtn.disabled = false;
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

function recalcularTotales(products) {
    let totalGeneral = 0;

    products.forEach(product => {
        let cantidad = product.units;
        let precio = parseFloat(product.price);

        if (!isFinite(cantidad)) cantidad = 0;
        if (!isFinite(precio)) precio = 0;

        const subtotal = cantidad * precio;
        $(this).find(".subtotal").text(subtotal.toFixed(2) + ' €');
        totalGeneral += subtotal;
    });

    const iva = totalGeneral * 0.21;
    const retencion = totalGeneral * 0.19;
    const totalTodo = totalGeneral + iva - retencion;

    $("#total").text(totalGeneral.toFixed(2) + ' €');
    $("#iva").text(iva.toFixed(2) + ' €');
    $("#retencion").text(retencion.toFixed(2) + ' €');
    $('#totalTodo').text(totalTodo.toFixed(2) + ' €');

    return { totalGeneral, iva, retencion, totalTodo };
}

$('#printInvoice').click(function() {
    $.ajax({
        url: 'http://localhost:3001/api/invoices/' + $('.invoice-row.table-active').data('id') + '/pdf',
        method: 'GET',
        datatype: 'binary',
        xhrFields: {
            responseType: 'blob'
        },
        success: function(response) {
            const blob = new Blob([response], { type: 'application/pdf' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `invoice_${$('.invoice-row.table-active').data('invoiceid')}.pdf`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        },
        error: function(xhr, status, error) {
            console.error('Error al generar el PDF, consulta con el técnico.');
        }
    });
});