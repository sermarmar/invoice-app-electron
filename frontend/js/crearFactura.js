const empresaData = sessionStorage.getItem('empresa');
const empresa = empresaData ? JSON.parse(empresaData) : {};
let cliente = {};

$('#fechaFactura').val(new Date().toISOString().split("T")[0]);

$('#datosEmpresa').html(`
    <h2>${empresa.name || ''} ${empresa.apellidos || ''}</h2>
    <h5>NIF: ${empresa.dni || ''}</h5>
    <p>Dirección: ${empresa.address || ''}</p>
    <p>Código Postal: ${empresa.postal_code || ''}</p>
    <p>Teléfono: ${empresa.phone || ''}</p>
`);

// Comprobar facturas para obtener el último número
$.ajax({
    url: 'http://localhost:3001/api/invoices/user/' + empresa.id,
    type: 'GET',
    dataType: 'json',
    success: function(response) {
        let numero = response.length + 1
        $('#numFactura').text(numero.toString().padStart(3, '0'))
    },
    error: function(xhr, status, error) {
        console.error('Error al recuperar cliente:', status, error);
    }
});

function salirFactura() {
    const params = new URLSearchParams(window.location.search);
    const empresaId = params.get('empresa') || '';
    const url = 'factura.html?empresa=' + encodeURIComponent(empresaId);
    window.location.href = url;
}

$(document).on("input", ".cantidad, .precio", function () {
    recalcularTotales();
});

$(document).on("click", ".btn-eliminar, .borrarProducto", function () {
    $(this).closest("tr").remove();
    recalcularTotales();
});

function recalcularTotales() {
    let totalGeneral = 0;

    $("#tablaPrecios tr").each(function () {
        const $cantidad = $(this).find(".cantidad");
        const $precio = $(this).find(".precio");
        if ($cantidad.length === 0 && $precio.length === 0) return; // skip non-product rows

        let cantidad = parseFloat($cantidad.val());
        let precio = parseFloat($precio.val());

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

function agregarFila() {
    $('#tablaPrecios').append(`
        <tr data-id="1">
            <td>
                <input type="number" class="form-control text-center cantidad" value="1" min="1">
            </td>
            <td>
                <input type="text" class="form-control concepto" placeholder="Descripción del producto/servicio">
            </td>
            <td>
                <input type="number" class="form-control text-end precio" value="0" min="0" step="0.01">
            </td>
            <td class="text-end fw-bold total-item subtotal">0.00 €</td>
            <td class="text-center no-print">
                <i class="fas fa-trash btn-eliminar"></i>
            </td>
        </tr>
    `);
}

// Recuperar cliente
$.ajax({
    url: 'http://localhost:3001/api/clients/1',
    type: 'GET',
    dataType: 'json',
    success: function(response) {
        cliente = response;
        $('#cliente').html(`
            <div class="col-4"><b>Cliente: ${response.name}</b></div>
            <div class="col-2">CIF: ${response.dni}</div>
            <div class="col-6">Dirección: ${response.address || ''}, ${response.postal_code || ''}</div>
        `);
    },
    error: function(xhr, status, error) {
        console.error('Error al recuperar cliente:', status, error);
    }
});

function guardarFactura() {
    const factura = {
        userId: empresa.id,
        clientId: cliente.id,
        date: $('#fechaFactura').val(),
        products: [],
        total: $('#totalTodo').text().replace('€', '').trim()
    };

    $("#tablaPrecios tr").each(function () {
        const concepto = $(this).find(".concepto").val();
        const units = parseFloat($(this).find(".cantidad").val());
        const price = parseFloat($(this).find(".precio").val());

        // Skip empty product rows
        if (!concepto && units === 0 && price === 0) return;

        factura.products.push({
            name: concepto || "Producto",
            units: units,
            price: price
        });
    });

    // Recalculate totals and set factura.total
    const totals = recalcularTotales();
    factura.total = totals.totalTodo;

    $.ajax({
        url: 'http://localhost:3001/api/invoices',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(factura),
        dataType: 'json',
        success: function(response) {
            window.location.href = 'factura.html?empresa=' + encodeURIComponent(empresa.id);
        },
        error: function(xhr, status, error) {
            alert('Error al guardar la factura, consulta con el técnico');
        }
    });
}
