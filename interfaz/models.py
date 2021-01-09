from django.db import models

# Create your models here.

class Rbdms(models.Model):
	name = models.CharField(max_length=15)
	def __str__(self):
		return self.name


class HardwareType(models.Model):
	name = models.CharField(max_length=10)
	specifications = models.CharField(max_length=1000)
	def __str__(self):
		return self.name


class DbConfig(models.Model):
	name = models.CharField(max_length=10)
	specifications = models.CharField(max_length=1000)
	def __str__(self):
		return self.name


class OSType(models.Model):
	name = models.CharField(max_length=20)
	def __str__(self):
		return self.name


class Test(models.Model):
	SCALE_CHOICES = [(10,'10'), (20,'20'), (30,'30'), ]

	rdbms = models.ManyToManyField(Rbdms)
	hw_type = models.ForeignKey(HardwareType, on_delete=models.CASCADE)
	hw_spec = models.CharField(max_length=1000, blank=True)
	db_config = models.ForeignKey(DbConfig, on_delete=models.CASCADE)
	dbconf_spec = models.CharField(max_length=1000, blank=True)
	os_type = models.ForeignKey(OSType, on_delete=models.CASCADE)
	scale = models.IntegerField(choices=SCALE_CHOICES, default=10, help_text="TPC-C Workload: Un valor de 10 produce 1GB de data")