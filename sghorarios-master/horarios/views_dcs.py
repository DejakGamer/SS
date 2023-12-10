from django.db.models import Q, Func, F
from django.http.response import JsonResponse
import horarios
import re
from typing import Counter
from django.shortcuts import render
from django.http import HttpResponse
from django.shortcuts import redirect
from django.contrib.auth import authenticate,login, logout
from django.contrib.auth.models import User, Group
from django.contrib.auth.decorators import login_required, permission_required, user_passes_test
from horarios.models import Configuracion, Docente, Grupo, Horario_disponible, Coordinador, Horarios, Licenciatura
from django.contrib import messages
from django.contrib.auth import authenticate
from datetime import datetime

# Create your views here.
def registro_docente(request):

    return render(request, 'Dcs/registro_docentes.html')

def guardar_registro_docente(request):
    """View que permite el registro del docente recibiendo los datos necesarios para el registro del mismo

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [lista]: retorna una lista con los elementos necesarios
        y la redirección a las views correspondientes dependiendo el caso del registro que se encuentre
    """
    if request.method == 'POST':

        #p = request.POST['PEPE']
        usuario_docente = request.POST['username']
        password_docente = request.POST['pass']

        try:
            #Se comprueba si el usuario (correo) ya esta registrado anteriormente
            #En caso de que este registrado causa un error, pero se continua en la excepcion
            #ya que no existe ese usuario en la base de datos
            u = User.objects.get(username=usuario_docente)
            #Error: Usuario ya registrado, verifique su correo institucional
            messages.add_message(request, messages.ERROR, f'Docente con correo: {usuario_docente} ya se encuentra registrado, verifique sus datos', extra_tags='Registro Encontrado')
            return redirect('registro_docente')

        except Exception as e:

            nombre_docente = request.POST['nombre']
            apellidos_docente = request.POST['app']
            horario_disp = request.POST['horariosd']
            
            usuario = User.objects.create_user(usuario_docente, usuario_docente, password_docente)
            usuario.first_name = nombre_docente
            usuario.last_name = apellidos_docente
            usuario.save()
            grp = Group.objects.get(name="Docente")
            
            #Se intenta asignar el grupo al usuario por si existe algun error dentro del try/except
            try:
                grp.user_set.add(usuario)
            except Exception as e:
                print(e)
                #En caso de no poder registrarse el grupo del usuario, se elimina automaticamente el usuario
                usuario.delete()
                #Error: No se ha podido agregar el usuario, error en grupo, contacte a su programador
                messages.add_message(request, messages.ERROR, 'No se ha podido agregar el usuario, error en grupo, contacte a su programador', extra_tags='Error Critico')
                return redirect('registro_docente')

            gradoAcademico_docente = request.POST['grdAca']
            tipo_docente = request.POST['tipDocente']
            gradoNombre = request.POST['grdEst']

            docente = Docente(
                grado_academico = gradoAcademico_docente,
                nombre_grado = gradoNombre,
                tipo_de_docente = tipo_docente,
                user = usuario
            )

            docente.save()

            horario_d = horario_disp.split(",")
            #print(horario_disp)
            ref_horarios = []
            cont = 0
            tt = ""
            dia_d = 0
            for x in horario_d:
                tt = "dia "+ str(cont)+":"
                #print(tt)
                d_h = x.split("|")
                d_h[0] = d_h[0].replace(tt, '')
                
                #print(d_h)
                junt = False
                if d_h[0] != ' ':
                    hora_i = int(d_h[0])
                    hora_f = 0
                    for y in range(len(d_h)-2):
                        #print(d_h[y])
                        if int(d_h[y+1]) != (int(d_h[y])+1):
                            #print("salto...........")
                            hora_f = int(d_h[y])
                            ref_horarios.append([cont, hora_i, hora_f])
                            hora_i = int(d_h[y+1])
                            junt = False
                        else:
                            junt = True

                    
                    if hora_i > hora_f or junt:
                        ref_horarios.append([cont, hora_i, int(d_h[-2])])

                cont += 1

            if ref_horarios != []:
                for h in ref_horarios:
                    #print(h)
                    horario_doc = Horario_disponible(
                        dia = h[0],
                        hora_inicio = h[1], 
                        hora_final = h[2],
                        docente = docente
                    )
                    horario_doc.save()
            else:
                messages.add_message(request, messages.WARNING, 'No registro su horario, favor de pasar al apartado de modificar horario para agregar su horario disponible. Gracias. Mil Besitos. Gracias.', extra_tags='Horario No Registrado')
            #Succes: Docente correctamete registrado :D
            messages.add_message(request, messages.SUCCESS, f'{nombre_docente}, usted fue correctamente registrado', extra_tags='Docente registrado')

            return redirect('home')

    return redirect('registro_docente')

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def lista_docente(request):
    """View que renderiza y desplega la lista de docentes registrados en la base de datos

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [lista]: retorna una lista con los objetos docente.
        [render]: Cuando se solicita una página, Django crea un objeto HttpRequest que contiene 
        metadatos sobre la solicitud. Luego, Django carga la vista apropiada, 
        pasando HttpRequest como primer argumento a la función de vista. Cada vista es 
        responsable de devolver un objeto HttpResponse.
    """
    variables = {}
    docent = Docente.objects.all()
    variables['docente'] = docent

    fecha_limite = Configuracion.objects.get(llave="fechalimite")
    variables['fecha_limite'] = fecha_limite.valor

    return render(request, 'Dcs/lista_docentes.html', variables)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico', 'Docente']).exists())
