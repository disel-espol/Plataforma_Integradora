from os import listdir, system
from os.path import isfile, join



system("py manage.py loaddata fixtures\\"+" fixtures\\".join(listdir("fixtures")))