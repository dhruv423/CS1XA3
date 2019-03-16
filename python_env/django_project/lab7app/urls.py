from django.urls import path
from . import views

urlpatterns = [
    path('lab7/', views.lab7_app  , name='lab7app'),
]
