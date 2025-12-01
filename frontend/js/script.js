var empresas = {
    empresa1: {
        nombre: 'Maite Martín Gastelut',
        direccion: 'calle xxxxxxx',
        codigo_postal:'xxxxx',
        telefono: '+34 xxxxxxxxx',
        color: 'primary'
    },
    empresa2: {
        nombre: 'Eloisa Martín Gastelut',
        direccion: 'Calle xxxxxx',
        codigo_postal:'xxxxx',
        telefono: '+34 xxxxxxx',
        color: 'success'
    }
};

function abrirFactura(empresaId) {
    var url = 'factura.html?empresa=' + encodeURIComponent(empresaId);
    window.location.href = url;
}

function volverInicio() {
    document.getElementById('mainContainer').style.display = 'block';
    document.getElementById('facturaContainer').style.display = 'none';
    document.querySelector('.btn-volver').style.display = 'none';
    document.body.style.background = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
}

function resetearFormulario() {
    document.getElementById('numeroFactura').value = '001';
    document.getElementById('fechaFactura').valueAsDate = new Date();
    document.getElementById('nombreCliente').value = '';
    document.getElementById('direccionCliente').value = '';
    document.getElementById('telefonoCliente').value = '';
    
    var tbody = document.getElementById('tablaItems');
    tbody.innerHTML = '<tr data-id="1"><td><input type="number" class="form-control text-center cantidad" value="1" min="1"></td><td><input type="text" class="form-control concepto" placeholder="Descripción del producto/servicio"></td><td><input type="number" class="form-control text-end precio" value="0" min="0" step="0.01"></td><td class="text-end fw-bold total-item">€0.00</td><td class="text-center no-print"><i class="fas fa-trash btn-eliminar" onclick="eliminarFila(this)"></i></td></tr>';
    
    var filasIniciales = document.querySelectorAll('#tablaItems tr');
    for (var i = 0; i < filasIniciales.length; i++) {
        agregarEventos(filasIniciales[i]);
    }
    
    contadorFilas = 1;
    calcularTotales();
}

document.getElementById('fechaFactura').valueAsDate = new Date();

var contadorFilas = 1;

function agregarFila() {
    contadorFilas++;
    var tabla = document.getElementById('tablaItems');
    var nuevaFila = document.createElement('tr');
    nuevaFila.setAttribute('data-id', contadorFilas);
    nuevaFila.innerHTML = '<td><input type="number" class="form-control text-center cantidad" value="1" min="1"></td><td><input type="text" class="form-control concepto" placeholder="Descripción del producto/servicio"></td><td><input type="number" class="form-control text-end precio" value="0" min="0" step="0.01"></td><td class="text-end fw-bold total-item">€0.00</td><td class="text-center no-print"><i class="fas fa-trash btn-eliminar" onclick="eliminarFila(this)"></i></td>';
    tabla.appendChild(nuevaFila);
    agregarEventos(nuevaFila);
}

function eliminarFila(elemento) {
    var filas = document.querySelectorAll('#tablaItems tr');
    if (filas.length > 1) {
        elemento.closest('tr').remove();
        calcularTotales();
    } else {
        alert('Debe haber al menos una línea en la factura');
    }
}

function calcularTotales() {
    var filas = document.querySelectorAll('#tablaItems tr');
    var subtotal = 0;

    for (var i = 0; i < filas.length; i++) {
        var fila = filas[i];
        var cantidad = parseFloat(fila.querySelector('.cantidad').value) || 0;
        var precio = parseFloat(fila.querySelector('.precio').value) || 0;
        var total = cantidad * precio;
        
        fila.querySelector('.total-item').textContent = '€' + total.toFixed(2);
        subtotal += total;
    }

    var iva = subtotal * 0.21;
    var retencion = subtotal * 0.19;
    var total = subtotal + iva + retencion;

    document.getElementById('subtotal').textContent = '€' + subtotal.toFixed(2);
    document.getElementById('iva').textContent = '€' + iva.toFixed(2);
    document.getElementById('retencion').textContent = '€' + retencion.toFixed(2);
    document.getElementById('total').textContent = '€' + total.toFixed(2);
}

function agregarEventos(fila) {
    var inputs = fila.querySelectorAll('.cantidad, .precio');
    for (var i = 0; i < inputs.length; i++) {
        inputs[i].addEventListener('input', calcularTotales);
    }
}

var filasIniciales = document.querySelectorAll('#tablaItems tr');
for (var i = 0; i < filasIniciales.length; i++) {
    agregarEventos(filasIniciales[i]);
}

calcularTotales();