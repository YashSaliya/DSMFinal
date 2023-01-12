from django.shortcuts import render
import firebase_admin
from firebase_admin import firestore
from firebase_admin import auth
from requests import request
from .forms import *
#import user from django 
import django.contrib.auth.models as django



cred = firebase_admin.credentials.Certificate("certificate.json")

app = firebase_admin.initialize_app(cred)

db = firestore.client()
#Hello

def precheck(request):
    if 'user' in request.session:
        uid = request.session['user']
        user = auth.get_user(uid)
        if user:
            return True
        del request.session['user']

    return False
    




# Create your views here.
def index(request):
    users_ref = db.collection('users')
    docs = users_ref.stream()
    for doc in docs:
        print(f'{doc.id} => {doc.to_dict()}')
    return render(request, 'index.html')

def register(request):
    if precheck(request):
        return render(request, 'index.html')
    if request.method != "POST":
        form = RegisterForm()
        return render(request, 'registration.html',context = {"form":form})
    else:
        form = RegisterForm(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            user = auth.create_user(email = data['email'], password = data['password'], email_verified = False)
            request.session['user'] = user.uid
            return render(request, 'otherdetails.html',context = {"form":MsRegistration()})
        else:
            return render(request, 'registration.html',context = {"form":form})


def otherdetails(request):
    if not precheck(request):
        return render(request, 'registration.html',context = {"form":RegisterForm()})

    if request.method != "POST":
        form = MsRegistration()
        return render(request, 'otherdetails.html',context = {"form":form})
    else:
        form = MsRegistration(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            print("hello" + str(request.session['user']))
            doc_ref = db.collection(u'MilkSocieties').document(request.session['user'])
            doc_ref.set(data)
            return render(request, 'index.html')
        else:
            return render(request, 'otherdetails.html',context = {"form":form})