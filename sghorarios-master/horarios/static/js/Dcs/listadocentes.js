function elimnar(id, nombre) {
    /** 
     * Funcion que inserta un toast para enviar un mensaje si esta seguro eliminar al docente seleccionado y
     * llama mediante el link a la view de eliminar
     * @params id: id del docente, nombre: nombre del docente
    */
    $("#messages").empty()
        .append(`<div class="toast ml-auto" role="alert" data-delay="100000" data-autohide="false" style="z-index: 100;">
                    <div class="toast-header">
                        <strong class="mr-auto text-warning">Precaución</strong>
                    </div>
                    <div class="toast-body">Si quieres eliminar a ${nombre} da click en este <a href="../eliminacion_docente/?id=${id}">link</a></div>
                </div>`)
        .children(".toast")
        .toast('show');
}
function elimnarHD() {
    /**
     * Funcion que permite enviar un toast que dirige a la view para eliminar todos los horarios dispibles de los docentes
     * mediante los mensajes
     */
    $("#messages").empty()
        .append(`<div class="toast ml-auto" role="alert" data-delay="100000" data-autohide="false" style="z-index: 100;">
                    <div class="toast-header">
                        <strong class="mr-auto text-danger">PRECAUCION EXTREMA</strong>
                    </div>
                    <div class="toast-body">Si quieres eliminar todos los horarios disponibles de los docentes da click en este <a href="../eliminar_horarios_disponibles/">link</a></div>
                </div>`)
        .children(".toast")
        .toast('show');
}
function llena_tabla(datos){
    /**
    * Funcón que recibe la información de las unidades de aprendizaje y las ordena en la tabla
    * 
    * @param datos - JSON que contiene la información de las unidades de aprendzaje
    */
    tabla = $("#tabla_contenido");
    if (datos.length < 1) {
        tabla.empty().append('<tr><th scope="row" colspan="6">Sin datos</th>');
        return;
    }
    tabla.empty();
    var s = "";
    for (let index = 0; index < datos.length; index++) {
        const docen = datos[index];
        let activo = ""
        if(docen.activo == "checked"){
            activo = "bg-success"
        }
        s += `
            <tr>
                <th scope="row">${docen.grado_academico}</th>
                <td>${docen.first_name}</td>
                <td>${docen.last_name}</td>
                <td>${docen.email}</td>
                <td>${docen.tipo_de_docente}</td>
                <td><input class="form-check-input ${activo}" type="checkbox" value="" id="flexCheckChecked" ${docen.activo} disabled></td>
                <td>
                    <div class="dropdown">
                        <button class="btn grenncolor text-white btn-sm dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
                            Acciones
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                            <li><button class="dropdown-item" onclick="location.href ='../modificacion_docente?id=${docen.id}'">Modificación de Docente</button></li>
                            <li><button class="dropdown-item" onclick="location.href ='../horario_asignado?id=${docen.id}&ul=lista_docente'">Consultar Horario Asignado</button></li>
                            <li><button class="dropdown-item" onclick="location.href ='../modificacion_horario_docente?id=${docen.id}'">Modificar Horario</button></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><button class="dropdown-item" onclick="elimnar(${docen.id}, '${docen.first_name} ${docen.last_name}')">Eliminar Docente</button></li>
                        </ul>
                    </div>
                </td>
            </tr>

            `;

    }
    tabla.append(s);
}
function getDsc(texto){
    /**
     * Función de respuesta ajax para obtener de la lista de docentes el listado de coincidencias de la busqueda
     * insertada y realizada, obteniendo los datos y mandando llamar a llena_tabla() para mostrar los datos
     * @param texto: el texto intertado en la busqueda
     */
    $.ajax({
        type: 'POST',
        url: "../extraer_Dcs_A/",
        data: {
            query: texto
        },
        success: function (response) {
            llena_tabla(response.lista)
        },
        error: function (response) {
            $("#tabla_contenido").empty().append('<tr><th scope="row" colspan="10">Error</th>');
            console.log(response);
        }
    })
}

$(document).ready(function () {
    /**
     * Funcion que obtiene permite hacer peticiones ajax, para que el sistema permita al usuario realizar estas 
     * peticiones obteniendo la cooki que usa django para hacer peticiones y reconocerte como usuario logeado
     * para las peticiones
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

    getDsc("");
});