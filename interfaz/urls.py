from django.urls import path
from . import views

urlpatterns = [
	path('', views.index, name='index'),
	path('test', views.run_test, name='run_test'),
]