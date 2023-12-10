from django.shortcuts import render, get_object_or_404, redirect
from django.http import HttpResponse, JsonResponse
from horarios.models import Licenciatura, UnidadAprendizaje, Coordinador
from pprint import pprint
from django.contrib import messages
from django.contrib.auth.models import User, Group
from django.db.utils import DatabaseError, DataError
from django.utils.datastructures import MultiValueDictKeyError
from django.db.models import Q, F, Func, Value as V
from django.db.models.functions import Concat
from django.db.models.fields import CharField
from django.contrib.auth.decorators import permission_required, login_required, user_passes_test
import re


############## funciones chiquitas 👉👈 ###################
def regex(p, s):
    """Funcion que evalua una cadena con una exprsión regular dada y retorna verdadero en 
        caso de coincidir y falso en caso contrario

    Args:
        p (cadena): Expresión regular
        s (cadena): cadena a evaluar

    Returns:
        boolean: Respuesta de si la expresion regular coincide o no con la cadena
    """
    if re.match(p, s):
        return True
    else:
        return False

def getDataFromResponse(values, method, request):
    """Función que intenta extraer una lista de elementos del objeto respuesta, y en caso de no 
        existir, genera un mensaje al request por cada elemento no existente, junto con los elementos
        extraidos.

    Args:
        --values (list): Lista bidimensional con una estructura similar a los
            siguientes ejemplos por cada elemento:
            ["CABECERA",    "TITULO_DE_INTERFAZ",   "TIPO_DE_DATO",    "PATRON"]
            ["CABECERA",    "TITULO_DE_INTERFAZ",   "TIPO_DE_DATO",    MINIMO, MAXIMO]
            En donde 
            CABECERA (cadena): (de tipo cadena) sera la llave en el objeto method.
            TITULO_DE_INTERFZA (cadena): texto con el que se mostrara a en los mensajes de interfaz, los cuales se 
                mostrarán como "Olvidaste especificar TITULO_DE_INTERFAZ" o "Hay un error con TITULO_DE_INTERFAZ".
            TIPO_DE_DATO (str o int): tipo de dato que se extraera.
            PATRON (cadena): Expresión regular que debera cumplir, este dato se debera de enviar en caso
                de que se vaya a recibir una cadena.
            MAXIMO y MINIMO (enteros): Maximo y minimo en caso de que se vaya a recibir un entero.
        --method (request.QueryDict): Un objeto similar a un diccionario que contiene todos los parámetros HTTP POST o GET 
            dados, siempre que la solicitud contenga datos de formulario.
        --request (request): Objeto de peticion en donde se vana a alamacenar los mensajes de error

    Returns:
        lista: contiene los valores extraidos del objeto de solicitud
        entero: numero de mensajes de error generados
    """
    v = {}
    num_messages = 0
    for value in values:
        try:
            if method[value[0]] not in ["", [], None]:
                try:
                    if value[2] == str:
                        if not regex(value[3], method[ value[0] ]):
                            value[1] = f"Hay un error con {value[1]}"
                            raise ValueError(value[1])
                    if value[2] == int:
                        if not ( int(method[ value[0] ]) >= value[3] and int(method[ value[0] ]) <= value[4]):
                            value[1] = f"Hay un error con {value[1]}"
                            raise ValueError(value[1])
                except IndexError as indexError:
                    pass
                v[value[0]] = method[value[0]]
            else:
                value[1] = "Olvidaste especificar "+value[1]
                raise ValueError(value[1])
        except ValueError as valueError:
            print(f"ERROR: {valueError}")
            num_messages -=- 1
            messages.add_message(request, messages.ERROR, value[1], extra_tags='Error')
        except MultiValueDictKeyError as mvdke: 
            value[1] = "Olvidaste especificar "+value[1]
            print(f"ERROR: {value[1]}")
            num_messages -=- 1
            messages.add_message(request, messages.ERROR, value[1], extra_tags='Error')
        except Exception as e: 
            print(f"ERROR: {e}")
            num_messages -=- 1
            messages.add_message(request, messages.ERROR, e, extra_tags='Error')
    return v, num_messages
            


