from .base import *
import os
from dotenv import load_dotenv

load_dotenv()
SECRET_KEY = os.getenv('DJANGO_SECRET_KEY', 'dev-default-key')
DEBUG = True
ALLOWED_HOSTS = ['localhost', '127.0.0.1']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
