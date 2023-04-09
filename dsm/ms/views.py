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
import pickle
from twilio.rest import Client

 

# from ortools.constraint_solver import routing_enums_pb2
# from ortools.constraint_solver import pywrapcp


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
            data['counter'] = 0
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
            req_collection.update({
                'msid':request.session['user'],
                'url':url,
                'pin':pin
            })
            doc_ref.collection('Contract').document(data['fid']).set({
                'f_name':data['farmer'],
                'milk_type':data['milk_type'],
                'qty':data['milk_qty'],
                'shift':data['shift'],
                'start_date': datetime.combine(data['start_date'],datetime.min.time()),
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

def payment(request):
    key=db.collection("Cluster_key").document(request.session['user']).get().get("key")
    cowrate = db.collection(key).document("milkSociety").collection('district_ms').document(request.session['user']).\
            get().get('cowfatperkilorate')
    bufrate = db.collection(key).document("milkSociety").collection('district_ms').document(request.session['user']).\
            get().get('buffatperkilorate')

    if request.method != 'POST':
        c=db.collection(key).document("milkSociety").collection('district_ms').document(request.session['user']).\
            collection('Contract').get()
        
        opts = []
        for x in c:
            fields=x.to_dict()
            print(fields)
            if fields['status']=="Completed":
                fuser=auth.get_user(x.id)
                phn=fuser.phone_number
                name=fields['f_name']
                opts.append((x.id, fields['token']))

        form = paymentForm()
        form.fields['name'].choices = opts


        return render(request,'payment.html',context= {'form':form,'cowrate':json.dumps(cowrate),'bufrate':json.dumps(bufrate)})
    else:
        
        form=paymentForm(request.POST)
        temp=request.POST.get('name')
        form.fields['name'].choices=[(temp,temp)]
        if form.is_valid():
            data=form.cleaned_data
            f_name=db.collection(key).document("milkSociety").collection('district_farmer').document(data['name']).\
                get().get("full_name")
            token=db.collection(key).document("milkSociety").collection('district_ms').document(request.session['user']).\
                collection('Contract').document(data['name']).get().get('token')
            ms_name=db.collection(key).document("milkSociety").collection('district_ms').document(request.session['user']).\
               get().get('name')
            record=db.collection(key).document("milkSociety").collection('district_ms').document(request.session['user']).\
            collection('Records')
            d={
                'name':str(token)+"/"+f_name,
                'milktype':data['milktype'],
                'fatpercent':data['fatpercent'],
                'qty':data['qty'],
                'amt':data['amount'],
                'shift':data['shift'],
                'date':datetime.combine(data['date'],datetime.min.time())
            }
            if data['milktype']=='Cow':
                d['rate']=cowrate
            else:
                d['rate']=bufrate
            record.add(d)
            f_record=db.collection(key).document("milkSociety").collection('district_farmer').document(data['name']).\
                collection("Records")
            d['name']=ms_name
            f_record.add(d)
            return render(request,'payment.html',context= {'form':form,'cowrate':json.dumps(cowrate),'bufrate':json.dumps(bufrate)})

            


            
        else:
            messages.error(request,message = form.errors)
            return render(request,'payment.html',context= {'form':form,'cowrate':json.dumps(cowrate),'bufrate':json.dumps(bufrate)})

def records(request):
    key=db.collection("Cluster_key").document(request.session['user']).get().get("key")
    records = db.collection(key).document("milkSociety").collection('district_ms').document(request.session['user']).\
        collection("Records").stream()
    documents=[]
    for doc in records:
        documents.append(doc.to_dict())
    for i in range(0,len(documents)):
        documents[i]['date']=documents[i]['date'].strftime('%Y-%m-%d')

    return render(request,'record.html',{'documents':documents})

def loadModel(start):
    baseNumber = 157
    def getWeekNumber(date):
        return date.isocalendar()[1]

    #calculate year from date
    def getYear(date):
        return date.isocalendar()[0]

    startDate = baseNumber +  52 * (getYear(start)-2019) + (getWeekNumber(start))
    endDate = startDate + 5

    #load model
    loaded_model = pickle.load(open('sarima_model.pkl', 'rb'))

    res = loaded_model.predict(start = startDate,end = endDate,dynamic = True)

    return res.values.tolist()


def prediction(request):
    if request.method != 'POST':
        return render(request,'prediction.html',{'res':[]})
    else:
        start = request.POST['startDate']
        start = datetime.strptime(start, '%Y-%m-%d')
        res = loadModel(start)
        t = {}
        for index,value in enumerate(res):
            t[index+1] = round(value,2)
        res = t
        del(res[6])
        return render(request,'prediction.html',{'res':res,'start':str(start)})

def create_data_model():
    """Stores the data for the problem."""
    data = {}
    data['distance_matrix'] = [
        [
            0, 548, 776, 696, 582
        ],
        [
            548, 0, 684, 308, 194
        ],
        [
            776, 684, 0, 992, 878
        ],
        [
            696, 308, 992, 0, 114
        ],
        [
            582, 194, 878, 114, 0
        ]
    ]
    data['demands'] = [4, 1, 1, 2, 4]
    data['vehicle_capacities'] = [15, 15, 15, 15]
    data['num_vehicles'] = 4
    data['depot'] = 0
    return data


def print_solution(data, manager, routing, solution):
    """Prints solution on console."""
    print(f'Objective: {solution.ObjectiveValue()}')
    total_distance = 0
    total_load = 0
    for vehicle_id in range(data['num_vehicles']):
        index = routing.Start(vehicle_id)
        plan_output = 'Route for vehicle {}:\n'.format(vehicle_id)
        route_distance = 0
        route_load = 0
        while not routing.IsEnd(index):
            node_index = manager.IndexToNode(index)
            route_load += data['demands'][node_index]
            plan_output += ' {0} Load({1}) -> '.format(node_index, route_load)
            previous_index = index
            index = solution.Value(routing.NextVar(index))
            route_distance += routing.GetArcCostForVehicle(
                previous_index, index, vehicle_id)
        plan_output += ' {0} Load({1})\n'.format(manager.IndexToNode(index),
                                                 route_load)
        plan_output += 'Distance of the route: {}m\n'.format(route_distance)
        plan_output += 'Load of the route: {}\n'.format(route_load)
        print(plan_output)
        total_distance += route_distance
        total_load += route_load
    print('Total distance of all routes: {}m'.format(total_distance))
    print('Total load of all routes: {}'.format(total_load))

def routes(request):
    if request.method == "POST":
        data = create_data_model()
        form = RouteForm(request.POST)
        if form.is_valid():
            formData = form.cleaned_data
            nV = int(formData['numberOfVehicles'])
            nt = []
            s = formData['vehicleCapacities'].split(",")
            for i in range(nV):
                nt.append(int(s[i]))
            data['vehicle_capacities'] = nt
            data['num_vehicles'] = nV
            nt = []
            s = formData['demandsepByComma'].split(",")
            for i in range(len(s)):
                nt.append(int(s[i]))
            data['demands'] = nt

            # Create the routing index manager.
            manager = pywrapcp.RoutingIndexManager(len(data['distance_matrix']),
                                                data['num_vehicles'], data['depot'])

            # Create Routing Model.
            routing = pywrapcp.RoutingModel(manager)


            # Create and register a transit callback.
            def distance_callback(from_index, to_index):
                """Returns the distance between the two nodes."""
                # Convert from routing variable Index to distance matrix NodeIndex.
                from_node = manager.IndexToNode(from_index)
                to_node = manager.IndexToNode(to_index)
                return data['distance_matrix'][from_node][to_node]

            transit_callback_index = routing.RegisterTransitCallback(distance_callback)

            # Define cost of each arc.
            routing.SetArcCostEvaluatorOfAllVehicles(transit_callback_index)


            # Add Capacity constraint.
            def demand_callback(from_index):
                """Returns the demand of the node."""
                # Convert from routing variable Index to demands NodeIndex.
                from_node = manager.IndexToNode(from_index)
                return data['demands'][from_node]

            demand_callback_index = routing.RegisterUnaryTransitCallback(
                demand_callback)
            routing.AddDimensionWithVehicleCapacity(
                demand_callback_index,
                0,  # null capacity slack
                data['vehicle_capacities'],  # vehicle maximum capacities
                True,  # start cumul to zero
                'Capacity')

            # Setting first solution heuristic.
            search_parameters = pywrapcp.DefaultRoutingSearchParameters()
            search_parameters.first_solution_strategy = (
                routing_enums_pb2.FirstSolutionStrategy.PATH_CHEAPEST_ARC)
            search_parameters.local_search_metaheuristic = (
                routing_enums_pb2.LocalSearchMetaheuristic.GUIDED_LOCAL_SEARCH)
            search_parameters.time_limit.FromSeconds(1)

            # Solve the problem.
            solution = routing.SolveWithParameters(search_parameters)
            if solution:
                print_solution(data, manager, routing, solution)
            return render(request,'routeoptimization.html',{'form':form})
        else:
            messages.error(request,message = form.errors)
            return render(request,'routeoptimization.html',{'form':form})
    else:
        form = RouteForm()
        return render(request,'routeoptimization.html',context={'form':form})

        