############## Views ###################
@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def registro_UA(request):
    """Vista que muestra el formulario de unidades de aprendizaje para su registro

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template tales como la lista de licenciaturas y el titulo de la pagina y la view
            a donde se enviara la información para su registro.
    """
    
    lic = None
    try:
        lic = request.user.coordinador.licenciatura_set.all()
        if not lic.exists() and request.user.groups.filter(name="Academico").exists():
            lic = Licenciatura.objects.all()
    except User.coordinador.RelatedObjectDoesNotExist:
        if request.user.groups.filter(name="Academico").exists() or request.user.is_staff:
            lic = Licenciatura.objects.all()

    variables = {
        "licenciaturas":lic,
        "titulo":"Registro de Unidades de aprendizaje",
        "destino":"guardar_registro_UA"
        }
    return render(request, 'UA/formulario_UA.html', variables)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def guardar_registro_UA(request):
    """Vista que recibe y registra la información de las unidades de aprendizaje en la base de datos.

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente, de aqui salen los datos recibidos de la unidad de aprendizaje
        a registrar.

    Returns:
        [HttpResponseRedirect]: Objeto repsuesta proporcionado por la función redirect, el cual redirigira 
        a la vista "registro_UA", en caso de que la información tenga algo erroneo se redirigirá con los 
        mensajes correspondientes, en caso contrario se registrara la unidad de aprendizaje y se redirigira
        con mensaje de registro exitosos.
    """
    values = {}
    if request.method == 'POST':
        values, numero_mensjes = getDataFromResponse([
            ["titulo",          "el titulo",            str,    r"^[A-Za-zÀ-ÿ0-9()& \-,\s]{3,99}$"], 
            ["semestre",        "el semestre",          int,    0, 11], 
            ["horas",           "las horas",            int,    0, 10000], 
            ["licenciatura",    "la licenciatura"       ]], request.POST, request)
        try:
            UnidadAprendizaje.objects.filter(licenciatura__id=values["licenciatura"]).get(titulo=values["titulo"])
            messages.add_message(request, messages.ERROR, "Esa unidad ya existe", "Error en la información")
            return redirect("registro_UA")
        except UnidadAprendizaje.DoesNotExist:
            pass
        except Exception as exception:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {type(exception)}", extra_tags="Error desconocido")
            return redirect("registro_UA")
        if numero_mensjes > 0:
            return redirect('registro_UA')
        try:
            values["licenciatura"] = Licenciatura.objects.get(id=values["licenciatura"])
        except:
            messages.add_message(request, messages.ERROR, "Hubo un error con la licenciatura", extra_tags="Error en la información")
            return redirect('registro_UA')
        
        
        ua = UnidadAprendizaje(
            titulo = values["titulo"],
            semestre = values["semestre"],
            horas = values["horas"],
            licenciatura = values["licenciatura"]
        )
        try:
            ua.save()
            messages.add_message(request, messages.SUCCESS, "Se registro a "+values["titulo"], extra_tags="Unidad de aprendizaje registrada")
        except ValueError as valueError:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {valueError}", extra_tags="Error en la información")
        except DataError as dataError:
            messages.add_message(request, messages.ERROR, f"Codigo de error: {dataError.args[0]}", extra_tags="Error en la información")
        except DatabaseError as dataBaseError:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {dataBaseError}", extra_tags="Error con base de datos")
        except Exception as exception:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {exception}", extra_tags="Error desconocido")

    return redirect('registro_UA')

@login_required()
@user_passes_test(lambda u: u.groups.filter(name='Academico').exists())
def registro_licenciatura(request):
    """Vista que muestra el formulario de licenciatura para su registro

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de licenciatura y elementos que utilizara 
            el template tales como la lista de coordinadores, el titulo de la pagina y la view a donde
            se enviara la información para su registro.
    """
    variables = {
        "coordinadores":Coordinador.objects.all(),
        "titulo":"Registro de Licenciaturas",
        "destino":"guardar_registro_licenciatura"
        }
    return render(request, 'UA/formulario_licenciatura.html', variables)
    
