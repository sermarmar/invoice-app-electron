function salirFactura(){
    const params = new URLSearchParams(window.location.search);
    const empresaId = params.get('empresa') || '';
    var url = 'factura.html?empresa=' + encodeURIComponent(empresaId);
    window.location.href = url;
}