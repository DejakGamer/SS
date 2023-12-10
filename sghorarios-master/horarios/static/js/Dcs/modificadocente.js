$(document).ready(function() {
    /**
     * Funcion que prepara los selectores con la informacion del periodo y las
     * licenciaturas si es que existen
     */
    var coordinador_json = document.getElementById('coordinador')
    var coordinador_s = document.getElementById('coordinador_s')
    if (coordinador_json != null) {
        setOption(coordinador_s, JSON.parse( coordinador_json.textContent ))
    }
});