const empresa = JSON.parse(sessionStorage.getItem('empresa'));
$('#datosEmpresa').html(`
     <h2>${empresa.name} ${empresa.apellidos}</h2>
    <h5>NIF: ${empresa.dni}</h4>
    <p>Dirección: ${empresa.address}</p>
    <p>Código Postal: ${empresa.postal_code}</p>
    <p>Teléfono: ${empresa.phone}</p>
`);

function salirFactura(){
    const params = new URLSearchParams(window.location.search);
    const empresaId = params.get('empresa') || '';
    var url = 'factura.html?empresa=' + encodeURIComponent(empresaId);
    window.location.href = url;
}

$(document).on("input", ".cantidad, .precio", function () {

    let totalGeneral = 0;

    $("#tablaPrecios tr").each(function () {

        let cantidad = parseInt($(this).find(".cantidad").val());
        let precio = parseFloat($(this).find(".precio").val());

        let subtotal = 0;

        if (!isNaN(cantidad) && !isNaN(precio)) {
            subtotal = cantidad * precio;
        }

        // Mostrar subtotal en la fila
        $(this).find(".subtotal").text(subtotal.toFixed(2));

        // Acumular en el total general
        totalGeneral += subtotal;
    });

    // Mostrar total general
    const iva = totalGeneral * 0.21
    const retencion = totalGeneral * 0.19
    const totalTodo = totalGeneral + iva - retencion;

    $("#total").text(totalGeneral.toFixed(2));
    $("#iva").text(iva.toFixed(2));
    $("#retencion").text(retencion.toFixed(2));
    $('#totalTodo').text(totalTodo.toFixed(2) + ' €');

});

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
            <td class="text-end fw-bold total-item subtotal">€0.00</td>
            <td class="text-center no-print">
                <i class="fas fa-trash btn-eliminar" onclick="eliminarFila(this)"></i>
            </td>
        </tr>     
    `);
}