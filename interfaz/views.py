from django.shortcuts import render, redirect
from django.http import HttpResponse, JsonResponse
from django.template import RequestContext
from django.contrib import messages
from .models import Rbdms, HardwareType, OSType, Test
from .forms import TestForm
from subprocess import Popen, getoutput
from django.conf import settings
import os

# Create your views here.

def index(request):
	if(request.method == 'POST'):
		form = TestForm(request.POST, request.FILES)
		#request.FILES['file'] para acceder a los archivos
		if(form.is_valid()):
			print("form is valid")
			rdbmss = form.cleaned_data.get('rdbms')
			db1, *dbs = list(rdbmss)
			db2, db3 = '', ''
			dbCount = 1
			if(len(dbs) >= 1):
				db2 = dbs[0]
				dbCount+=1
			if(len(dbs) == 2):
				db3 = dbs[1]
				dbCount+=1
			hwT = form.cleaned_data.get('hw_type')
			osT = form.cleaned_data.get('os_type')
			scale = form.cleaned_data.get('scale')
			if(int(availNodes(hwT))==0):
				print("No hay maquinas disponibles")
				messages.error(request, 'No hay maquinas %s disponibles' %str(hwT))
				return render(request, 'index.html', {'form':form})
			db1fX, db2fX, db3fX = '', '', ''
			db1File = form.cleaned_data.get('db1File')
			db2File = form.cleaned_data.get('db2File')
			db3File = form.cleaned_data.get('db3File')
			if(db1File):
				handle_uploaded_file(db1File, "mysql.cnf")
				db1fX = 'exist'
			if(db2File):
				handle_uploaded_file(db2File, "postgresql.conf")
				db2fX = 'exist'
			if(db3File):
				handle_uploaded_file(db3File, "mariadb.cnf")
				db3fX = 'exist'
			Popen(['bash','tools/bin/cloudlab.sh',str(hwT),str(osT),str(scale),str(db1),str(db2),str(db3),str(db1fX),str(db2fX),str(db3fX)])
			request.session['db1'] = str(db1)
			request.session['db2'] = str(db2)
			request.session['db3'] = str(db3)
			request.session['hwT'] = str(hwT)
			request.session['osT'] = str(osT)
			request.session['dbCount'] = dbCount
			return redirect('progress')
	else:
		print("carga")
		form = TestForm()
	return render(request, 'index.html', {'form':form})

def progress(request):
	db1 = request.session['db1']
	db2 = request.session['db2']
	db3 = request.session['db3']
	return render(request, 'progress.html', {'db1':db1, 'db2':db2, 'db3':db3})

def results(request):
	return render(request, 'results.html')

def availNodes(code):
	command = "curl -s -k https://emulab.net/portal/frontpage.php | grep "+str(code)+" -C 2 | tail -1 | sed 's/>/</g' | cut -d'<' -f3"
	return getoutput(command)

def get_hwType(request):
	pk = request.GET.get('value')
	spec = HardwareType.objects.get(pk=pk).specifications
	return JsonResponse({'spec':spec})

def get_dbSpec(request):
	pk = request.GET.get('value')
	spec = DbConfig.objects.get(pk=pk).specifications
	return JsonResponse({'spec':spec})

def file_len(fname):
	with open(fname) as f:
		for i, l in enumerate(f):
			pass
	return i + 1

def readFile(request):
	path = os.path.join(settings.BASE_DIR, 'output.txt')
	f = open(path)
	lines = f.readlines()
	line = lines[-1]
	dbCount = request.session['dbCount']
	return JsonResponse({'line':line, 'dbCount':dbCount})

def readLogs(request):
	Popen(['bash','tools/bin/logs.sh'])
	path = os.path.join(settings.BASE_DIR, 'logs.txt')
	f = open(path)
	lines = f.read()
	f.close()
	return JsonResponse({'lines':lines})

def handle_uploaded_file(file, name):
	os.makedirs("media", exist_ok=True)
	path = os.path.join(settings.MEDIA_ROOT, name)
	fconf = open(path, 'wb+')
	for chunk in file.chunks():
		fconf.write(chunk)
	fconf.close() 