def modificaciondocentes(request):
    """View destinada para la obtencion del id del docente a modificar,  se obtiene por metodo GET 
    y renderiza la template

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [render]: Cuando se solicita una página, Django crea un objeto HttpRequest que contiene 
        metadatos sobre la solicitud. Luego, Django carga la vista apropiada, 
        pasando HttpRequest como primer argumento a la función de vista. Cada vista es 
        responsable de devolver un objeto HttpResponse.
    """

    variables = {}
    docen = Docente.objects.all()
    pr = None
    if request.method == 'GET':
        obj = request.GET.get('id', None)
        #print(obj)
        try:
            pr = docen.get(id=obj)

            tienedocente = False
            gp = request.user.groups.all()
            for i in gp:
                if i.name == "Docente":
                    tienedocente = True
                else: 
                    tienedocente = False
            if tienedocente:
                if request.user.id != pr.user.id:
                    messages.add_message(request, messages.ERROR, "Victor tiene razon", "Error guardar")
                    return redirect('home')

            variables['docente'] = pr
            cord = False
            g = None
            try:
                g = pr.user.groups.get(name="Coordinador")
            except Exception as e:
                print(e)
            if g != None:
                cord = True
            variables['cordi'] = cord

        except Exception as e:
            print(e)
            messages.add_message(request, messages.ERROR, "No se encontró al Docente, porfavor contacte a su programador de confianza.", extra_tags='Error: Docente no encontrado')

    return render(request, 'Dcs/modifica_docentes.html', variables)


