/**
 * Script que pertime obtener los horarios asignados al docente y poder mostrarlos en la tabla del horario
 * correspondiente a su grupo, materia y semestre
 */

var horarios_json = document.getElementById('horario')

var arreglo =  JSON.parse( horarios_json.textContent )
var tabla = $("#our_table");
for(let horario_id = 0; horario_id < arreglo.length; horario_id++){
    let horario = arreglo[horario_id];
    for(let horas = horario.hora_inicio; horas <= horario.hora_final; horas++){
        tabla.find("[coord-x='" + horario.dia + "'][coord-y='"  + horas + "']")
        .toggleClass("vicdos").css("color", "#fff")
        .html("Grupo: " + horario.grupo + "<br> " +horario.unidadAprendizaje + "<br> Semestre: " + horario.semestre)
        ;
    }
}
//Object.keys(arreglo).forEach(element => {
    //console.log(element);
    //for (let index = 0; index < arreglo[element][0].length; index++) {
        //console.log(arreglo[element][0][index]);
        //for (let jndex =  arreglo[element][0][index][0]; jndex <= arreglo[element][0][index][1]; jndex++) {
            //console.log(jndex);
            //$("[coord-x='" + element + "'][coord-y='"  + jndex + "']")
            //.toggleClass("vicdos").css("color", "#fff")
            //.html("Grupo: " + arreglo[element][1][index][0] + "<br> " +arreglo[element][1][index][1] + "<br> Semestre: " + arreglo[element][1][index][2])
            //;
        //}
    //}
//});