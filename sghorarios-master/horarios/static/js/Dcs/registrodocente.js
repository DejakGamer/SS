function limpiar() {
    /**
     * Funcion que limpia unicamente los inputs del formulario
     */
    var l = document.getElementsByClassName("form-control");
    for(var i = 0; i < l.length; i++) {
        l[i].value = "";
    }
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
$(function () {
  /**
   * Funcion que permite darle funcionalidad al puntero de seleccionar los horarios de la tabla de horarios
   */
  var isMouseDown = false,isHighlighted;
  $("#our_table td")
    .mousedown(function () {
      isMouseDown = true;
      $(this).toggleClass("vicdos");
      isHighlighted = $(this).hasClass("vicdos");
      /* if (isHighlighted) {
        $(this).css("background-color", $("#input_nombre").val());
        $(this).text($("#input_app").val());
        
      }else{
        $(this).css("background-color", "")
        $(this).text("");
      } */
      return false; // prevent text selection
    })
    .mouseover(function () {
      if (isMouseDown) {
        $(this).toggleClass("vicdos", isHighlighted);
        /* if (isHighlighted) {
          $(this).css("background-color", $("#input_nombre").val());
          $(this).text($("#input_app").val());
        }else{
          $(this).css("background-color", "")
          $(this).text("");
        } */
      }
    })
    .bind("selectstart", function () {
      return false;
    })

  $(document)
    .mouseup(function () {
      isMouseDown = false;
    });
});


function getHours() {
  /**
   * Funcion que permite obtener los horarios seleccionados de la tabla de horarios
   * permitiendo agregarlos a un arreglo que contiene el dia, y la hora en que esta seleccionado en la tabla 
   */
  var array = [];
  for (let i_index = 0; i_index <= 5; i_index++) {
    let coord_X = $("#our_table [coord-X='"+i_index+"']")
    let str = "dia "+i_index+": "
    for (let j_index = 0; j_index <= 19; j_index++) {
      if (coord_X.eq(j_index).hasClass("vicdos")) {
        str += j_index+" | "
      }

    }
    array[i_index] = str;
  }
  return array;
}

function gsHorarios() {
  /**
   * Funcion que manda llamar a la accion de obtener los horarios y mandarlos a un imput hidden para que sean enviados
   * a la view para guardar la información
   */
  var x = document.getElementById("horarioDisp");
  x.value = getHours()
}