@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico', 'Docente']).exists())
def guardar_modificacion_docente(request):
    """View que guarda las modificaciones realizadas por el usuario para el objeto Docente.
    Se obtienen los datos por metodo POST de la template

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template
        redirect: El método 'redirect' toma como argumento: La URL a la que desea ser redirigido como cadena
        del nombre de una vista.
    """
    if request.method == 'POST':
        username_docente = request.POST['username']
        username_origin = request.POST['user_origin']
        cordi = None
        try:
            cordi = request.POST['cordi']
        except Exception as e:
            print("no llego nada")

        if username_docente != request.user.username:
            a = None
            try:
                a = request.user.groups.get(name="Academico")
            except Exception as e:
                pass
            if a == None:
                cordi = None

        #En el caso de que no se haya modificado el correo (username) del docente
        if username_docente == username_origin:
            
            docente_m = Docente.objects.get(user__username = username_docente)

            nombre_docente = request.POST['nombre']
            apellidos_docente = request.POST['app']
            password_docente = request.POST['pass']
            gradoAcademico_docente = request.POST['grdAca']
            tipo_docente = request.POST['tipDocente']
            gradoNombre = request.POST['grdEst']

            docente_m.user.first_name = nombre_docente
            docente_m.user.last_name = apellidos_docente
            docente_m.grado_academico = gradoAcademico_docente
            docente_m.nombre_grado = gradoNombre
            docente_m.tipo_de_docente = tipo_docente

            if password_docente != '':
                messages.add_message(request, messages.WARNING, "Porfavor logearse de nuevo", extra_tags="Contraseña modificada. Sesión cerrada.")
                docente_m.user.set_password(password_docente)

            
            docente_m.save()
            docente_m.user.save()
            messages.add_message(request, messages.SUCCESS, "Se salvaron los cambios", extra_tags="Registro realizado")

            #En caso de que el chech este seleccionado
            if cordi != None:
                l = None
                #Se intenta buscar al grupo dentro de los grupos asociados al usuario docente
                try:
                    l = docente_m.user.groups.get(name="Coordinador")
                except Exception as e:
                    print(e)
                #Si existe en el grupo de coordinadores se regresa
                if l != None:
                    return redirect('lista_docente')

                #Se crea la clase del coordinador
                coordinador = Coordinador(
                    activo = 1,
                    user = docente_m.user
                )
                grp = Group.objects.get(name="Coordinador")
                #Se guarda el coordinador en la base de datos
                try:
                    coordinador.save()
                except Exception as e:
                    print(e)
                    messages.add_message(request, messages.ERROR, "No se pudo salvar al docente como coordinador, conslte con su programador de confianza", extra_tags="Error Critico")
                #Se añade el grupo al docente mediante la clase de user de Django
                try:
                    grp.user_set.add(docente_m.user)
                    messages.add_message(request, messages.SUCCESS, "Se acaba de convertir en Coordinador", extra_tags="Registro realizado")
                except Exception as e:
                    print(e)
                    messages.add_message(request, messages.ERROR, 'No se ha podido agregar el usuario al grupo de coordinadores, error en grupo, contacte a su programador', extra_tags='Error Critico')
                    return redirect('registro_docente')
            else:
                #En caso de que el check del coordinador no este seleccionada
                l = None
                #Se intenta buscar al grupo dentro de los grupos asociados al usuario docente
                try:
                    l = docente_m.user.groups.get(name="Coordinador")
                except Exception as e:
                    #print(e)
                    pass
                #en el caso de que encuentre el grupo del coordinador en el docente
                if l != None:
                    grp = Group.objects.get(name="Coordinador")
                    #Se intenta remover al grupo del usuario del docente
                    try:
                        grp.user_set.remove(docente_m.user)
                        #messages.add_message(request, messages.SUCCESS, 'Se le ha eliminado del gurpo de coordinadores', extra_tags="Removido del Grupo:")
                    except Exception as e:
                        print(e)
                        messages.add_message(request, messages.ERROR, 'No se ha podido eliminar del usuario el grupo de coordinadores, error en grupo, contacte a su programador', extra_tags='Error Critico')
                    #Se intenta remover el registro del coordinador del docente en la tabla correspondiente
                    try:
                        docente_m.user.coordinador.delete()
                        #messages.add_message(request, messages.SUCCESS, "Se elimino el regitro de coordinadores", extra_tags="Registro Borrado")
                    except Exception as e:
                        print(e)
                    messages.add_message(request, messages.SUCCESS, "Se le eliminó de coordinadores", extra_tags="Ya no es Coordinador")
                    return redirect('lista_docente')

            if password_docente != '':
                return redirect('login')

            return redirect('home')
        else:
            #En el caso de que el docente haya modificado su correo
            docente_m = Docente.objects.get(user__username = username_origin)
            print(username_docente)
            try:
            #Se comprueba si el usuario (correo) ya esta registrado anteriormente
            #En caso de que este registrado causa un error, pero se continua en la excepcion
            #ya que no existe ese usuario en la base de datos
                u = User.objects.get(username=username_docente)
            #Error: Usuario ya registrado, verifique su correo institucional
                messages.add_message(request, messages.ERROR, f'Docente con correo: {username_docente} ya se encuentra registrado, verifique sus datos de nuevo', extra_tags='Registro Encontrado')
                return redirect('../modificacion_docente/?id='+str(docente_m.id)+'')
            except Exception as e:
                #print("Yo tengo razon")
                pass
                #No existe otro correo registrado para con el nuevo username del docente
                #Se intenta borrar el usuario 
            
                usuario = docente_m
                
                nombre_docente = request.POST['nombre']
                apellidos_docente = request.POST['app']
                password_docente = request.POST['pass']
                gradoAcademico_docente = request.POST['grdAca']
                tipo_docente = request.POST['tipDocente']
                gradoNombre = request.POST['grdEst']

                usuario.user.username = username_docente 
                usuario.user.email = username_docente
                usuario.user.first_name = nombre_docente
                usuario.user.last_name = apellidos_docente
                usuario.grado_academico = gradoAcademico_docente
                usuario.nombre_grado = gradoNombre
                usuario.tipo_de_docente = tipo_docente

                if password_docente != '':
                    messages.add_message(request, messages.WARNING, "Porfavor logearse de nuevo", extra_tags="Contraseña modificada. Sesión cerrada.")
                    usuario.user.set_password(password_docente)

                usuario.save()
                usuario.user.save()
                messages.add_message(request, messages.SUCCESS, "Se salvaron los cambios", extra_tags="Registro realizado")

                grp = Group.objects.get(name="Docente")
                try:
                    #Se intenta añadir el grupo docente
                    grp.user_set.add(usuario.user)
                except Exception as e:
                    print(e)
                    #En caso de no poder registrarse el grupo del usuario, se elimina automaticamente el usuario
                    usuario.user.delete()
                    #Error: No se ha podido agregar el usuario, error en grupo, contacte a su programador
                    messages.add_message(request, messages.ERROR, 'No se ha podido agregar el usuario, error en grupo, Ya no existe el registro del docente, Intente Registrandose otra vez', extra_tags='Error Critico')
                    return redirect('lista_docente')

                #En caso de que el chech este seleccionado del coordinador
                if cordi != None:
                    l = None
                    #Se intenta buscar al grupo dentro de los grupos asociados al usuario docente
                    try:
                        l = usuario.user.groups.get(name="Coordinador")
                    except Exception as e:
                        print(e)
                    #Se crea la clase del coordinador
                    if l != None:
                        return redirect('lista_docente')

                    coordinador = Coordinador(
                        activo = 1,
                        user = usuario.user
                    )
                    grp = Group.objects.get(name="Coordinador")
                    #Se guarda el coordinador en la base de datos
                    try:
                        coordinador.save()
                    except Exception as e:
                        print(e)
                        messages.add_message(request, messages.ERROR, "No se pudo salvar al docente como coordinador, conslte con su programador de confianza", extra_tags="Error Critico")
                    #Se añade el grupo al docente mediante la clase de user de Django
                    try:
                        grp.user_set.add(usuario.user)
                        messages.add_message(request, messages.SUCCESS, "Se acaba de convertir en Coordinador", extra_tags="Registro realizado")
                    except Exception as e:
                        print(e)
                        messages.add_message(request, messages.ERROR, 'No se ha podido agregar el usuario al grupo de coordinadores, error en grupo, contacte a su programador', extra_tags='Error Critico')
                        return redirect('registro_docente')
                    
                    #Se añadio todo del coordinador
                    return redirect('lista_docente')
                else:
                    #En caso de que el check del coordinador no este seleccionada
                    l = None
                    #Se intenta buscar al grupo dentro de los grupos asociados al usuario docente
                    try:
                        l = usuario.user.groups.get(name="Coordinador")
                    except Exception as e:
                        print(e)
                    #en el caso de que encuentre el grupo del coordinador en el docente
                    if l != None:
                        grp = Group.objects.get(name="Coordinador")
                        #Se intenta remover al grupo del usuario del docente
                        try:
                            grp.user_set.remove(usuario.user)
                            messages.add_message(request, messages.SUCCESS, 'Se le ha eliminado del gurpo de coordinadores', extra_tags="Removido del Grupo:")
                        except Exception as e:
                            print(e)
                            messages.add_message(request, messages.ERROR, 'No se ha podido eliminar del usuario el grupo de coordinadores, error en grupo, contacte a su programador', extra_tags='Error Critico')
                        #Se intenta remover el registro del coordinador del docente en la tabla correspondiente
                        try:
                            usuario.user.coordinador.delete()
                            messages.add_message(request, messages.SUCCESS, "Se elimino el Registro de coordinadores", extra_tags="Registro Borrado")
                        except Exception as e:
                            print(e)
                        return redirect('lista_docente')
                    
                    if password_docente != '':
                        return redirect('login')

                return redirect('home')