@login_required()
@user_passes_test(lambda u: u.groups.filter(name='Academico').exists())
def guardar_registro_licenciatura(request):
    """Vista que recibe y registra la información de las licenciaturas en la base de datos.

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente, de aqui salen los datos recibidos de la licenciatura a registrar.

    Returns:
        [HttpResponseRedirect]: Objeto repsuesta proporcionado por la función redirect, el cual redirigira 
        a la vista "registro_licenciatura", en caso de que la información tenga algo erroneo se redirigirá 
        con los mensajes correspondientes, en caso contrario se registrara la licenciatura  y se redirigira
        con mensaje de registro exitosos.
    """
    values = {}
    if request.method == 'POST':
        #pepe = request.POST["pepe"]
        values, num_messages = getDataFromResponse([
            ["nombre",          "el nombre",    str,    r"^[A-Za-zÀ-ÿ&\-\s]{3,99}$"], 
            ["siglas",          "las siglas",   str,    r"^[A-Z]{2,4}$"], 
            ["version",         "la version",   int,    0, 10000],
            ["coordinador",     "el coordinador"]], request.POST, request)
        if num_messages > 0:
            return redirect('registro_licenciatura')
        if Licenciatura.objects.filter( siglas=values["siglas"], version=values["version"] ).exists():
            messages.add_message(request, messages.ERROR, "Esa licenciatura y version ya estan registradas con otra licenciatura", extra_tags="Error")
            return redirect('registro_licenciatura')
        try:
            values["coordinador"] = Coordinador.objects.get(id=values["coordinador"])
        except:
            messages.add_message(request, messages.ERROR, "Hubo un error con el coordinador", extra_tags="Error en la información")
            return redirect('registro_licenciatura')
        licenciatura = Licenciatura(
            nombre = values["nombre"],
            version= values["version"],
            siglas = values["siglas"],
            coordinador = values["coordinador"]
        )
        try:
            licenciatura.save()
            messages.add_message(request, messages.SUCCESS, "Se registro a "+licenciatura.nombre, extra_tags="Licenciatura registrada")
        except ValueError as valueError:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {valueError}", extra_tags="Error en la información")
        except DataError as dataError:
            messages.add_message(request, messages.ERROR, f"Codigo de error: {dataError.args[0]}", extra_tags="Error en la información")
        except DatabaseError as dataBaseError:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {dataBaseError}", extra_tags="Error con base de datos")
        except Exception as exception:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {exception}", extra_tags="Error desconocido")
    return redirect('registro_licenciatura')


@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def lista_UA(request):
    """Vista que muestra la lista de unidades de aprendizaje

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request y la template de la lista unidades de aprendizaje.
    """
    return render(request, 'UA/lista_UA.html')


@login_required()
@user_passes_test(lambda u: u.groups.filter(name='Academico').exists())
def lista_licenciatura(request):
    """Vista que muestra la lista de licenciaturas

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template de la lista licenciaturas y un diccionario con una lista 
            de las licenciaturas.
    """
    variables = {"licenciaturas":Licenciatura.objects.all()}
    return render(request, 'UA/lista_licenciatura.html', variables)


@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def modificacion_UA(request, identificador):
    """Vista que muestra el formulario de unidades de aprendizaje para su modificación

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
            la peticion del cliente.
        identificador (int): Número identificador de la unidad de aprendizaje para su modificación 

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template tales como la información de la unidad de aprendizaje, la lista de coordinadores,
            el titulo de la pagina, la lista de licenciaturas y la view a donde se enviara la información
            para su modificación.
            En caso de no encontrar la unidad de aprendizaje se le redirigira a la pagina de error 404.
    """
    ua = get_object_or_404(UnidadAprendizaje, pk=identificador)
    lic = None
    try:
        lic = request.user.coordinador.licenciatura_set.all()
        if not lic.exists() and request.user.groups.filter(name="Academico").exists():
            lic = Licenciatura.objects.all()
    except User.coordinador.RelatedObjectDoesNotExist:
        if request.user.groups.filter(name="Academico").exists() or request.user.is_staff:
            lic = Licenciatura.objects.all()

    variables = {
        "ua":ua,
        "titulo":'Modificacion de "'+ua.titulo+'" (Unidad de Aprendizaje)',
        "licenciaturas": lic,
        "destino":"guardar_modificacion_UA"
        }
    return render(request, 'UA/formulario_UA.html', variables)
    
