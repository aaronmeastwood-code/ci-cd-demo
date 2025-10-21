from .base import *
import os

SECRET_KEY = os.getenv('DJANGO_SECRET_KEY', 'ci-default-key')
DEBUG = True
ALLOWED_HOSTS = ['*']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
