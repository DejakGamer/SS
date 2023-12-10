function elimnar(id, nombre) {
    /**
     * Funcion que muestra un toast para confirmación de eliminar al grupo y redirige a la view para eliminarlo
     * @param id: identificar del grupo
     * @param nombre: siglas del grupo
     */
    $("#messages").empty()
        .append(`<div class="toast ml-auto" role="alert" data-delay="100000" data-autohide="false" style="z-index: 100;">
                    <div class="toast-header">
                        <strong class="mr-auto text-warning">Precaución</strong>
                    </div>
                    <div class="toast-body">Si quieres eliminar al grupo: ${nombre}, da click en este <a href="../eliminar_horario_grupo/?id=${id}">link</a></div>
                </div>`)
        .children(".toast")
        .toast('show');
}
(function () {
  'use strict'
  /**
   * Funcion de bootstrap para funcionen las validaciones del formulario
   */
  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  var forms = document.querySelectorAll('.needs-validation')

  // Loop over them and prevent submission
  Array.prototype.slice.call(forms)
    .forEach(function (form) {
      form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }

        form.classList.add('was-validated')
      }, false)
    })
})()