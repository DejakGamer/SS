from django.contrib import messages
from django.http.response import JsonResponse, HttpResponse
from horarios.models import Docente, Grupo, Horario_disponible, Horarios, Licenciatura, UnidadAprendizaje, Configuracion
from django.db.models import Q, Func, F
from django.shortcuts import get_object_or_404, redirect, render
from horarios.models import UnidadAprendizaje
from horarios.views_ua import getDataFromResponse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required, permission_required, user_passes_test
from pprint import pprint
from datetime import datetime
import json
from excel_response import ExcelResponse

# Create your views here.
def home(request):
    """Vista que muestra la interfaz principal.
    Se obtine adicionalmente la fecha actual y la fecha limite para acceder a registrar 
    el horario disponible de los docentes

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request y la template de la lista unidades de aprendizaje.
    """
    variables = {}
    now = datetime.now()

    fecha_actual = now.strftime("%Y-%m-%d")
    fecha_actual = datetime.strptime(fecha_actual, '%Y-%m-%d')
    limite = Configuracion.objects.get(llave="fechalimite")
    fecha_limite = datetime.strptime(limite.valor, '%Y-%m-%d')

    dentro_limite = fecha_actual < fecha_limite
    #print(dentro_limite)
    variables['limite'] = dentro_limite

    return render(request, "home.html", variables)

def log_in(request):
    """View destinada para el login del sistema

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.
    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template
    """
    if not request.user.is_authenticated:
        if request.method == 'POST':
            username = request.POST.get('user_l')
            password = request.POST.get('pass_l')
            user = authenticate(request, username=username, password=password)
            if user is not None:
                login(request, user)
                #print(request.user.get_group_permissions(obj=None))
                return  redirect("home")
            else:
                messages.error(request, 'Usuario o contraseña no coinciden, favor de verificar los datos', extra_tags="Error")

    else:
        return redirect("home")

    return render(request, "login.html")

