$.ajax({
    url: 'http://localhost:3001/api/users',
    type: 'GET',
    dataType: 'json',
    success: function(response) {
        $('#listaUsuarios').empty()
        response.forEach(element => {
            $('#listaUsuarios').append(`
                 <div class="col-md-6">
                    <div class="empresa-card text-center" onclick="abrirFactura('${element.id}')">
                        <i class="fas fa-building fa-3x text-primary mb-3"></i>
                        <h3 class="fw-bold">${element.name} ${element.apellidos}</h3>
                        <p class="text-muted mb-2">${element.address}</p>
                        <p class="text-muted mb-2">Tel: ${element.phone}</p>
                    </div>
                </div>
            `)
        });
    },
    error: function(xhr, status, error) {
        
    }
});

function abrirFactura(empresaId) {
    $.ajax({
        url: 'http://localhost:3001/api/users/' + empresaId,
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            sessionStorage.setItem('empresa', JSON.stringify(response))
            var url = 'factura.html?empresa=' + encodeURIComponent(empresaId);
            window.location.href = url;
        },
        error: function(xhr, status, error) {
            
        }
    });
    
}