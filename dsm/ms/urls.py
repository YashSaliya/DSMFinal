from django.urls import path
from ms.views import *
urlpatterns = [
    path('',index,name = 'index'),
    path('register' ,register , name = 'register'),
    path('otherdetails',otherdetails,name = 'otherdetails'),
    path('login',login,name = 'login'),
    path('newuser',postregister,name = 'newuser'),
    path('logout',postlogout,name = 'logout'),
    path('profileupdate',profile,name= 'profile'),
    path('notification',notification,name= 'notification'),
    path('contract',contract,name='contract'),
    path('sms',temp),
    path('payment',payment,name='payment'),
<<<<<<< HEAD
    path('temp',temp,name="temp"),
    path('success',success,name="success")
=======
    path('prediction',prediction,name = 'prediction')
>>>>>>> 4361d79dcf23999d26f5ba1c991f6a4a51f4c645

    # path('addemailpass',asyncRequest,name = 'sendVerificationLink'),
]