def logout_view(request):
    """View default para cerrar la sesión del usuario activo en sesión.

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        redirect: El método 'redirect' toma como argumento: La URL a la que desea ser redirigido como cadena
        del nombre de una vista.
    """
    logout(request)
    return redirect('login')

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def horarios(request):
    """View destinada para obtener los datos ingresados para registrar el grupo, para poder mostrar al usuario
        las materias asociadas al semestre y licenciatura, con todos los docentes que estan registrados en el 
        sistema

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template
    """

    variables = {}
    if request.method == "POST":
        values, num_messages = getDataFromResponse([
            ["licenciatura", "la licenciatura"],
            ["semestre", "el semestre", int, 0, 11],
            ["siglas", "el nombre de las siglas", str, r"^[A-Z1-9]{2,4}$"]],request.POST, request)
        if num_messages > 0:
            return redirect("lista_grupos")
        try:
            Grupo.objects.get(pk=values["siglas"])
            messages.add_message(request, messages.ERROR, "Un grupo con esas siglas ya existen", extra_tags="Error")
            return redirect("lista_grupos")
        except Grupo.DoesNotExist as dNE:
            pass
        try:
            values["licenciatura"] = Licenciatura.objects.get(id=values["licenciatura"])
        except Licenciatura.DoesNotExist:
            messages.add_message(request, messages.ERROR, "La licenciatura no existe", extra_tags="Error en la licenciatura")
            return redirect("lista_grupos")
        ua = UnidadAprendizaje.objects.filter(licenciatura__id=values["licenciatura"].id, semestre=values["semestre"])
        if not ua.exists():
            messages.add_message(request, messages.ERROR, "No hay materias que mostrar", extra_tags="Error")
            return redirect("lista_grupos")
        values["licenciatura"] = {
                "id": values["licenciatura"].id, 
                "nombre": values["licenciatura"].nombre, 
            }
        values["destino"] = "guardar_horario"
        variables = {
            "values": values,
            "materias":ua,
            }

    return render(request, "editor_horario.html", variables)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def extraer_docente(request):
    """
        View para obtener la lista de los docentes en el apartado de crear y editar los horarios
        sin importar la view
    Args:
        request ([type]): [description]

    Returns:
        [lista]: [id, nombre y apellidos de los docentes registrados para los horarios]
    """
    if request.is_ajax and request.method == "POST":
        query = request.POST.get("query", None).upper()
        print(query)
        respuesta = []
        docentes = Docente.objects\
            .annotate(mayusculas_first_name=Func( F('user__first_name'), function='UPPER') )\
            .annotate(mayusculas_last_name=Func( F('user__last_name'), function='UPPER') )\
        .filter(
        Q(mayusculas_first_name__contains=query)|
        Q(mayusculas_last_name__contains=query)).order_by('user__last_name', 'user__first_name')
        for docente in docentes:
            respuesta.append({
                "id":               docente.id,
                "nombre":   docente.user.first_name,
                "app":   docente.user.last_name,
                "grado_academico": docente.grado_academico
            })
            # print(respuesta[-1])
        return JsonResponse({"lista":respuesta}, status = 200, safe=False)
    else:
        return JsonResponse({"error": "Error"}, status=400)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def getHorarioDocente(request, identificador):
    """
        View para devolver el horario del docente en caso de que no tenga ya asignado algo en el registro
    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.
        identificador ([json]): identificador del docente al cual se quiere obtener los datos

    Returns:
        [JsonResponse]: es una subclase HttpResponse que ayuda a crear una respuesta codificada en JSON. 
        Su encabezado de tipo de contenido predeterminado se establece en application / json.
    """
    docente = get_object_or_404(Docente,pk=identificador)
    horario_docente = Horarios.objects.filter(docente=docente).exclude(grupo=request.POST.get('grupo', ""))
    docente_disponible = Horario_disponible.objects.filter(docente=docente)

    horas_asignadas_docente = 0
    horas_libres_docente = 0

    #En el caso de que no exista un horario disponible por parte del docente
    if len(docente_disponible) == 0:
        return JsonResponse({"error": "No hay horario disponible del docente"}, status=400)
    #En el caso de que no exista un horario asignado en la tabla u objeto Horarios al docente
    elif len(horario_docente) == 0:
        
        docente_horario = dictionario_de_horarios(docente_disponible)

        #Ciclo para obtener el numero de horas disponibles del docente
        for i in docente_horario:
            for j in docente_horario[i]:
                horas_libres_docente += ((j[1] - j[0])+1)
        
        return JsonResponse(
            {
                'tipo_docente':docente.tipo_de_docente, 
                'horariodocente': docente_horario, 
                'horas_disponibles_docente': horas_libres_docente, 
                'horas_asignadas_docente': horas_asignadas_docente,
                'nombre': f"{docente.user.first_name} {docente.user.last_name}"}, status = 200, safe=False)
    #En el caso de que ya tenga asignadas horas en Horarios
    else:
        docente_h = dictionario_de_horarios(docente_disponible)
        horario_d = dictionario_de_horarios(horario_docente)

        horario_filtrado = {}

        for dia_disponible in docente_h:
            if dia_disponible in horario_d:
                rangos_temporales = []
                for rangos in docente_h[dia_disponible]:
                    final_segmento = 0
                    for segmento in range(len(horario_d[dia_disponible])):
                        print(segmento)
                        if len(horario_d[dia_disponible]) == 1 and horario_d[dia_disponible][segmento][0] == rangos[0]:
                            if horario_d[dia_disponible][segmento][1] != rangos[1]:
                                rangos_temporales.append([(horario_d[dia_disponible][segmento][1]+1), rangos[1]])
                        elif horario_d[dia_disponible][segmento] == rangos:
                            pass
                        else:
                            control_1 = -1
                            control_2 = -1
                            if horario_d[dia_disponible][segmento][0] == rangos[0]:
                                    final_segmento = horario_d[dia_disponible][segmento][1]
                            elif final_segmento == (horario_d[dia_disponible][segmento][0] -1):
                                final_segmento = horario_d[dia_disponible][segmento][1]
                                if len(horario_d[dia_disponible]) == 1:
                                    rangos_temporales.append([rangos[0], horario_d[dia_disponible][segmento][0]])
                                    rangos_temporales.append([(final_segmento+1), rangos[dia_disponible]])
                            elif horario_d[dia_disponible][segmento][0] >= rangos[0] and horario_d[dia_disponible][segmento][1] <= rangos[1]:
                                if not horario_d[dia_disponible][segmento][0] == rangos[0]:
                                    control_1 = rangos[0]
                                    control_2 = horario_d[dia_disponible][segmento][0]
                                    if control_1 > final_segmento:
                                        final_segmento = horario_d[dia_disponible][segmento][1]
                                        rangos_temporales.append([control_1,(control_2-1)])
                                    elif control_1 == final_segmento:
                                        rangos_temporales.append([control_1,control_2])
                                        rangos_temporales.append([(horario_d[dia_disponible][segmento][1]+1), rangos[1]])
                                    else:
                                        rangos_temporales.append([(final_segmento+1), (control_2-1)])
                                        final_segmento = horario_d[dia_disponible][segmento][1]
                            else:
                                if not rangos in rangos_temporales:
                                    rangos_temporales.append(rangos)
                                
                        if final_segmento == horario_d[dia_disponible][segmento][1]:
                            pass
                if rangos_temporales != []:
                    horario_filtrado[dia_disponible] = rangos_temporales

            else:
                horario_filtrado[dia_disponible] = docente_h[dia_disponible]

        #Ciclo para contar las horas que el docente tiene libres contemplando si ya tiene horas asignadas
        for i in horario_filtrado:
            for j in horario_filtrado[i]:
                horas_libres_docente += ((j[1]-j[0])+1)
        #Ciclo para obtener el numero de horas que ya tiene asignadas el docente
        for k in horario_d:
            for l in horario_d[k]:
                horas_asignadas_docente += ((l[1] - l[0])+1)

        return JsonResponse({
            'tipo_docente':docente.tipo_de_docente, 
            'horariodocente': horario_filtrado, 
            'horas_disponibles_docente': horas_libres_docente, 
            'horas_asignadas_docente': horas_asignadas_docente,
            'nombre': f"{docente.user.first_name} {docente.user.last_name}"}, status=200, safe=False)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def obtener_horario_horarios(request):
    """View destinada para obtener el horario editable y para su registro en la base de datos

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [JsonResponse]: es una subclase HttpResponse que ayuda a crear una respuesta codificada en JSON. 
        Su encabezado de tipo de contenido predeterminado se establece en application / json. 
    """
    variables = {}

    #print(request.POST)
    if request.is_ajax and request.method == "POST":
        
        horario_docente = []

        
        lic = str(request.POST.get('licenciatura'))
        sem = int(request.POST.get('semestre'))
        siglas = request.POST.get('siglas')
        #Se registra el grupo en primer lugar
        grupo_registrado = Grupo(
            licenciatura = Licenciatura.objects.get(id=lic),
            siglas = siglas,
            semestre = sem
        )
        #Se intenta registrar el grupo con los datos obtenidos
        try:
            grupo_registrado.save()
        except Exception as e:
            print(e)
            variables['error'] = str(e)
            return JsonResponse(variables, status=400, safe=False)

        #Ciclo para obtener los horarios seleccionados por el usuario
        for lapso in json.loads(request.POST.get('arreglo_horarios')):
            horario_docente.append(lapso)

        #Si no existen horarios para registrar se retorna un error 
        if horario_docente == []:
            grupo_registrado.delete()
            variables['error'] = "No hay horarios para registrar"
            return JsonResponse(variables, status=400, safe=False)

        control = creacion_horarios(horario_docente, grupo_registrado)

        if control: messages.add_message(request, messages.SUCCESS, "Horarios Registrados correctamente", f"Grupo Registrado {siglas}")

    return JsonResponse(variables, status=200, safe=False)


