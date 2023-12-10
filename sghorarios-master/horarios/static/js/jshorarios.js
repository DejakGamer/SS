function recogerDatos() {
    /**
    * Funcion que recoge los datos de la tabla de horarios y los retorna en 
    * un arreglo de diccionarios con la información de cada lapso como profesor
    * unidad de aprendizaje, etc
    * 
    * Retorno:
    *   @return {list} - lista de diccionarios con los datos de la tabla de horarios
    */
    arreglo_temporal = []
    for (let index = 0; index < 6; index++) {
        for (let jndex = 0; jndex < 20; jndex++) {
            var l = $("[coord-X='"+index+"']"+"[coord-Y='"+jndex+"']")
            let ua = l.attr("ua")
            let ds = l.attr("profesor")
            if (ua != '' && ds != '') {
                let x = {profesor: ds, ua: ua, dia:index, hora:jndex}
                arreglo_temporal.push(x)
            }
        }
    }
    return arreglo_temporal;
}

function enviar_horarios(arreglo) {
    /**
    * Funcion que envia los datos obtenidos de la tabla de horarios a la view 
    * correspondiente por medio de una petición ajax
    * 
    * Argumentos:
    *   @param {list} arreglo - arreglo de diccionarios de los horarios
    */
    $.ajax({
        type: 'POST',
        url: `../${values.destino}/`,
        data: {
            arreglo_horarios: JSON.stringify(arreglo),
            licenciatura: values.licenciatura.id,
            semestre: values.semestre,
            siglas: values.siglas,
        },
        success: function (response) {
            location.href="../lista_grupos/"
        },
        error: function (response) {
            alert(response.responseJSON.error);
        }
    })
}


var actual_id = -1;
var grupo = JSON.parse($('#values').text()).siglas;
function getHorario(id, success, time=500) {
    /**
    * Funcion que ejecuta una petición ajax y obtiene el horario del profesor con el identificador
    * recibido en el esperando un tiempo (recibido por parametro) y ejecutando la funcion recibida por 
    * parametro, solo se puede hacer una a la vez. Si se intenta realizar ejecutar esta función mientras 
    * otra ya se esta ejecutando, se cancela la primera, controlado por la variable actual_id. 
    * 
    * Argumentos:
    *   @param {entero} id: identiicador del profesor 
    *   @param {funcion} success - funcion ejecutada que recibira la información recibida en caso de que la
    *       petición ajax se ejecute con exito
    *   @param {int} time - Tiempo que se espera antes de realizar la petición ajax
    */
    actual_id = id;
    console.log(id);
    hilo = setTimeout(function () {
        if (id == actual_id) {
            //$(`[coord-Y=${id}]`).css("background-color", "#ccc");
            $.ajax({
                type: "POST",
                url: "../extraer_horarios_docente/"+id+"/",
                data: {grupo: grupo},
                success: success,
                error:function(response){
                    console.log("Error al buscar horario del id " + id)
                }
            });
        }else{
            console.log("cancelado "+ id);
        }
    }, time);
}

function setDocente(id, docente_td) {
    /**
     * Funcion que limpia la tabla de las celdas con la clase horario_disponible,
     * consigue y muestra el horario del docente en la tabla de horarios y actualiza 
     * el horario maximo y ya asignado de un profesor
     * 
     * Argumentos:
     * @param {int} id - identificador del docente
     * @param {object} docente_td - objeto del la celda del docente en la lista de docentes
     */
    $(".horario_disponible")
        .toggleClass("horario_disponible", false)
        .css("border", "");
    getHorario(id, function (response) {
        let max = response.tipo_docente == 1?30:18;
        let horas_disponibles = response.horas_disponibles_docente/2;
        $(docente_td).parent().find(".min").text(response.horas_asignadas_docente/2);
        $(docente_td).parent().find(".max").text(horas_disponibles>max?max:horas_disponibles);
        llena_tabla_horarios(response.horariodocente);
        actualiza_ua();
    }) 
}

var ua_table = $("#tabla_ua")
function unset_actual_id() {
    /**
     * Se reasigna el valor de la variable actual_id a -1
     */
    actual_id = -1;
}

function getDocentes(texto) {
    /**
     * Función que filtra la lista de docentes en base al texto escrito en el input superio
     * por medio de una petición ajax.
     * 
     * Argumentos:
     * @param {string} texto - Texto con el cual se filtrara la lista de docentes
     */
    $.ajax({
        type: 'POST',
        url: "../extraer_docente/",
        data: {
            query: texto,
        },
        success: function (response) {
            llena_tabla_docente(response.lista)
        },
        error: function (response) {
            $("#tabla_d").empty().append('<tr><th scope="row">Error</th>');
            console.log(response);
        }
    })
}

