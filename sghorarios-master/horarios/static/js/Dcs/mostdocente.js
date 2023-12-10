/**
 * Script que permite mostrar en tabla del horario el horario disponible del docente 
 */

var horarios_json = document.getElementById('horario')

var arreglo =  JSON.parse( horarios_json.textContent )


Object.keys(arreglo).forEach(element => {
    //console.log(element);
    for (let index = 0; index < arreglo[element].length; index++) {
        //console.log(arreglo[element][index]);
        for (let jndex =  arreglo[element][index][0]; jndex <= arreglo[element][index][1]; jndex++) {
            $("[coord-x='" + element + "'][coord-y='"  + jndex + "']").toggleClass("vicdos", true);
        }
    }
});


//$('[coord-x ="1"]').toggleClass("bg-dark");