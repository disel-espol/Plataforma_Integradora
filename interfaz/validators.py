from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
import os

def validate_file(value):
	valid_extensions = ['.cnf', '.conf']
	ext = os.path.splitext(value.name)[1]
	if not ext.lower() in valid_extensions:
		raise ValidationError(
			_('%(value)s no tiene una extension aceptada'),
            params={'value': value},
        )