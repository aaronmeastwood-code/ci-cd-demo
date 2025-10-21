#!/bin/bash
set -e

echo "Creating Django CI/CD project structure..."

# Create folders
mkdir -p myproject/settings
mkdir -p myapp
mkdir -p .github/workflows

# Create __init__.py files
touch myproject/__init__.py
touch myproject/settings/__init__.py
touch myapp/__init__.py

# base.py
cat > myproject/settings/base.py << 'EOF'
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent.parent

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'myapp',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'myproject.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'myproject.wsgi.application'
EOF

# local.py
cat > myproject/settings/local.py << 'EOF'
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
EOF

# ci.py
cat > myproject/settings/ci.py << 'EOF'
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
EOF

# production.py
cat > myproject/settings/production.py << 'EOF'
from .base import *
import os

SECRET_KEY = os.environ['DJANGO_SECRET_KEY']
DEBUG = False
ALLOWED_HOSTS = ['my-production-domain.com']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ['POSTGRES_DB'],
        'USER': os.environ['POSTGRES_USER'],
        'PASSWORD': os.environ['POSTGRES_PASSWORD'],
        'HOST': os.environ['POSTGRES_HOST'],
        'PORT': os.environ.get('POSTGRES_PORT', 5432),
    }
}
EOF

# urls.py
cat > myproject/urls.py << 'EOF'
from django.urls import path

urlpatterns = [
    path('', lambda request: None),
]
EOF

# wsgi.py
cat > myproject/wsgi.py << 'EOF'
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings.local')

application = get_wsgi_application()
EOF

# myapp/tests.py
cat > myapp/tests.py << 'EOF'
from django.test import TestCase

class SimpleTest(TestCase):
    def test_addition(self):
        self.assertEqual(1 + 1, 2)
EOF

# manage.py
cat > manage.py << 'EOF'
#!/usr/bin/env python
import os
import sys

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "myproject.settings.local")
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError("Couldn't import Django.") from exc
    execute_from_command_line(sys.argv)
EOF

# requirements.txt
cat > requirements.txt << 'EOF'
Django>=4.2,<5
python-dotenv
EOF

# .env
cat > .env << 'EOF'
DJANGO_SECRET_KEY=localdev123
EOF

# GitHub Actions workflow
cat > .github/workflows/ci.yml << 'EOF'
name: Django CI

on:
  push:
    branches: ['*']
  pull_request:
    branches: ['*']

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Run Django tests
        env:
          DJANGO_SECRET_KEY: ${{ secrets.CI_SECRET_KEY }}
        run: python manage.py test --settings=myproject.settings.ci
EOF

echo "Django CI/CD scaffold created successfully!"
