from django import forms
from .models import Rbdms, HardwareType, OSType, Test

class TestForm(forms.ModelForm):
	class Meta:
		model = Test
		fields = '__all__'

		labels = {
			'rdbms': 'Seleccione el/los RDBMS',
			'hw_type': 'Configuración de hardware',
			'hw_spec': '',
			'os_type': 'Sistema Operativo',
			'scale':'Scale',
			'db1File': 'Configuración para MySQL',
			'db2File': 'Configuración para PostgreSQL',
			'db3File': 'Configuración para MariaDB',
		}

		widgets = {
			'rdbms': forms.CheckboxSelectMultiple(attrs={"class":"form-control"}),
			'hw_type': forms.Select(attrs={"class":"form-control", "onchange":"getHwType(this.value);"}),
			'hw_spec': forms.Textarea(attrs={'readonly':True, 'rows':8}),
			'os_type': forms.Select(attrs={"class":"form-control"}),
			'scale': forms.Select(attrs={"class":"form-control"}),
			'db1File': forms.ClearableFileInput(attrs={'class':'form-control', 'disabled':True}),
			'db2File': forms.ClearableFileInput(attrs={'class':'form-control', 'disabled':True}),
			'db3File': forms.ClearableFileInput(attrs={'class':'form-control', 'disabled':True}),
		}