@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico', 'Docente']).exists())
def modificarhorariodocente(request):
    """View destinada para mostrar el horario disponible registrado del docente (en el caso de que exista)
    por metodo GET y obtener el horario disponible modificado por el usuario del docente por metodo POST
    para registrarlo en la base de datos.
    Al inicio se valida si puede modificar su horario, aplica para todos

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template
    """

    variables = {}
    now = datetime.now()

    fecha_actual = now.strftime("%Y-%m-%d")
    fecha_actual = datetime.strptime(fecha_actual, '%Y-%m-%d')
    limite = Configuracion.objects.get(llave="fechalimite")
    fecha_limite = datetime.strptime(limite.valor, '%Y-%m-%d')

    if not fecha_actual < fecha_limite:
        messages.add_message(request, messages.WARNING, "Debido a que la fecha limite ya expiró, no es posible modificar el horario disponible del docente.", extra_tags="Modificaciones No Disponibles!!")
        return redirect('home')


    if request.method == 'GET':
        obj = request.GET.get('id', None)

        d = Docente.objects.get(id=obj)
        variables['nombred'] = str(d.user.first_name) + " " + str(d.user.last_name)
        horario = Horario_disponible.objects.filter(docente=d)
        
        if request.user.groups.filter(name="Docente").exists():
            if not request.user.groups.filter(name="Coordinador").exists() and request.user.id != d.user.id:
                messages.add_message(request, messages.WARNING, "No eres coordinador", "Error al Entrar")
                return redirect('home')


        d_t = -1
        dicty = {}
        temp = []
        t_d = []
        for h in horario:
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
        
        variables['arreglo'] = dicty
        variables['iddocente'] = obj

    elif request.method == 'POST':

        horario_disp = request.POST['horariosd']
        docente_disp = request.POST['docente']
        docente = Docente.objects.get(id=docente_disp)

        Horario_disponible.objects.filter(docente=docente).delete()

        horario_d = horario_disp.split(",")
        ref_horarios = []
        cont = 0
        tt = ""
        dia_d = 0
        for x in horario_d:
            tt = "dia "+ str(cont)+":"
            #print(tt)
            d_h = x.split("|")
            d_h[0] = d_h[0].replace(tt, '')
                
            #print(d_h)
            junt = False
            if d_h[0] != ' ':
                hora_i = int(d_h[0])
                hora_f = 0
                for y in range(len(d_h)-2):
                    #print(d_h[y])
                    if int(d_h[y+1]) != (int(d_h[y])+1):
                        #print("salto...........")
                        hora_f = int(d_h[y])
                        ref_horarios.append([cont, hora_i, hora_f])
                        hora_i = int(d_h[y+1])
                        junt = False
                    else:
                        junt = True

                    
                if hora_i >= hora_f or junt:
                    ref_horarios.append([cont, hora_i, int(d_h[-2])])

            cont += 1

        if ref_horarios != []:
            for h in ref_horarios:
                #print(h)
                horario_doc = Horario_disponible(
                    dia = h[0],
                    hora_inicio = h[1], 
                    hora_final = h[2],
                    docente = docente
                )
                horario_doc.save()
            
            messages.add_message(request, messages.SUCCESS, "Su Horario ha sido correctamente modificado", extra_tags="Felicidades:")
        else:
            messages.add_message(request, messages.WARNING, "Su horario disponible esta vacio. Por favor ingrese su horario Disponible", extra_tags="Advertencia: Horario Vacio")
        
        return redirect('lista_docente')

    return render(request, "Dcs/horario_docente.html", variables)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def eliminardocente(request):
    """View que permite la eliminacion de un Docente y su registros asociados de la base de datos permanentemente
        Se obtiene por metodo GET el id del docente a eliminar.
    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        redirect: El método 'redirect' toma como argumento: La URL a la que desea ser redirigido como cadena
        del nombre de una vista.
    """

    if request.method == 'GET':
        obj = request.GET.get('id', None)
        d = Docente.objects.get(id=obj)
        
        try:
            d.user.delete()
            messages.add_message(request, messages.SUCCESS, "El docente ha sido corrrectamente borrado", extra_tags="Registro Borrado Exitosamente")
        except Exception as e:
            print(e)
            messages.add_message(request, messages.ERROR, "Por favor contacte a su programador de confianza", extra_tags="Error: No se logró borrar al docente")

    return redirect('lista_docente')


