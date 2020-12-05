from django.shortcuts import render, redirect
from django.http import HttpResponse
from .models import Rbdms, HardwareType, OSType, Test
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