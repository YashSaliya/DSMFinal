
from django import forms
import firebase_admin
from firebase_admin import firestore
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



class RegisterForm(forms.Form):
    email = forms.EmailField(widget = forms.EmailInput)
    password = forms.CharField(widget = forms.PasswordInput,min_length=6,max_length=8)


    def __init__(self:forms.Form,*args,**kwargs):
        super(RegisterForm,self).__init__(*args,**kwargs)
        for field in self.fields:
            self.fields[field].widget.attrs.update({'class':'form-control'})





class MsRegistration(forms.Form):
    address  = forms.CharField(max_length = 200)
    state = forms.ChoiceField(choices = indianStates)
    city = forms.CharField(max_length = 100)
    pincode = forms.IntegerField()
    storage_capacity = forms.FloatField()
    minFatCow = forms.FloatField()
    minFatBuffalo = forms.FloatField()
    latitude = forms.FloatField(widget=forms.TextInput(attrs={'readonly': 'readonly'}))
    longitude = forms.FloatField(widget=forms.TextInput(attrs={'readonly': 'readonly'}))

    def __init__(self:forms.Form,*args,**kwargs):
        super(MsRegistration,self).__init__(*args,**kwargs)
        # self.fields['address'].widget.attrs.update({'onchange': 'get_lat_lng(this)'})
        for field in self.fields:
            self.fields[field].widget.attrs.update({'class':'form-control'})
            
    # def clean(self):
    #     cleaned_data = super().clean()
    #     address = cleaned_data.get('address')
    #     lat,lng=get_lat_lng(address)
    #     cleaned_data['latitude'] = lat
    #     cleaned_data['longitude'] = lng
        
    #     return cleaned_data

from geopy.geocoders import Nominatim

def get_lat_lng(address):
    API_KEY = 'a5a7d8f4c6f24fcfb94f8168961e380f'
    url = f'https://api.opencagedata.com/geocode/v1/json?q={address}&key={API_KEY}'
    response = requests.get(url)
    data = response.json()
    lat = data['results'][0]['geometry']['lat']
    lng = data['results'][0]['geometry']['lng']
    return lat, lng


