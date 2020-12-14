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
			db1, *dbs = list(rdbmss)
			db2, db3 = '', ''
			if(len(dbs) >= 1):
				db2 = dbs[0]
			if(len(dbs) == 2):
				db3 = dbs[1]
			hwT = form.cleaned_data.get('hw_type')
			dbC = form.cleaned_data.get('db_config')
			osT = form.cleaned_data.get('os_type')
			Popen(['bash','tools/bin/cloudlab.sh',str(hwT),str(osT),str(dbC),str(db1),str(db2),str(db3)])
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