# django-ci-cd/myapp/tests.py
from django.test import TestCase

class SimpleTest(TestCase):
   def test_addition(self):
       self.assertEqual(1 + 1, 2)  # Passing test

    #def test_failure_example(self):
       # self.assertEqual(2 * 2, 5)  # Intentional fail