@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def guardar_modificacion_UA(request):
    """Vista que recibe y modifica la información de la unidad de aprendizaje en la base de datos.

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente, de aqui salen los datos recibidos de la unidad de aprendizaje
        a modificar.

    Returns:
        [HttpResponseRedirect]: Objeto repsuesta proporcionado por la función redirect, el cual redirigira 
        a la vista "modificacion_UA", en caso de que la información tenga algo erroneo se redirigirá con los 
        mensajes correspondientes, en caso contrario se modificara la unidad de aprendizaje y se redirigira
        con mensaje de modificación exitosos.
        En caso de no encontrar la unidad de aprendizaje se le redirigira a la pagina de error 404.
    """
    values = {}
    #a = request.POST["pepe"]
    if request.method == 'POST':
        values, num_messages = getDataFromResponse([ 
            ["id",              "el identificador"],
            ["titulo",          "el titulo",            str,    r"^[A-Za-zÀ-ÿ0-9()& \-,\s]{3,99}$"],
            ["semestre",        "el semestre",          int,    0, 11], 
            ["horas",           "las horas",            int,    0, 10000], 
            ["licenciatura",    "la licenciatura"       ]], request.POST, request)
        if num_messages > 0:
            return redirect('modificacion_UA', values["id"])
        try:
            values["licenciatura"] = Licenciatura.objects.get(id=values["licenciatura"])
        except:
            messages.add_message(request, messages.ERROR, "Hubo un error con la licenciatura", extra_tags="Error en la información")
            return redirect('modificacion_UA', values["id"])
        
        
        ua = get_object_or_404(UnidadAprendizaje, pk=values["id"])
        ua.titulo = values["titulo"]
        ua.semestre = values["semestre"]
        ua.horas = values["horas"]
        ua.licenciatura = values["licenciatura"]
        try:
            ua.save()
            messages.add_message(request, messages.SUCCESS, "Se modifico a "+values["titulo"], extra_tags="Unidad de aprendizaje modificada")
        except ValueError as valueError:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {valueError}", extra_tags="Error en la información")
        except DataError as dataError:
            messages.add_message(request, messages.ERROR, f"Codigo de error: {dataError.args[0]}", extra_tags="Error en la información")
        except DatabaseError as dataBaseError:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {dataBaseError}", extra_tags="Error con base de datos")
        except Exception as exception:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {exception}", extra_tags="Error desconocido")

    return redirect('modificacion_UA', values["id"])


@login_required()
@user_passes_test(lambda u: u.groups.filter(name='Academico').exists())
def modificacion_licenciatura(request, identificador):
    """Vista que muestra el formulario de licenciatura para su modificación.

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de licenciatura y elementos que utilizara el template
            tales como la información de la licenciatura a modificar, el titulo de la pagina y la view
            a donde se enviara la información para su modificación.
            En caso de no encontrar la licenciatura se le redirigira a la pagina de error 404.
    """
    licenciatura = get_object_or_404(Licenciatura, pk=identificador)
    variables = {
        "licenciatura":licenciatura,
        "titulo":f'Modificacion de "{licenciatura.nombre} - {licenciatura.version}" (licenciatura)',
        "destino":"guardar_modificacion_licenciatura",
        "coordinadores":Coordinador.objects.all()
        }
    return render(request, 'UA/formulario_licenciatura.html', variables)
    

