function paginator(total = 10, tipo_busqueda="general") {
    /**
     * función que ajusta el paginador mostrando las partes de diez en diez
     * 
     * @param total - total de resultados
     */
    var pag = $(".pagination");
    var query = $("#query").val();
    var s = "";
    pag.empty();
    for (let index = 1; index < (total / 10) + 1; index++) {
        s += `<li class="page-item"><a class="page-link" onclick="getUA('${query}', '${tipo_busqueda}', ${index * 10 - 10}, ${index * 10})">${index}</a></li>`;
    }
    pag.append(s);
}


function llena_tabla(datos) {
    /**
     * Funcón que recibe la información de las unidades de aprendizaje y las ordena en la tabla
     * 
     * @param datos - JSON que contiene la información de las unidades de aprendzaje
     */
    tabla = $("#tabla_contenido");
    if (datos.length < 1) {
        tabla.empty().append('<tr><th scope="row" colspan="5">Sin datos</th>');
        return;
    }
    tabla.empty();
    var s = "";
    for (let index = 0; index < datos.length; index++) {
        const unidad = datos[index];
        s += `
            <tr>
                <th>`+ unidad.titulo + `</th>
                <td>`+ unidad.semestre + `</td>
                <td>`+ unidad.horas + `</td>
                <td>`+ unidad.licenciatura + `</td>
                <td>
                    <div class="dropdown">
                        <button class="btn grenncolor text-white btn-sm dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
                            Acciones
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                            <li><a class="dropdown-item" href="../modificacion_UA/${unidad.id}">Editar</a></li>
                            <li><a class="dropdown-item" onclick="elimnar(${unidad.id},'${unidad.titulo}')">Eliminar</a></li>
                        </ul>
                    </div>
                </td>
            </tr>
            `;

    }
    tabla.append(s);
}


function getUA(texto = "", tipo_busqueda="general", first = 0, last = 10) {
    /**
    * Función que extrae un rango de información de las unidades de aprendizaje con información similar al
    *   texto por medio de una petición ajax y caso de que se ejecute con exito se llenara la tabla con la 
    *   información extraida y se llamara a la función que ajusta el paginador.
    * 
    * @param {string} texto - que se enviara
    * @param {number} first - primer limitador
    * @param {number} last - ultimo limitador
    */
    $.ajax({
        type: 'POST',
        url: "../extraer_UA/",
        data: {
            query: texto,
            tipo_busqueda: tipo_busqueda,
            first: first,
            last: last
        },
        success: function (response) {
            llena_tabla(response.lista)
            paginator(response.cantidad, tipo_busqueda)
        },
        error: function (response) {
            $("#tabla_contenido").empty().append('<tr><th scope="row" colspan="10">Error</th>');
            console.log(response);
        }
    })
}


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
                    <div class="toast-body">Si quieres eliminar a la unidad ${nombre} da click en este <a href="../eliminar_UA/${id}/">link</a></div>
                </div>`)
        .children(".toast")
        .toast('show');
}


$(document).ready(function () {
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

    getUA("", $('#tipoDbusqueda').val(), 0, 10);
});