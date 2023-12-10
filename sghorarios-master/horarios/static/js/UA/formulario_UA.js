
function setOption(selectElement, value) {
    /**
    * Funcion que selecciona una opcion (value) en un objeto selector (selectElement)
    * 
    * Argumentos:
    *   value: opcion a seleccionar
    *   selectElement: objeto selector
    * Retorno:
    *   Booleano: Verdadero si se selecciono satisfactoriamente, falso en caso contrario
    */
    var options = selectElement.options;
    for (var i = 0, optionsLength = options.length; i < optionsLength; i++) {
        if (options[i].value == value) {
            selectElement.selectedIndex = i;
            return true;
        }
    }
    return false;
}

$(document).ready(function() {
    /**
     * Funcion que prepara los selectores con la informacion del periodo y las
     * licenciaturas si es que existen
     */
 
    var licenciatura_json = document.getElementById('licenciatura')
    var licenciatura_s = document.getElementById('licenciatura_s')
    if (licenciatura_json != null) {
        setOption(licenciatura_s, JSON.parse( licenciatura_json.textContent ))
    }
});