@login_required()
@user_passes_test(lambda u: u.groups.filter(name='Academico').exists())
def guardar_modificacion_licenciatura(request):
    """Vista que recibe y modifica la información de la licenciatura en la base de datos.

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente, de aqui salen los datos recibidos de la licenciatura a modificar.

    Returns:
        [HttpResponseRedirect]: Objeto repsuesta proporcionado por la función redirect, el cual redirigira 
        a la vista "modificacion_licenciatura", en caso de que la información tenga algo erroneo se redirigirá 
        con los mensajes correspondientes, en caso contrario se modiificara la licenciatura  y se redirigira
        con mensaje de modificación exitosos.
        En caso de no encontrar la licenciatura se le redirigira a la pagina de error 404.
    """
    values = {}
    if request.method == 'POST':
        values, num_messages = getDataFromResponse([
            ["id",              "el identificdor"], 
            ["nombre",          "el nombre",    str,    r"^[A-Za-zÀ-ÿ&\-\s]{3,99}$"], 
            ["siglas",          "las siglas",   str,    r"^[A-Z]{2,4}$"], 
            ["version",         "la version",   int,    0, 10000],
            ["coordinador",     "el coordinador"]], request.POST, request)
        if num_messages > 0:
            return redirect('modificacion_licenciatura', values["id"])
        licenciatura = None
        try:
            licenciatura = Licenciatura.objects.get( siglas=values["siglas"], version=values["version"])
            if values["id"] != str(licenciatura.id):
                messages.add_message(request, messages.ERROR, "Esa licenciatura y version ya estan registradas con otra licenciatura", extra_tags="Error")
                return redirect('modificacion_licenciatura', values["id"])
        except Licenciatura.MultipleObjectsReturned as mOR:
            messages.add_message(request, messages.ERROR, f'Licenciatura "{values["siglas"]} - {values["version"]}" repetida en base de datos', extra_tags="Error en la base de datos")
            return redirect('modificacion_licenciatura', values["id"])
        except Licenciatura.DoesNotExist as dNE:
            licenciatura = get_object_or_404(Licenciatura, id=values["id"])
        except Exception as e:
            print(type(e))
            messages.add_message(request, messages.ERROR, f"Mensaje del error: {e}", extra_tags="Error desconocido")
            return redirect('modificacion_licenciatura', values["id"])
        try:
            values["coordinador"] = Coordinador.objects.get(id=values["coordinador"])
        except Coordinador.DoesNotExist:
            messages.add_message(request, messages.ERROR, "El coordinador no se encontro", extra_tags="Error en la información")
            return redirect('modificacion_licenciatura', values["id"])
        except Exception as e:
            messages.add_message(request, messages.ERROR, f"Mensaje del error: {e}", extra_tags="Error desconocido")
            return redirect('modificacion_licenciatura', values["id"])

        
        licenciatura.nombre = values["nombre"]
        licenciatura.version = values["version"]
        licenciatura.siglas = values["siglas"]
        licenciatura.coordinador = values["coordinador"]
        try:
            licenciatura.save()
            messages.add_message(request, messages.SUCCESS, "Se actualizo a "+licenciatura.nombre+" - "+licenciatura.version, extra_tags="Licenciatura registrada")
        except ValueError as valueError:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {valueError}", extra_tags="Error en la información")
        except DataError as dataError:
            messages.add_message(request, messages.ERROR, f"Codigo de error: {dataError.args[0]}", extra_tags="Error en la información")
        except DatabaseError as dataBaseError:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {dataBaseError}", extra_tags="Error con base de datos")
        except Exception as exception:
            messages.add_message(request, messages.ERROR, f"Mensaje de error: {exception}", extra_tags="Error desconocido")

    return redirect('modificacion_licenciatura', values["id"])


@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def eliminar_UA(request, identificador):
    """Funcion que elimina la unidad de aprendizaje con el id igual a identificador

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
            la peticion del cliente.
        identificador (int): Numero con el cual se buscara la unidad de aprendizaje a eliminar

    Returns:
        [HttpResponseRedirect]: Objeto repsuesta proporcionado por la función redirect, el cual redirigira 
            a la vista "lista_UA", en caso de que la información tenga algo erroneo se redirigirá 
            con los mensajes correspondientes, en caso contrario se eliminara la unidad de aprendizaje y se redirigira
            con mensaje de eliminación correcta.
            En caso de no encontrar la unidad de aprendizaje se le redirigira a la pagina de error 404.
    """
    try:
        ua = UnidadAprendizaje.objects.get(id=identificador)
        messages.add_message(request, messages.SUCCESS, f"Se elimino la unidad {ua.titulo}", extra_tags="Eliminacion correcta")
        ua.delete()
    except UnidadAprendizaje.DoesNotExist:
        messages.add_message(request, messages.ERROR, f"La unidad con el id {identificador} no existe", extra_tags="Error en la eliminacion")
    except Exception as exception:
            messages.add_message(request, messages.ERROR, f"Mensaje del error: {exception}", extra_tags="Error desconocido")
    return redirect("lista_UA")

