from django.shortcuts import render, redirect
from django.http import HttpResponse, JsonResponse
from django.template import RequestContext
from .models import Rbdms, HardwareType, OSType, Test, DbConfig
from .forms import TestForm
from subprocess import Popen

# Create your views here.

def index(request):
	if(request.method == 'POST'):
		form = TestForm(request.POST)
		if(form.is_valid()):
			print("form is valid")
			rdbmss = form.cleaned_data.get('rdbms')
			rdbmsL = list(rdbmss)
			hwT = form.cleaned_data.get('hw_type')
			dbC = form.cleaned_data.get('db_config')
			osT = form.cleaned_data.get('os_type')
			"""
			TODO:
				Ejecutar bash script
				arg1 = configuracion de hardware
				arg2 = sistema operativo
				arg3 = bases
				arg4 = configuracion de bases
			"""
			#Popen(['bash','scriptPrueba.sh',str(hwT),str(osT)])
			return redirect('results')
	else:
		print("carga")
		form = TestForm()
	return render(request, 'index.html', {'form':form})

def results(request):
	return render(request, 'results.html')

def get_hwType(request):
	pk = request.GET.get('value')
	spec = HardwareType.objects.get(pk=pk).specifications
	return JsonResponse({'spec':spec})

def get_dbSpec(request):
	pk = request.GET.get('value')
	spec = DbConfig.objects.get(pk=pk).specifications
	return JsonResponse({'spec':spec})