@login_required()
@user_passes_test(lambda u: u.groups.filter(name='Academico').exists())
def listadocoordinadores(request):
    """View que renderiza y desplega la lista de los coordinadores registrados en la base de datos

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [lista]: retorna una lista con los objetos coordinadires.
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template
    """

    variables = {}

    coordina = Coordinador.objects.all()

    variables['coordinador'] = coordina

    return render(request, "Dcs/lista_coordinadores.html", variables)


@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def listadogrupos(request):
    """View que renderiza y desplega la lista de los grupos registrados en la base de datos

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [lista]: retorna una lista con los objetos grupo.
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template
    """

    variables = {}
    lic = None
    try:
        lic = request.user.coordinador.licenciatura_set.all()
        grp = Grupo.objects.filter(licenciatura__coordinador= request.user.coordinador)
        if not lic.exists() and request.user.groups.filter(name="Academico").exists():
            lic = Licenciatura.objects.all()
            grp = Grupo.objects.all()
    except User.coordinador.RelatedObjectDoesNotExist:
        if request.user.groups.filter(name="Academico").exists() or request.user.is_staff:
            lic = Licenciatura.objects.all()
            grp = Grupo.objects.all()

    variables['licenciatura'] = lic
    variables['grupos'] = grp

    return render(request, "Dcs/lista_grupos.html", variables)