@login_required()
@user_passes_test(lambda u: u.groups.filter(name='Academico').exists())
def eliminar_licenciatura(request, identificador):
    """Funcion que elimina la licenciatura con el id igual a identificador

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
            la peticion del cliente.
        identificador (int): Numero con el cual se buscara la licenciatura a eliminar

    Returns:
        [HttpResponseRedirect]: Objeto repsuesta proporcionado por la función redirect, el cual redirigira 
            a la vista "lista_licenciatura", en caso de que la información tenga algo erroneo se redirigirá 
            con los mensajes correspondientes, en caso contrario se eliminara la licenciatura y se redirigira
            con mensaje de eliminación correcta.
    """
    try:
        licenciatura = Licenciatura.objects.get(id=identificador)
        messages.add_message(request, messages.SUCCESS, f"Se elimino la licenciatura {licenciatura.nombre}", extra_tags="Eliminacion correcta")
        licenciatura.delete()
    except Licenciatura.DoesNotExist:
        messages.add_message(request, messages.ERROR, f"La licenciatura con el id {identificador} no existe", extra_tags="Error en la eliminacion")
    except Exception as exception:
        messages.add_message(request, messages.ERROR, f"Mensaje del error: {exception}", extra_tags="Error desconocido")
    return redirect("lista_licenciatura")


############## PETICIONES AJAX ###################
def extraer_UA(request):
    """Vista que retorna la información de un rango de unidades de aprendizaje con titulo, periodo, siglas de la
    licenciatura o semestre similar a la cadena "query" proporcionada por el request 

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
            la peticion del cliente, de aqui sale los datos:
            query: cadena con el que se buscaran las unidades de aprendizaje con titulo, periodo, siglas de la
                licenciatura o semestre similar 
            first: entero que proporciona el primer limite del rango de licenciaturas que coinciden
            last: entero que proporciona el ultimo limite del rango de licenciaturas que coinciden 

    Returns:
        [JsonResponse]: Objeto subclase de HttpResponse que ayuda a crear una respuesta JSON con la información
            de las unidades de aprendizaje coincidentes, con estado 200 (estado de respuesta HTTP satisfactorio)
    """
    if request.is_ajax and request.method == "POST":
        query = request.POST.get("query", None).upper()
        tipo_busqueda = request.POST.get("tipo_busqueda", "general")
        first = request.POST.get("first", 0)
        last = request.POST.get("last", 10)
        respuesta = []
        
        ua = None
        try:
            ua = UnidadAprendizaje.objects.filter(licenciatura__coordinador=request.user.coordinador)
            if not ua.exists() and request.user.groups.filter(name="Academico").exists():
                ua = UnidadAprendizaje.objects.all()
        except User.coordinador.RelatedObjectDoesNotExist:
            if request.user.groups.filter(name="Academico").exists() or request.user.is_staff:
                ua = UnidadAprendizaje.objects.all()
        if tipo_busqueda == "general" or tipo_busqueda == "":
            ua = ua\
                .annotate(mayusculas_titulo=Func( F('titulo'), function='UPPER') )\
                .annotate(mayusculas_licenciatura=Func( F('licenciatura__siglas'), function='UPPER') )\
                .filter(
                    Q(mayusculas_titulo__contains=query)|
                    Q(mayusculas_licenciatura__contains=query)|
                    Q(semestre__contains=query)
                    )\
                .order_by('titulo')
        elif tipo_busqueda == "titulo":
            ua = ua.annotate(mayusculas_titulo=Func( F('titulo'), function='UPPER') ).\
                filter( Q(mayusculas_titulo__contains=query) ).order_by('titulo')
        elif tipo_busqueda == "semestre":
            ua = ua.filter( Q(semestre__contains=query) ) .order_by('titulo')
        elif tipo_busqueda == "horas":
            ua = ua.filter( Q(horas__contains=query) ) .order_by('titulo')
        elif tipo_busqueda == "licenciatura":
            ua = ua.annotate(mayusculas_licenciatura=Func( Concat(F('licenciatura__siglas'), V(" "), "licenciatura__version", output_field=CharField()), function='UPPER') )\
                .filter( Q(mayusculas_licenciatura__contains=query) )\
                .order_by('titulo')
            print(query)
            for unidad in ua: print(unidad.titulo, unidad.licenciatura.siglas, unidad.mayusculas_licenciatura)
        for unidad in ua[int(first):int(last)]:
            respuesta.append({
                "id":               unidad.id,
                "titulo":           unidad.titulo,
                "semestre":         unidad.semestre,
                "horas":            unidad.horas,
                "licenciatura":     f"{unidad.licenciatura.siglas} {unidad.licenciatura.version}",
            })
            # print(respuesta[-1])
        return JsonResponse({"lista":respuesta, "cantidad":ua.count()}, status = 200, safe=False)
    else:
        return JsonResponse({"error": "Error"}, status=400)
        