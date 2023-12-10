from django.db import models
from django.contrib.auth.models import User
from django.db.models.fields import IntegerField

# Create your models here.
class Docente(models.Model):
    grado_academico = models.CharField(max_length=40)
    nombre_grado = models.CharField(max_length=150)
    tipo_de_docente = models.IntegerField()
    user = models.OneToOneField(User, on_delete=models.CASCADE)

class Coordinador(models.Model):
    activo = models.IntegerField()
    user = models.OneToOneField(User, on_delete=models.CASCADE)

class Licenciatura(models.Model):
    nombre = models.CharField(max_length=100)
    version = models.IntegerField()
    siglas = models.CharField(max_length=4)
    coordinador = models.ForeignKey(Coordinador, models.SET_NULL, blank=True, null=True,)

class Grupo(models.Model):
    licenciatura = models.ForeignKey(Licenciatura, on_delete=models.CASCADE)
    siglas = models.CharField(max_length=4, primary_key=True)
    semestre = models.IntegerField()
    
class UnidadAprendizaje(models.Model):
    titulo = models.CharField(max_length=100)
    semestre = models.IntegerField()
    horas = models.IntegerField()
    licenciatura = models.ForeignKey(Licenciatura, on_delete=models.CASCADE)

class Horario_disponible(models.Model):
    dia = models.IntegerField()
    hora_inicio = models.IntegerField()
    hora_final = models.IntegerField()
    docente = models.ForeignKey(Docente, on_delete=models.CASCADE)

class Horarios(models.Model):
    hora_inicio = models.IntegerField()
    hora_final = models.IntegerField()
    grupo = models.ForeignKey(Grupo, on_delete=models.CASCADE)
    dia = models.IntegerField()
    docente = models.ForeignKey(Docente, models.SET_NULL, blank=True, null=True,)
    unidadAprendizaje = models.ForeignKey(UnidadAprendizaje, on_delete=models.CASCADE)

class Configuracion(models.Model):
    llave = models.CharField(max_length=100, primary_key = True)
    valor = models.TextField()
