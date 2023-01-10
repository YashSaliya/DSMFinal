from django.shortcuts import render
import firebase_admin
from firebase_admin import firestore

cred = firebase_admin.credentials.Certificate("C://Users//yashs//Documents//DSMFinal//dsm//certificate.json")

app = firebase_admin.initialize_app(cred)

db = firestore.client()


# Create your views here.
def index(request):
    users_ref = db.collection('users')
    docs = users_ref.stream()
    for doc in docs:
        print(f'{doc.id} => {doc.to_dict()}')
    return render(request, 'index.html')