var tabla = $("#tabla_d");
function llena_tabla_docente(datos) {
    /**
     * Funcón que recibe la información de los docentes y las ordena en la tabla
     * 
     * Argumentos:
     * @param datos - JSON que contiene la información de los docentes
     */
    tabla.empty();
    if (datos.length < 1) {
        tabla.append('<tr><th scope="row">Sin datos</th>');
        return;
    }
    var s = "";
    for (let index = 0; index < datos.length; index++) {
        const docente = datos[index];
        s += `
            <tr>
                <td 
                    class="docente-td" 
                    scope="row" 
                    onclick="select_docente(this, '${docente.id}','${docente.nombre} ${docente.app}' )" 
                    onmouseover="setDocente(${docente.id}, this)" 
                    onmouseleave="unset_actual_id()" 
                    docente_id="${docente.id}">
                    ${docente.nombre} ${docente.app}, ${docente.grado_academico}
                </td>
                <td><span class="min">*</span>/<span class="max">*</span></td>
            </tr>
            `;

    }
    tabla.append(s);
}

var ua_table = $("#tabla_ua")
function select_docente(td, id, nombre) {
    /**
     * Función que muestra en la tabla el horario del docente a la hora de seleccionarlo
     * 
     * Argumentos:
     * @param {Object} td- celda en la lista de docentes para su marcarlo visualmente
     * @param {int} id - identificador del docente
     * @param {string} nombre - nombre del docente
     */
    $(".docente_seleccionado").toggleClass("docente_seleccionado", false)
    $(td).toggleClass("docente_seleccionado", true)
    ua = ua_table.find('input[name="ua"]:checked')
        .parent()
        .parent()
    ua
        .find(".ua_docente")
        .text(nombre)
        .attr("doc_id", id);
    $(".horario_disponible")
        .toggleClass("horario_disponible", false)
        .css("border", "");
    getHorario(id, function (response) {
        ua.find(".horario").text(JSON.stringify(response.horariodocente));
        llena_tabla_horarios(response.horariodocente);
        $(`#horarios_tabla .seleccionado[ua="${ua.attr('ua_id')}"]`).each(function (index, element) {
            if (!$(element).hasClass("horario_disponible")) {
                $(element).css("background-color", "")
                    .toggleClass("seleccionado", false)
                    .attr("profesor", "")
                    .attr("ua", "")
                    .text("");
            }else{
                $(element)
                    .attr("profesor", id)
                    .html(ua.find("label").text() + "</br>·</br>" + response.nombre)
            }
         });
    }, 0);
}

function llena_tabla_horarios(arreglo) {
    /**
     * Función que recibe y muestra una lista de horarios en la tabla de horarios marcando cada celda 
     * con el borde izquierdo en color blanco si la celda tiene un color obscuro en inversa
     * 
     * Argumentos:
     * @param {list} arreglo - Lista con los horarios a mostrar
     */
    Object.keys(arreglo).forEach(element => {
        for (let index = 0; index < arreglo[element].length; index++) {
            for (let jndex =  arreglo[element][index][0]; jndex <= arreglo[element][index][1]; jndex++) {
                $("[coord-X='" + element + "'][coord-Y='"  + jndex + "']")
                    .toggleClass("horario_disponible", true)
                    .each(function (index, celda) {
                        let color = getBrightnes( rgb2hex( $(celda).css("background-color") ) ) < 80? "white":"black";
                        console.log(getBrightnes($(celda).css("background-color")), color);
                        $(celda)
                        .css("border-left-width", "5px")
                        .css("border-left-style", "solid")
                        .css("border-left-color", color)
                    })
            }
        }
    });
}

function getBrightnes(c) {
    /**
     * Funcion que calcula el brillo de un color dado en hexadecimal
     * 
     * Argumentos:
     * @param {string} c - color al cual se le calculará el brillo
     */
    var c = c.substring(1);      // Extraccion del simbolo #
    var rgb = parseInt(c, 16);   // conversion de rrggbb a decimal
    var r = (rgb >> 16) & 0xff;  // extracción del rojo
    var g = (rgb >>  8) & 0xff;  // extracción del verde
    var b = (rgb >>  0) & 0xff;  // extracción del azul

    var luma = 0.2126 * r + 0.7152 * g + 0.0722 * b; // por ITU-R BT.709-6 (https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.709-6-201506-I!!PDF-S.pdf#%5B%7B%22num%22%3A8%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22XYZ%22%7D%2C54%2C770%2C0%5D)
    return luma;
}

