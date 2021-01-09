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
			'confFiles': 'Configuración de bases de datos',
		}

		widgets = {
			'rdbms': forms.CheckboxSelectMultiple(attrs={"class":"form-control"}),
			'hw_type': forms.Select(attrs={"class":"form-control", "onchange":"getHwType(this.value);"}),
			'hw_spec': forms.Textarea(attrs={'readonly':True, 'rows':8}),
			'os_type': forms.Select(attrs={"class":"form-control"}),
			'scale': forms.Select(attrs={"class":"form-control"}),
			'confFiles': forms.ClearableFileInput(attrs={'class':'form-control'}),
		}