@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico', 'Docente']).exists())
def horarioasignado(request):
    """View que despliega el horario asignado al docente seleccionado e indicado su id por metodo GET.
        
    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [HttpResponse]: Objeto respuesta proporcionada por la funcion render la cual ocupa el objeto 
            request, la template del formulario de Unidad de aprendizaje y elementos que utilizara 
            el template
    """

    variables = {}
    if request.method == 'GET':
        obj = request.GET.get('id', None)
        url_obt = request.GET.get('ul', None)
        docente = Docente.objects.get(id=obj)
        variables['nombred'] = str(docente.user.first_name) + " " + str(docente.user.last_name)
        horario_asignado = Horarios.objects.filter(docente=docente)
        #Retornar a otro lado si viene vacio el horario_asignado
        if len(horario_asignado) == 0:
            messages.add_message(request, messages.WARNING, "Aún no tienes un horario asignado, consulte más tarde o contate a su coordinado de confianza", extra_tags="Sin Horario Asignado")
            if url_obt == None:
                return redirect('home')
            else: 
                return redirect(url_obt)

        d_t = -1
        dicty = {}
        temp = []
        for h in horario_asignado:
            print(h.grupo.siglas, h.unidadAprendizaje.titulo, h.unidadAprendizaje.semestre, h.hora_inicio, h.hora_final, h.dia)
            temp.append({"dia":h.dia, "hora_inicio":h.hora_inicio, "hora_final":h.hora_final, "semestre":h.unidadAprendizaje.semestre, "unidadAprendizaje":h.unidadAprendizaje.titulo, "grupo":h.grupo.siglas})
        
        variables['arreglo'] = temp
        print(variables['arreglo'])

    return render(request, "Dcs/horario_del_docente.html", variables)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def eliminar_horarios_disponibles(request):
    """View destinada para la eliminacion de todos los horarios disponibles de los docentes

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        redirect: El método 'redirect' toma como argumento: La URL a la que desea ser redirigido como cadena
        del nombre de una vista.
    """

    Horario_disponible.objects.all().delete()
    messages.add_message(request, messages.SUCCESS, "Todos los horarios disponibles de los docentes fueron eliminados", "Horarios Disponibles Eliminados:")

    return redirect('lista_docente')