function select_ua(ua) {
    /**
     * Funcion que realiza la selección de la Unidad de aprendizaje para su uso en la tabla de horarios
     * y que muestra el horario del docente de la unidad de aprendizaje
     * 
     * Argumentos:
     * @param {object} ua - Objeto de la celda de la unidad de aprendizaje
     */
    $(".docente_seleccionado").toggleClass("docente_seleccionado", false)
    $(".horario_disponible")
        .toggleClass("horario_disponible", false)
        .css("border", "");
    ua = $(ua).parent().parent()
    ua_horario = ua.find(".horario").text()
    if (ua_horario == "") {
        console.log("no hay")
    }else{
        llena_tabla_horarios( JSON.parse( ua.find(".horario").text()) );
    }
}

var hexDigits = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"); 
function rgb2hex(rgb) {
    /**
     * Funcion que convierte un color en formato "rgb(rrr, ggg, bbb) a #hexadecimal"
     * 
     * Argumentos:
     * @param {string} rgb - Cadena con el color en formato "rgb(rrr, ggg, bbb)"
     * 
     * Retorno:
     * @return {string} - Cadena con el color en hexadecimal
     */
    try {
        rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
        return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
    } catch (error) {
        if (error instanceof TypeError) {
            return "#ffffff"
        }else{
            console.log(error);
        }
    }
}


function hex(x) {
    /**
     * Función que evalua si la cadena x es hexadecimal
     * 
     * Argumentos:
     * @param {string} x - cadena a evaluar
     * 
     * Retorno:
     * @return {boolean} True = si, False = no
     */
  return isNaN(x) ? "00" : hexDigits[(x - x % 16) / 16] + hexDigits[x % 16];
 }

function classes(){
    /**
     * Función que muestra en texto de cada celda sus clases 
     */
    $("#horarios_tabla td").each(function (index, elem) {
        $(elem)
        .each((index, element)=>{
            $(element).text($(elem).attr("class"));
        });
    })
}



