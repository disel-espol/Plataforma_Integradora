from django.shortcuts import render, redirect, render_to_response
from django.http import HttpResponse, JsonResponse
from django.template import RequestContext
from .models import Rbdms, HardwareType, OSType, Test, DbConfig
from .forms import TestForm

# Create your views here.

def index(request):
	if(request.method == 'POST'):
		form = TestForm(request.POST)
		if(form.is_valid()):
			print("form is valid")
			"""
			TODO:
				Ejecutar bash script
			"""
			return redirect('results')
	else:
		print("carga")
		form = TestForm(request.POST)
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