def extraer_Dcs_A(request):
    """View destinada para la petición de los docentes para la mostrarlos en la lista y en la busqueda 

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        [JsonResponse]: es una subclase HttpResponse que ayuda a crear una respuesta codificada en JSON. 
        Su encabezado de tipo de contenido predeterminado se establece en application / json.
    """
    if request.is_ajax and request.method == "POST":
        query = request.POST.get("query", None).upper()
        respuesta = []
        dcs = Docente.objects\
            .annotate(mayusculas_first_name=Func( F('user__first_name'), function='UPPER') )\
            .annotate(mayusculas_last_name=Func( F('user__last_name'), function='UPPER') )\
            .filter(
            Q(mayusculas_first_name__contains=query)|
            Q(mayusculas_last_name__contains=query)).order_by('user__last_name')
        for docente in dcs:
            tiempo_completo = ""
            if docente.tipo_de_docente == 1:
                tiempo_completo = "Tiempo Completo"
            elif docente.tipo_de_docente == 2:
                tiempo_completo = "Horas Clase"
            activo = ""
            if docente.horario_disponible_set.all().exists() :
                activo = "checked"

            respuesta.append({
                "id":               docente.id,
                "first_name":       docente.user.first_name,
                "last_name":        docente.user.last_name,
                "email":            docente.user.email,
                "tipo_de_docente":  tiempo_completo,
                "activo":           activo,
                "grado_academico":  docente.grado_academico,
            })
            # print(respuesta[-1])
        return JsonResponse({"lista":respuesta}, status = 200, safe=False)
    else:
        return JsonResponse({"error": "Error"}, status=400)

@login_required()
@user_passes_test(lambda u: u.groups.filter(name__in=['Coordinador', 'Academico']).exists())
def guardar_fecha_limite(request):
    """View destinada para actualizar la fecha limite de registro de horarios disponibles

    Args:
        request (HttpRequest): Objeto generado por django que contiene toda la metadata de
        la peticion del cliente.

    Returns:
        redirect: El método 'redirect' toma como argumento: La URL a la que desea ser redirigido como cadena
        del nombre de una vista.
    """

    if request.method == 'POST':

        limite = request.POST['limite']
        fecha_limite = Configuracion.objects.get(llave="fechalimite")
        fecha_limite.valor = limite
        print(fecha_limite.valor)
        try:
            fecha_limite.save()
        except Exception as e:
            print("noqqq")
            print(e)

        messages.add_message(request, messages.SUCCESS, "Nueva fecha limite guardada", extra_tags="Cambio Exitoso")


    return redirect('lista_docente')