var values;
$(document).ready(function () {

    /**
     * Bloque que añade el token csrf a la cabecera de cada petición ajax
     * para su reconocimineto en el backend
     */
    var csrftoken = Cookies.get('csrftoken');
    function csrfSafeMethod(method) {
        // these HTTP methods do not require CSRF protection
        return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
    }
    $.ajaxSetup({
        beforeSend: function (xhr, settings) {
            if (!csrfSafeMethod(settings.type) && !this.crossDomain) {
                xhr.setRequestHeader("X-CSRFToken", csrftoken);
            }
        }
    });



    // Extracción de los valores que llegan en caso de haber modificación de horario tal como el horario mismo
    values = JSON.parse($('#values').text()); 
    // Adición de colores aleatorios a la lista de unidades de aprendizaje
    $("[type='color']").each((index, element)=>$(element).attr("value", "#"+Math.floor(Math.random()*16777215).toString(16)) ); 
    // Muestreo del horario a modificar en la tabla de horarios en caso de que exista
    if (typeof values.horario != "undefined"){
        var tabla = $("#horarios_tabla")
        values.horario.forEach(element => {
            for (let index = element.hora_inicio; index < element.hora_final+1; index++) {
                tabla.find(`[coord-X="${element.dia}"][coord-Y="${index}"]`)
                    .attr("ua", element.ua.id)
                    .attr("profesor", element.docente.id)
                    .toggleClass("seleccionado")
                    .html(element.ua.titulo + "</br>·</br>" + element.docente.nombre);
            }
        });
        // Ajuste de la lista de unidades de aprendizaje segun el horario recibido y cambio de color en la tabla de horarios
        $(".ua_id").each(function (index, element) {
            cambia_color_ua($(element).attr("ua_id"), $(element).find(".ua_color").val(), tabla)
            var id_docente = $(`#horarios_tabla [ua='${$(element).attr("ua_id")}']`).first().attr("profesor")
            $.ajax({
                type: "POST",
                url: "../extraer_horarios_docente/"+id_docente+"/",
                data: {grupo: values.siglas},
                success: function (response) {
                    $(element).find(".horario").text(JSON.stringify(response.horariodocente));
                    $(element).find(".ua_docente").text(response.nombre)
                    $(element).find(".ua_docente").attr("doc_id", id_docente);
                },
                error:function(response){
                    console.log("Error al buscar horario del id " + id_docente)
                }
            }); 
        })

    }

    getDocentes("");
    actualiza_ua();
    var isMouseDown = false,esSeleccionado;

    var actual_color = "#fff";
    var actual_ua = "";
    var actual_docente = "";
    var actual_ua_text = "";
    var actual_ua_max;

    var ua_table = $("#tabla_ua")

    // Funcionalidad de selección de la tabla de horarios
    $("#horarios_tabla td") 
        .mousedown(function () {
            esSeleccionado = $(this).hasClass("seleccionado");
            isMouseDown = true;
            if (!esSeleccionado){
                actual_ua = ua_table.find('input[name="ua"]:checked').parent().parent();
                actual_ua_max = actual_ua.find(".max").text();
                if ($(this).hasClass("horario_disponible") && parseInt(actualiza_ua(actual_ua.attr("ua_id"))) < parseInt(actual_ua_max) ) {
                    actual_ua_text = actual_ua.find("label").text();
                    actual_color = actual_ua.find(`.ua_color`).val();

                    actual_docente = actual_ua.find(".ua_docente");
                    $(this).toggleClass("seleccionado", true);
                    esSeleccionado = $(this).hasClass("seleccionado");
                    $(this)
                        .css("background-color", actual_color)
                        .css("color", (getBrightnes(actual_color) < 80)?"white":"black")
                        .attr("profesor", actual_docente.attr("doc_id"))
                        .attr("ua", actual_ua.attr("ua_id"))
                        .html(actual_ua_text + "</br>·</br>" + actual_docente.text());
                }else{
                    return false;
                }
                
            }else{
                $(this).css("background-color", "")
                    .toggleClass("seleccionado", false)
                    .attr("profesor", "")
                    .attr("ua", "")
                    .text("");
                    esSeleccionado = $(this).hasClass("seleccionado");
            }
            return false;
        })
        .mouseover(function () {
            if (isMouseDown) {
                if (esSeleccionado) {
                    if ($(this).hasClass("horario_disponible") && actualiza_ua(actual_ua.attr("ua_id")) < actual_ua_max ) {
                        $(this)
                            .toggleClass("seleccionado", true)
                            .css("background-color", actual_color)
                            .css("color", (getBrightnes(actual_color) < 80)?"white":"black")
                            .attr("profesor", actual_docente.attr("doc_id"))
                            .attr("ua", actual_ua.attr("ua_id"))
                            .html(actual_ua_text + "</br>·</br>" + actual_docente.text())
                            ;
                    }else{
                        return false
                    }
                    
                }else{
                    $(this).css("background-color", "")
                        .toggleClass("seleccionado", false)
                        .attr("profesor", "")
                        .attr("ua", "")
                        .text($(this).attr("class"))
                        .text("")
                        ;
                }
                actualiza_ua();
            }
        })
        .bind("selectstart", function () {
            actualiza_ua();
            return false;
        })

    $(document)
    .mouseup(function () {
        actualiza_ua();
        isMouseDown = false;
    });
    
    $("#print").click(function(){
        $('#tableprint').printThis();
    })
});

function cambia_color_ua(ua, color, tabla) {
    /**
     * Función que ajusta el color las celdas de determinada unidad de aprendizaje en la tabla de horarios
     * 
     * Argumentos:
     * @param {int} ua - Identificador de la unidad de aprendizaje
     * @param {string} color - hexadecimal del color a aplicar
     * @param {object} tabla - Objeto de la tabla de horarios
     */
    tabla.find(`[ua=${ua}]`)
        .css("background-color", color)
        .css("color", (getBrightnes(color) < 80)?"white":"black")
}

var ua_table = $("#tabla_ua")
function actualiza_ua(identificador) {
    /**
     * Función que actualiza las horas seleccionadas de las unidades de aprendizaje en la lista de unidades de aprendizaje
     * y retorna un contador en especifico
     * 
     * Argumentos:
     * @param {int} identificador - Identificador de la unidad de aprendizaje
     * 
     * Retorno:
     * @return {int} - Numero de celdas que existan con el identificador de unidad de aprendizaje
     */
    var ret;
    ua_table.find(".ua_id").each(function (index, element) {
        let ua = $(element);
        ua.find(".min").text($(`[ua='${ua.attr("ua_id")}']`).length/2);
        if (identificador == ua.attr("ua_id")) {
            ret = ua.find(".min").text();
        }
    });
    return ret;
}