@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def modificacion_horario_horarios(request):
    """View destinada para obtener los horarios y poder editarlos nuevamente para su registro en la base de
    datos

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [JsonResponse]: es una subclase HttpResponse que ayuda a crear una respuesta codificada en JSON. 
        Su encabezado de tipo de contenido predeterminado se establece en application / json. 
    """

    variables = {}

    if request.is_ajax and request.method == "POST":
        
        horario_docente = []

        grupo_recibido =  str(request.POST.get('siglas'))
        #Se verifica que se pueda obtener un grupo al cual se modifiquen sus horarios
        #si no contiene nada se retorna un error
        if grupo_recibido == None:
            variables['error'] = "sin grupo"
            return JsonResponse(variables, status=400, safe=False)

        #Se intenta obtener el objeto Grupo en base a sus siglas
        #Si incurre en algun error es por que no existe ese grupo y se retorna el mismo
        try:
            grupo_enviado = Grupo.objects.get(siglas=grupo_recibido)
        except Grupo.DoesNotExist as e:
            print(e)
            variables['error'] = "sin grupo"
            return JsonResponse(variables, status=400, safe=False)
        except Exception as e:
            variables['error'] = " error: " + str(e)
            print(e)
            return JsonResponse(variables, status=400, safe=False)

        #Se obtenen los horarios que el usuario haya seleccionado
        for lapso in json.loads(request.POST.get('arreglo_horarios')):
            horario_docente.append(lapso)

        #Si no existen horarios para registrar se retorna un error 
        if horario_docente == []:
            variables['error'] = "No hay horarios para registrar"
            return JsonResponse(variables, status=400, safe=False)
        
        #Se eliminan los registros anteriores de los horarios
        grupo_enviado.horarios_set.all().delete()
        #Se registran los nuevos horarios
        control = creacion_horarios(horario_docente, grupo_enviado)

        if control: messages.add_message(request, messages.SUCCESS, " Los horarios han sido correctamente modificados", f"Grupo {grupo_recibido}")

    return JsonResponse(variables, status=200, safe=False)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def eliminacion_horarios_horario(request):
    """View destinada para eliminar un grupo y sus horarios asignados de la base de datos
    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        redirect: El método 'redirect' toma como argumento: La URL a la que desea ser redirigido como cadena
        del nombre de una vista.
    """
    if request.method == 'GET':
        #Se obtiene el id del grupo al cual se va a eliminar
        obj = request.GET.get('id', None)
        grupo = Grupo.objects.get(siglas=obj)

        #Se intenta eliminar por si ocurre algun error, este regresa un mensaje al usuario
        try:
            grupo.delete()
            messages.add_message(request, messages.SUCCESS, "El grupo y sus horarios asociados fueron eliminados correctamente", extra_tags=f"Grupo {obj} Eliminado")
        except Exception as e:
            print(e)
            messages.add_message(request, messages.ERROR, "No fue posible eliminar el grupo solicitado, contacte con su programador de confianza", extra_tags="Error Fatal")


    return redirect('lista_grupos')

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def modificacion_horario(request, grupo):
    """View destinada para la modificacion de los horarios

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template
    """
    try:
        grupo = Grupo.objects.get(siglas=grupo)
    except Grupo.DoesNotExist:
        messages.add_message(request, messages.ERROR, "Las siglas del grupo no existen", extra_tags="Error en el grupo")
    values = {
            "licenciatura": {
                "id": grupo.licenciatura.id, 
                "nombre": grupo.licenciatura.nombre, 
            },
            "semestre": grupo.semestre,
            "siglas": grupo.siglas,
            "destino": "guardar_modificacion_horario",
            "horario":[
                    {
                        "hora_inicio":lapso.hora_inicio, 
                        "hora_final":lapso.hora_final, 
                        "dia":lapso.dia, 
                        "docente": {
                            "id":lapso.docente.id,
                            "nombre":lapso.docente.user.first_name + " " + lapso.docente.user.last_name
                        }, 
                        "ua": {
                            "id": lapso.unidadAprendizaje.id,
                            "titulo": lapso.unidadAprendizaje.titulo
                        }
                    } for lapso in grupo.horarios_set.all().order_by("dia", "hora_inicio")]
            }
    ua = UnidadAprendizaje.objects.filter(licenciatura__id=values["licenciatura"]["id"], semestre=values["semestre"])

    variables = {
        "values": values,
        "materias":ua,
        }
    return render(request, "editor_horario.html", variables)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def descarga_horarios(request):
    """View que retorna los horarios en formato excell

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [ExcelResponse]: Subclase de HttpResponse que transforma la información de un arreglo bidimencional 
            y lo retorna como respuesta en formato excell
    """
    
    horarios = None
    try:
        request.user.coordinador
        horarios = Horarios.objects.all().filter(unidadAprendizaje__licenciatura__coordinador=request.user.coordinador).order_by("unidadAprendizaje__titulo", "grupo__siglas")
    except User.coordinador.RelatedObjectDoesNotExist:
        horarios = Horarios.objects.all().order_by("unidadAprendizaje__titulo", "grupo__siglas")

    tabla = [["UNIDAD DE APRENDIZAJE","PROPUESTA DE DOCENTE","Grupo","Día","Horario Inicial","Horario Final"]]
    for horario in horarios:
        horario.dia = diaEnteroALetra(horario.dia)
        horario.hora_inicio = horaEnteroALetra(horario.hora_inicio, 0)
        horario.hora_final = horaEnteroALetra(horario.hora_final, 1)
        tabla.append([
            horario.unidadAprendizaje.titulo,
            horario.docente.user.first_name+" "+horario.docente.user.first_name,
            horario.grupo.siglas,
            horario.dia,
            horario.hora_inicio,
            horario.hora_final
        ])
    pprint(tabla)
    return ExcelResponse(tabla, 'Horarios')

