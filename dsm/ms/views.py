import datetime
from datetime import timedelta
from django.shortcuts import render
import firebase_admin
from firebase_admin import firestore
from firebase_admin import auth
import json
from firebase_admin import storage
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
from dsm.settings import apikey
from django.shortcuts import render
from firebase_admin import auth
import random
from twilio.rest import Client
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
    if key and  db.collection(key).document("milkSociety").collection("district_ms").document(request.session['user']).get().exists:
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
        cookie = auth.create_session_cookie(token, expires_in=timedelta(days=5))
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
        return render(request, 'otherdetails.html',context = {"form":form,'apikey':json.dumps(apikey)})
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
        return render(request, 'editprofile.html',context = {"form":form,'apikey':json.dumps(apikey)})
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
    
    # return render(request,'contract.html',{'data':'data'})
    key=db.collection("Cluster_key").document(request.session['user']).get().get("key")
    doc_ref = db.collection(key).document("milkSociety").collection("district_ms").document(request.session['user'])
    doc=doc_ref.get()
    data=doc.to_dict()
    form=contract_details()
    # name=data['name']

    user = auth.get_user(request.session['user'])
    print('Successfully fetched user data: {0}'.format(user.email))
    if request.method!='POST':
        
        return render(request,"notification.html",{'msid':json.dumps(request.session['user']),
        'data':json.dumps(data),'form':form,'key':json.dumps(key)})
    else:
        form = contract_details(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            print(data)
            fuser=auth.get_user(data['fid'])
            print(fuser.phone_number)
            pin = random.randrange(1000,9999)
            d={
                'f_name':data['farmer'],
                'ms_name':data['milk_society'],
                'f_add':data['farmer_address'],
                'ms_add':data['milk_society_address'],
                'ms_email':user.email,
                'type':data['milk_type'],
                'qty':data['milk_qty'],
                'shift':data['shift'],
                'start_date':data['start_date'],
                'end_date':data['end_date'],
                'd':data['duration'],
                'fid':json.dumps(data['fid']),
                'msid':json.dumps(request.session['user']),
                'phn':fuser.phone_number,
                'pin':json.dumps(pin),
                'key':json.dumps(key)
                      

            }
            if d['type']=='Cow':
                d['minfat']=data['min_fat_cow']
            elif d['type']=='Buffalo':
                d['minfat']=data['min_fat_buffalo']
            elif d['type']=='Both':
                d['minfat_buffalo']=data['min_fat_buffalo']
                d['minfat_cow']=data['min_fat_cow']

            bucket=storage.bucket('ng-test-fb229.appspot.com')
            html = render(request, 'ms_f_contract.html', d).content
            
            blob = bucket.blob("ms_f/"+request.session['user']+"/"+data['fid']+"/contract.html")
            blob.upload_from_string(html, 'text/html')
            
           
            url = blob.generate_signed_url(
                expiration=timedelta(weeks=1),
                method='GET',
            )

            # Use the URL to access the file
            print(f'URL: {url}')
            key=db.collection("Cluster_key").document(data['fid']).get().get("key")
            farmer_doc = db.collection(key).document("milkSociety").collection("district_farmer").document(data['fid'])
            req_collection=farmer_doc.collection('Request').document(request.session['user'])
            req_collection.set({
                'msid':request.session['user'],
                'url':url,
                'pin':pin
            })
            doc_ref.collection('Contract').document(data['fid']).set({
                'f_name':data['farmer'],
                'milk_type':data['milk_type'],
                'qty':data['milk_qty'],
                'shift':data['shift'],
                'end_date':datetime.combine(data['end_date'], datetime.min.time()),
                'url':url,
                'status':'Farmer Verification Pending'

            })
            
            return render(request,'ms_f_contract.html',d)
        else:
            messages.warning(request,form.errors)
            return render(request,"notification.html",{'msid':json.dumps(request.session['user']),
        'data':json.dumps(data),'form':form,'key':json.dumps(key)})

def contract(request):
    key=db.collection("Cluster_key").document(request.session['user']).get().get("key")
    form=contract_terminate_detail()
    if request.method!='POST':


        return render(request,'contract.html',{'form':form,'msid':json.dumps(request.session['user']),'key':json.dumps(key)})

    else:
        iform=contract_terminate_detail(request.POST)
        if iform.is_valid():
            data=iform.cleaned_data
            print(data)
            db.collection(key).document('milkSociety').collection('district_ms').\
            document(request.session['user']).collection('Contract').document(data['fid']).update({
                'reason':data['reason'],
                'status':"Terminated",
                'url':"",
                
            })
            ms_name=db.collection(key).document('milkSociety').collection('district_ms').document(request.session['user']).get().get('name')
            account_sid = config('sms_api')
            auth_token = config('sms_auth')
            client = Client(account_sid, auth_token)

            message = client.messages\
                    .create(
                        body=f"This is to inform you that your Milk Supply Contract with {ms_name} has been terminated.Reason:{data['reason']}",
                        from_='+17656263877',
                        to='+919324709499'
                    )
            print(message.sid)
            bucket=storage.bucket('ng-test-fb229.appspot.com')
            blob = bucket.blob("ms_f/"+request.session['user']+"/"+data['fid']+"/contract.html")
            blob.delete()


        return render(request,'contract.html',{'form':form,'msid':json.dumps(request.session['user']),'key':json.dumps(key)})
        
        



def temp(request):
    account_sid = config('sms_api')
    auth_token = config('sms_auth')
    client = Client(account_sid, auth_token)

    message = client.messages\
                    .create(
                        body="hello from dsm project",
                        from_='+17656263877',
                        to='+919324709499'
                    )

    print(message.sid)
    return HttpResponse()                         