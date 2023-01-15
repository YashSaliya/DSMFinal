import datetime
from django.shortcuts import render
import firebase_admin
from firebase_admin import firestore
from firebase_admin import auth
from requests import request
from .forms import *
#import user from django 
import django.contrib.auth.models as django
#import messages
from django.contrib import messages 
from django.http import *
from django.shortcuts import redirect


cred = firebase_admin.credentials.Certificate("certificate.json")

app = firebase_admin.initialize_app(cred)

db = firestore.client()


def login_required(function):
    def wrapper(request,*args,**kwargs):
        if 'sessionCookie' in request.session:
            try:
                decoded_claims = auth.verify_session_cookie(request.session['sessionCookie'], check_revoked=True)
                request.session['user'] = decoded_claims['uid']
                return function(request,*args,**kwargs)
            except Exception as e:
                print(e)
                return redirect('login')
        else:
            return redirect('login')
    return wrapper

@login_required
def index(request):
    if db.collection(u'MilkSocieties').document(request.session['user']).get().exists:
        return render(request, 'index.html')
    else:
        return redirect('otherdetails')

def register(request):
    form = RegisterForm()
    return render(request, 'registration.html',context = {"form":form})

def postregister(request):
    if request.method == "POST":
        import json
        token = json.loads(request.body.decode('utf-8'))['tokenVal']
        cookie = auth.create_session_cookie(token, expires_in=datetime.timedelta(days=5))
        request.session['sessionCookie'] = cookie
        response = HttpResponse()
        response.status_code = 200
        return response
    response = HttpResponse()
    response.status_code = 400
    return response

@login_required
def postlogout(request):
    if request.method == "POST":
        import json
        token = json.loads(request.body.decode('utf-8'))['tokenVal']
        auth.revoke_refresh_tokens(token)
        response = HttpResponse()
        response.status_code = 200
        response.delete_cookie('sessionCookie')
        return response
    response = HttpResponse()
    response.status_code = 400
    return response

def login(request):
    form = RegisterForm()
    return render(request, 'login.html',context = {"form":form})
    

@login_required
def otherdetails(request):
    if request.method != "POST":
        form = MsRegistration()
        return render(request, 'otherdetails.html',context = {"form":form})
    else:
        form = MsRegistration(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            print(data)
            print("hello" + str(request.session['user']))
            doc_ref = db.collection(u'MilkSocieties').document(request.session['user'])
            doc_ref.set(data)
            return render(request, 'index.html')
        else:
            return render(request, 'otherdetails.html',context = {"form":form})

@login_required
def profile(request):
    if request.method != "POST":
        #populate form with firestore stored data 
        doc_ref = db.collection(u'MilkSocieties').document(request.session['user'])
        doc = doc_ref.get()
        data = doc.to_dict()
        form = MsRegistration(initial=data)
        return render(request, 'editprofile.html',context = {"form":form})
    else:
        form = MsRegistration(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            doc_ref = db.collection(u'MilkSocieties').document(request.session['user'])
            doc_ref.update(data)
            messages.info(request,"Profile Updated")
            return redirect('profile')
        else:
            messages.warning(request,form.errors)
            return render(request, 'editprofile.html',context = {"form":form})