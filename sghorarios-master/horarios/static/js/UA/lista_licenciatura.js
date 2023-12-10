function elimnar(id, nombre) {
    /**
     * Funcion que emite un mensaje con un link para la eliminación de una unidad de aprendizaje
     * 
     * @param id - identificador del elemento a eliminar
     * @param nombre - Cadena identificadora para complementar el mensaje
     */
    $("#messages").empty()
        .append(`<div class="toast ml-auto" role="alert" data-delay="700" data-autohide="false" style="z-index: 100;">
                    <div class="toast-header">
                        <strong class="mr-auto text-warning">Precaución</strong>
                    </div>
                    <div class="toast-body">Si quieres eliminar a ${nombre} da click en este <a href="../eliminar_licenciatura/${id}/">link</a></div>
                </div>`)
        .children(".toast")
        .toast('show');
}