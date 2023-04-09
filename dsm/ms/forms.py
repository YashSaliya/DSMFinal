
from datetime import datetime, timedelta
from django import forms
import firebase_admin
from firebase_admin import firestore
from firebase_admin.firestore import value
import requests

indianStates = [
('Andhra Pradesh', 'Andhra Pradesh'),
('Arunachal Pradesh', 'Arunachal Pradesh'),
('Assam', 'Assam'),
('Bihar', 'Bihar'),
('Chhattisgarh', 'Chhattisgarh'),
('Goa', 'Goa'),
('Gujarat', 'Gujarat'),
('Haryana', 'Haryana'),
('Himachal Pradesh', 'Himachal Pradesh'),
('Jharkhand', 'Jharkhand'),
('Karnataka', 'Karnataka'),
('Kerala', 'Kerala'),
('Madhya Pradesh', 'Madhya Pradesh'),
('Maharashtra', 'Maharashtra'),
('Manipur', 'Manipur'),
('Meghalaya', 'Meghalaya'),
('Mizoram', 'Mizoram'),
('Nagaland', 'Nagaland'),
('Odisha', 'Odisha'),
('Punjab', 'Punjab'),
('Rajasthan', 'Rajasthan'),
('Sikkim', 'Sikkim'),
('Tamil Nadu', 'Tamil Nadu'),
('Telangana', 'Telangana'),
('Tripura', 'Tripura'),
('Uttar Pradesh', 'Uttar Pradesh'),
('Uttarakhand', 'Uttarakhand'),
('West Bengal', 'West Bengal'),
('Andaman and Nicobar Islands', 'Andaman and Nicobar Islands'),
('Chandigarh', 'Chandigarh'),
('Dadra and Nagar Haveli and Daman and Diu', 'Dadra and Nagar Haveli and Daman and Diu'),
('Daman and Diu', 'Daman and Diu'),
('Lakshadweep', 'Lakshadweep'),
('Puducherry', 'Puducherry'),
('Jammu and Kashmir', 'Jammu and Kashmir'),
('Ladakh', 'Ladakh'),
]
districts = [
    ('Ahmednagar', 'Ahmednagar'),
    ('Akola', 'Akola'),
    ('Amravati', 'Amravati'),
    ('Aurangabad', 'Aurangabad'),
    ('Beed', 'Beed'),
    ('Bhandara', 'Bhandara'),
    ('Buldhana', 'Buldhana'),
    ('Chandrapur', 'Chandrapur'),
    ('Dhule', 'Dhule'),
    ('Gadchiroli', 'Gadchiroli'),
    ('Gondia', 'Gondia'),
    ('Hingoli', 'Hingoli'),
    ('Jalgaon', 'Jalgaon'),
    ('Jalna', 'Jalna'),
    ('Kolhapur', 'Kolhapur'),
    ('Latur', 'Latur'),
    ('Mumbai City', 'Mumbai City'),
    ('Mumbai Suburban', 'Mumbai Suburban'),
    ('Nagpur', 'Nagpur'),
    ('Nanded', 'Nanded'),
    ('Nandurbar', 'Nandurbar'),
    ('Nashik', 'Nashik'),
    ('Osmanabad', 'Osmanabad'),
    ('Palghar', 'Palghar'),
    ('Parbhani', 'Parbhani'),
    ('Pune', 'Pune'),
    ('Raigad', 'Raigad'),
    ('Ratnagiri', 'Ratnagiri'),
    ('Sangli', 'Sangli'),
    ('Satara', 'Satara'),
    ('Sindhudurg', 'Sindhudurg'),
    ('Solapur', 'Solapur'),
    ('Thane', 'Thane'),
    ('Wardha', 'Wardha'),
    ('Washim', 'Washim'),
    ('Yavatmal', 'Yavatmal'),
    ('Ahmedabad', 'Ahmedabad'),
    ('Amreli', 'Amreli'),
    ('Anand', 'Anand'),
    ('Aravalli', 'Aravalli'),
    ('Banaskantha', 'Banaskantha'),
    ('Bharuch', 'Bharuch'),
    ('Bhavnagar', 'Bhavnagar'),
    ('Botad', 'Botad'),
    ('Chhota Udaipur', 'Chhota Udaipur'),
    ('Dahod', 'Dahod'),
    ('Dang', 'Dang'),
    ('Devbhoomi Dwarka', 'Devbhoomi Dwarka'),
    ('Gandhinagar', 'Gandhinagar'),
    ('Girsomnath', 'Girsomnath'),
    ('Jamnagar', 'Jamnagar'),
    ('Junagadh', 'Junagadh'),
    ('Kutch', 'Kutch'),
    ('Kheda', 'Kheda'),
    ('Mahisagar', 'Mahisagar'),
    ('Mehsana', 'Mehsana'),
    ('Morbi', 'Morbi'),
    ('Narmada', 'Narmada'),
    ('Navsari', 'Navsari'),
    ('Panchmahal', 'Panchmahal'),
    ('Patan', 'Patan'),
    ('Porbandar', 'Porbandar'),
    ('Rajkot', 'Rajkot'),
    ('Sabarkantha', 'Sabarkantha'),
    ('Surat', 'Surat'),
    ('Surendranagar', 'Surendranagar'),
    ('Tapi', 'Tapi'),
    ('Vadodara', 'Vadodara'),
    ('Valsad', 'Valsad')
]



