from django.urls import path
from ms.views import *
urlpatterns = [
    path('',index,name = 'index'),
    path('register' ,register , name = 'register'),
    path('otherdetails',otherdetails,name = 'otherdetails'),
    path('login',login,name = 'login'),
    path('newuser',postregister,name = 'newuser'),
    # path('addemailpass',asyncRequest,name = 'sendVerificationLink'),
]