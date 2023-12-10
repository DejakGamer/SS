"""sghorarios URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, re_path
from horarios import views_dcs
from horarios import views_ua
from horarios import views

urlpatterns = [
    path('', views.home, name="index"),
    path('home/', views.home, name="home"),
    path('admin/', admin.site.urls),
    path('horarios/', views.horarios, name="horarios"),
    path('extraer_docente/', views.extraer_docente, name="extraer_docente"),
    path('login/', views.log_in, name="login"),
    path('logout/', views.logout_view, name="logout"),
    path('accounts/login/', views.log_in,name="loginnext"),
    path('guardar_horario/', views.obtener_horario_horarios, name="guardar_horario"),
    path('guardar_modificacion_horario/', views.modificacion_horario_horarios, name="guardar_modificacion_horario"),
    re_path(r'^modificacion_horario/(?P<grupo>[A-Z1-9]{2,4})$', views.modificacion_horario, name="modificacion_horario"),
    path('eliminar_horario_grupo/', views.eliminacion_horarios_horario, name="eliminar_horario_grupo"),
    path('descarga_horarios/', views.descarga_horarios, name="descarga_horarios"),

    ## urls del modulo de docentes
    path('registro_docente/', views_dcs.registro_docente, name="registro_docente"),
    path('guardar_registro_docente/', views_dcs.guardar_registro_docente, name="guardar_registro_docente"),
    path('lista_docente/', views_dcs.lista_docente, name="lista_docente"),
    path('modificacion_docente/', views_dcs.modificaciondocentes, name="modificacion_docente"),
    path('guardar_modificacion_docente/', views_dcs.guardar_modificacion_docente, name="guardar_modificacion_docente"),
    path('modificacion_horario_docente/', views_dcs.modificarhorariodocente, name="modificacion_horario_docente"),
    path('guardar_modificacion_horario_docente/', views_dcs.modificarhorariodocente, name="guardar_modificacion_horario_docente"),
    path('eliminacion_docente/', views_dcs.eliminardocente, name="eliminacion_docente" ),
    path('lista_coordinadores/', views_dcs.listadocoordinadores, name="lista_coordinadores"),
    path('lista_grupos/', views_dcs.listadogrupos, name="lista_grupos"),
    path('horario_asignado/', views_dcs.horarioasignado, name="horario_asignado"),
    path('eliminar_horarios_disponibles/', views_dcs.eliminar_horarios_disponibles, name="eliminar_horarios_disponibles"),
    path('extraer_Dcs_A/', views_dcs.extraer_Dcs_A, name="extraer_Dcs_A"),
    path('nueva_fecha_limite/', views_dcs.guardar_fecha_limite, name="nueva_fecha_limite"),

    ## peticiones ajax del modulo ua
    path('extraer_horarios_docente/<int:identificador>/', views.getHorarioDocente, name="extraer_horarios_docente"),


    ## urls del modulo de ua
    path('registro_UA/', views_ua.registro_UA, name="registro_UA"),
    path('registro_licenciatura/', views_ua.registro_licenciatura, name="registro_licenciatura"),
    path('guardar_registro_UA/', views_ua.guardar_registro_UA, name="guardar_registro_UA"),
    path('guardar_registro_licenciatura/', views_ua.guardar_registro_licenciatura, name="guardar_registro_licenciatura"),
    path('lista_UA/', views_ua.lista_UA, name="lista_UA"),
    path('lista_licenciatura/', views_ua.lista_licenciatura, name="lista_licenciatura"),
    path('modificacion_UA/<int:identificador>/', views_ua.modificacion_UA, name="modificacion_UA"),
    path('guardar_modificacion_UA/', views_ua.guardar_modificacion_UA, name="guardar_modificacion_UA"),
    path('modificacion_licenciatura/<int:identificador>/', views_ua.modificacion_licenciatura, name="modificacion_licenciatura"),
    path('guardar_modificacion_licenciatura/', views_ua.guardar_modificacion_licenciatura, name="guardar_modificacion_licenciatura"),
    path('eliminar_UA/<int:identificador>/', views_ua.eliminar_UA, name="eliminar_UA"),
    path('eliminar_licenciatura/<int:identificador>/', views_ua.eliminar_licenciatura, name="eliminar_licenciatura"),
    
    
        ## peticiones AJAX del modulo ua
    path('extraer_UA/', views_ua.extraer_UA, name="extraer_UA"),
]
