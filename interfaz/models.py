from django.db import models

# Create your models here.

class HardwareType(models.Model):
	name = models.CharField(max_length=10)
	specifications = models.TextField(max_length=1000)
	def __str__(self):
		return self.name


class OSType(models.Model):
	name = models.CharField(max_length=20)
	def __str__(self):
		return self.name
