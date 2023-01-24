import datetime
from django.shortcuts import render
import firebase_admin
from firebase_admin import firestore
from firebase_admin import auth
import json
from requests import request
from .forms import *
from django.conf import settings
from decouple import config
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
    key=db.collection("Cluster_key").document(request.session['user']).get().get("key")
    if db.collection(key).document("milkSociety").collection("district_ms").document(request.session['user']).get().exists:
    
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
        return render(request, 'otherdetails.html',context = {"form":form,'apikey':json.dumps(config('apikey'))})
    else:
        form = MsRegistration(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            ck=db.collection("Cluster_key").document(request.session['user'])
            ck.set({
                "key":data['district']
            })
            print(data['district'])
            print("hello" + str(request.session['user']))
            
            ms_doc = db.collection(data["district"]).document("milkSociety")
            ms=ms_doc.collection(u"district_ms").document(request.session['user'])
            ms.set(data)

            return render(request, 'index.html')
        else:
            return render(request, 'otherdetails.html',context = {"form":form,'apikey':json.dumps(config('apikey'))})

@login_required
def profile(request):
    if request.method != "POST":
        #populate form with firestore stored data
        key=db.collection("Cluster_key").document(request.session['user']).get().get("key")
        
        doc_ref = db.collection(key).document("milkSociety").collection("district_ms").document(request.session['user'])

        doc = doc_ref.get()
        data = doc.to_dict()
        form = MsRegistration(initial=data)
        return render(request, 'editprofile.html',context = {"form":form,'apikey':json.dumps(config('apikey'))})
    else:
        form = MsRegistration(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            key=db.collection("Cluster_key").document(request.session['user']).get().get("key")
            doc_ref = db.collection(key).document("milkSociety").collection("district_ms").document(request.session['user'])
            old_data=doc_ref.get().to_dict()
            flag=0
            if key!=data['district']:
                doc_ref.delete()
                ck=db.collection("Cluster_key").document(request.session['user'])
                ck.set({
                    "key":data['district']
                })
                flag=1
            doc_ref = db.collection(data['district']).document("milkSociety").collection("district_ms").document(request.session['user'])
            if flag==1:
                doc_ref.set(old_data)      
            doc_ref.update(data)
            
            messages.info(request,"Profile Updated")
            return redirect('profile')
            
        else:
            messages.warning(request,form.errors)
            return render(request, 'editprofile.html',context = {"form":form,'apikey':json.dumps(config('apikey'))})
@login_required
def notification(request):

    return render(request,"notification.html",{'apikey':config('apikey')})
    
# void sendInfoToMilkSociety(String milkSocietyId, String farmerName) async {
#   final milkSocietyRequestRef = Firestore.instance.collection("milk_society_requests").document(milkSocietyId);
#   await milkSocietyRequestRef.setData({
#     "farmer_name": farmerName
#   });
# }