class RegisterForm(forms.Form):
    email = forms.EmailField(widget = forms.EmailInput)
    password = forms.CharField(widget = forms.PasswordInput,min_length=6,max_length=8)


    def __init__(self:forms.Form,*args,**kwargs):
        super(RegisterForm,self).__init__(*args,**kwargs)
        for field in self.fields:
            self.fields[field].widget.attrs.update({'class':'form-control'})

class contract_terminate_detail(forms.Form):
    reason=forms.CharField()
    fid=forms.CharField(widget=forms.HiddenInput())
    def __init__(self:forms.Form,*args,**kwargs):
        super(contract_terminate_detail,self).__init__(*args,**kwargs)
        
        for field in self.fields:
            self.fields[field].widget.attrs.update({'class':'form-control'})

class paymentForm(forms.Form):
    name = forms.ChoiceField(choices = [('1','1')])
    fatpercent = forms.FloatField()
    qty = forms.FloatField(widget = forms.NumberInput(attrs = {'oninput':'myfun()'}))
    amount = forms.FloatField(widget = forms.TextInput(attrs = {'readonly':'readonly'}))
    def __init__(self:forms.Form,*args,**kwargs):
        super(paymentForm,self).__init__(*args,**kwargs)
        # options = args[0]
        for field in self.fields:
            self.fields[field].widget.attrs.update({'class':'form-control'})

class contract_details(forms.Form):

    milk_society=forms.CharField(widget=forms.TextInput(attrs={'readonly':'readonly'}))
    milk_society_address=forms.CharField()
    farmer=forms.CharField(widget=forms.TextInput(attrs={'readonly':'readonly'}))
    farmer_address=forms.CharField(widget=forms.TextInput(attrs={'readonly':'readonly'}))
    milk_type=forms.CharField(widget=forms.TextInput(attrs={'readonly':'readonly'}))
    milk_qty=forms.CharField(widget=forms.TextInput(attrs={'readonly':'readonly'}))
    min_fat_cow=forms.CharField(widget=forms.TextInput(attrs={'readonly':'readonly'}))
    min_fat_buffalo=forms.CharField(widget=forms.TextInput(attrs={'readonly':'readonly'}))
    shift=forms.CharField(widget=forms.TextInput(attrs={'readonly':'readonly'}))
    start_date = forms.DateField(widget = forms.DateInput(attrs={'type':'date'}))
    duration=forms.IntegerField(widget=forms.TextInput(attrs={'placeholder':'Enter contract duration in months','oninput':'myfun()'}))
    end_date=forms.DateField(widget=forms.TextInput(attrs={'readonly':'readonly'}),required=False)
    fid=forms.CharField(widget=forms.HiddenInput())

    



    def __init__(self:forms.Form,*args,**kwargs):
        super(contract_details,self).__init__(*args,**kwargs)
        self.fields['min_fat_cow'].initial='NA'
        self.fields['min_fat_buffalo'].initial='NA'
        
        for field in self.fields:
            self.fields[field].widget.attrs.update({'class':'form-control'})


class MsRegistration(forms.Form):
    name = forms.CharField(max_length=25)
    entity=forms.CharField(widget=forms.TextInput(attrs={'readonly':'readonly'}))
    state = forms.ChoiceField(choices = indianStates)
    city = forms.CharField(max_length = 100)
    district = forms.ChoiceField(choices=districts)
    address  = forms.CharField(max_length = 200)
    pincode = forms.IntegerField()
    storage_capacity = forms.FloatField()
    minFatCow = forms.FloatField()
    minFatBuffalo = forms.FloatField()
    latitude = forms.FloatField(widget=forms.HiddenInput())
    longitude = forms.FloatField(widget=forms.HiddenInput())
    fatperkilorate = forms.FloatField()
    def __init__(self:forms.Form,*args,**kwargs):
        super(MsRegistration,self).__init__(*args,**kwargs)
        self.fields['entity'].initial="milkSociety"
        for field in self.fields:
            self.fields[field].widget.attrs.update({'class':'form-control'})
            
    # def clean(self):
    #     cleaned_data = super().clean()
    #     address = cleaned_data.get('address')
    #     lat,lng=get_lat_lng(address)
    #     cleaned_data['latitude'] = lat
    #     cleaned_data['longitude'] = lng
        
    #     return cleaned_data

class RouteForm(forms.Form):
    numberOfVehicles = forms.IntegerField()
    vehicleCapacities= forms.CharField(max_length = 100)
    demandsepByComma = forms.CharField(max_length = 50)
    def __init__(self:forms.Form,*args,**kwargs):
        super(RouteForm,self).__init__(*args,**kwargs)
        for field in self.fields:
            self.fields[field].widget.attrs.update({'class':'form-control'})
         