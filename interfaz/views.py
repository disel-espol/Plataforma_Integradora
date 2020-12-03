from django.shortcuts import render
from django.http import HttpResponse
from .models import HardwareType, OSType

# Create your views here.

def index(request):
	#hw_list = HardwareType.objects.all()

def run_test(request):
	return HttpResponse('Aqui van los graficos')