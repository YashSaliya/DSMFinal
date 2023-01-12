from django.urls import path
from ms.views import *
urlpatterns = [
    path('',index),
    path('register' ,register , name = 'register'),
    path('otherdetails',otherdetails,name = 'otherdetails')
    # path('addemailpass',asyncRequest,name = 'sendVerificationLink'),
]