## funciones que no son views aqui
def dictionario_de_horarios(arreglo):
    """Funcion que regresa un diccionario con los horarios y segmentos del horario que reciba por parametro
    de la forma en que sea entendible para recibirlo en javascript

    Args:
        arreglo : [contiene los registros encontrados de los horarios]

    Returns:
        [diccionario]: [los horarios por dia y segmentos de los horarios obtenidos en forma de arreglo]
    """
    d_t = -1
    dicty = {}
    temp = []
    t_d = []
    for h in arreglo:
        t_d.append(h.hora_inicio)
        t_d.append(h.hora_final)

        if d_t == h.dia:
                #print("igual")
            temp.append(t_d)
            t_d = []
        else:
                #print("N9")
            if temp == []:
                temp.append(t_d)
            else:
                dicty[d_t] = temp
                temp = []
                temp.append(t_d)

            t_d = []
            d_t = h.dia
            #print(h.dia, d_t)
            
    dicty[d_t] = temp

    return dicty

def creacion_horarios(horario_docente, grupo_registrado):
    """Funcion que permite el registrar los horarios elegidos por el usuario.

    Args:
        horario_docente (arreglo): [registros de los horarios elegidos por el usuario]
        grupo_registrado (objeto:Grupo): [el objeto grupo al cual se le van a asignar los horarios]

    Returns:
        [variable]: [control, variable de tipo boleana que determina si fueron registrados correctamente 
        los horarios]
    """

    control_docente = horario_docente[0]
    hora_control = control_docente['hora']# hora consecutiva
        
    docente_control = Horarios(
        hora_inicio = control_docente['hora'],
        grupo = grupo_registrado,
        dia = control_docente['dia'],
        docente = Docente.objects.get(id=control_docente['profesor']),
        unidadAprendizaje = UnidadAprendizaje.objects.get(id=control_docente['ua'])
    )

    # importante dia y unidad de aprendizaje, horas consecutivas
    for docente in horario_docente[1:]:
        if docente['ua'] == control_docente['ua'] and docente['dia'] == control_docente['dia']:
            hora_control +=1
            if not hora_control == docente['hora']:
                if hora_control -1 == control_docente['hora']: 
                    hora_control = hora_control-1
                docente_control.hora_final = hora_control
                docente_control.save()
                #registros_horarios.append(docente_control)
                hora_control = docente['hora']
                control_docente = docente

                docente_control = Horarios(
                    hora_inicio = hora_control,
                    grupo = grupo_registrado,
                    dia = control_docente['dia'],
                    docente = Docente.objects.get(id=control_docente['profesor']),
                    unidadAprendizaje = UnidadAprendizaje.objects.get(id=control_docente['ua'])
                )

        elif docente['ua'] != control_docente['ua'] and docente['dia'] == control_docente['dia']:
                
            docente_control.hora_final = hora_control
            docente_control.save()
            #registros_horarios.append(docente_control)

            control_docente = docente

            if (hora_control + 1) != docente['hora']:
                hora_control = docente['hora']
            else: 
                hora_control += 1 
                
            docente_control = Horarios(
                hora_inicio = hora_control,
                grupo = grupo_registrado,
                dia = control_docente['dia'],
                docente = Docente.objects.get(id=control_docente['profesor']),
                unidadAprendizaje = UnidadAprendizaje.objects.get(id=control_docente['ua'])
            )

        elif (docente['ua'] != control_docente['ua'] or docente['ua'] == control_docente['ua']) and docente['dia'] != control_docente['dia']:
                
            docente_control.hora_final = hora_control
            docente_control.save()
            #registros_horarios.append(docente_control)
            control_docente = docente

            hora_control = docente['hora']

            docente_control = Horarios(
                hora_inicio = hora_control,
                grupo = grupo_registrado,
                dia = control_docente['dia'],
                docente = Docente.objects.get(id=control_docente['profesor']),
                unidadAprendizaje = UnidadAprendizaje.objects.get(id=control_docente['ua'])
            )
    docente_control.hora_final = hora_control
    docente_control.save()

    return True

