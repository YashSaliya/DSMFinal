
from django import forms
import firebase_admin
from firebase_admin import firestore

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


class MsRegistration(forms.Form):
    username = forms.CharField(max_length = 100)
    password = forms.CharField(widget = forms.PasswordInput)
    address  = forms.CharField(max_length = 200)
    state = forms.ChoiceField(choices = indianStates)
    city = forms.CharField(max_length = 100)
    pincode = forms.IntegerField()
    storage_capacity = forms.FloatField()
    minFatPercentCow = forms.FloatField()
    minFatPercentBuffalo = forms.FloatField()

    def __init__(self:forms.Form,*args,**kwargs):
        super(MsRegistration,self).__init__(*args,**kwargs)
        for field in self.fields:
            self.fields[field].widget.attrs.update({'class':'form-control'})

    def clean(self):
        from .views import db
        cleaned_data = super().clean()
        username = cleaned_data.get('username')
        doc_ref = db.collection(u'MilkSocieties').document(username)
        if doc_ref.get().exists:
            raise forms.ValidationError("Username already exists")
        return cleaned_data


