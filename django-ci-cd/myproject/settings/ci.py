# myproject/settings/ci.py

from .base import *
import os

# ------------------------------
# Security
# ------------------------------
SECRET_KEY = os.getenv('DJANGO_SECRET_KEY', 'ci-default-key')
DEBUG = True
ALLOWED_HOSTS = ['*']

# ------------------------------
# Installed apps
# ------------------------------
# Ensure your app(s) are included for test discovery
# Ensure your app(s) are included for test discovery
if 'myapp' not in INSTALLED_APPS:
    INSTALLED_APPS.append('myapp')
# ------------------------------
# Database
# ------------------------------
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',  # temporary SQLite DB for CI
    }
}

# ------------------------------
# Other CI-friendly settings
# ------------------------------
# Disable migrations if you want faster tests (optional)
MIGRATION_MODULES = {app: None for app in INSTALLED_APPS}

# Use console email backend to avoid sending emails
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Logging to see output in CI
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {'class': 'logging.StreamHandler'},
    },
    'root': {
        'handlers': ['console'],
        'level': 'DEBUG',
    },
}
