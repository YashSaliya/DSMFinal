from django.urls import path
from ms.views import *
urlpatterns = [
    path('',index),
    path('register' ,register , name = 'register'),
]