def diaEnteroALetra(dia):
    """Funcion que transforma los indices en la base de datos al formato general de dias de la semana

    Args:
        dia (entero): Indice del día en la base de datos

    Returns:
        cadena: Formato en cadena del día
    """
    if dia == 0: return "Lunes"
    elif dia == 1:return "Martes"
    elif dia == 2:return "Miercoles"
    elif dia == 3:return "Jueves"
    elif dia == 4:return "Viernes"
    elif dia == 5:return "Sabado"
    else:return "Error "+dia

def horaEnteroALetra(hora, posicion):
    """Función que transforma los indices de las bases de datos al formato general de horas

    Args:
        hora (entero): Indice en la base de datos
        posicion (entero): Determina si es hora final o inicial 

    Returns:
        [cadena]: Cadena con el formato en horas
    """
    horas = [
        ["7:00", "7:30"],
        ["7:30", "8:00"],
        ["8:00", "8:30"],
        ["8:30", "9:00"],
        ["9:00", "9:30"],
        ["9:30", "10:00"],
        ["10:00", "10:30"],
        ["10:30", "11:00"],
        ["11:00", "11:30"],
        ["11:30", "12:00"],
        ["12:00", "12:30"],
        ["12:30", "13:00"],
        ["13:00", "13:30"],
        ["13:30", "14:00"],
        ["14:00", "14:30"],
        ["14:30", "15:00"],
        ["15:00", "15:30"],
        ["15:30", "16:00"],
        ["16:00", "16:30"],
        ["16:30", "17:00"],
    ]
    try:
        return horas[hora][posicion]
    except IndexError:
        return "Error al buscar hora code:horaEnteroALetra"
    except Exception as e:
        return "Error: "+e 