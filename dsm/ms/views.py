from django.shortcuts import render
import firebase_admin
from firebase_admin import firestore
from .forms import *

cred = firebase_admin.credentials.Certificate("certificate.json")

app = firebase_admin.initialize_app(cred)

db = firestore.client()


# Create your views here.
def index(request):
    users_ref = db.collection('users')
    docs = users_ref.stream()
    for doc in docs:
        print(f'{doc.id} => {doc.to_dict()}')
    return render(request, 'index.html')


def register(request):
    if request.method != "POST":
        form = MsRegistration()
        return render(request, 'registration.html',context = {"form":form})
    else:
        form = MsRegistration(request.POST)
        if form.is_valid():
            data = {
                u'username':form.cleaned_data['username'],
                u'password':form.cleaned_data['password'],
                u'address':form.cleaned_data['address'],
                u'state':form.cleaned_data['state'],
                u'pincode':form.cleaned_data['pincode'],
                u'storage_capacity':form.cleaned_data['storage_capacity'],
                u'city':form.cleaned_data['city'],
                u'minFatPercentCow':form.cleaned_data['minFatPercentCow'],
                u'minFatPercentBuffalo':form.cleaned_data['minFatPercentBuffalo'],
                u'farmers':[],
            }
            db.collection(u'MilkSocieties').document(form.cleaned_data['username']).set(data)

            return render(request, 'index.html')
        else:
            return render(request, 'registration.html',context = {"form":form})
