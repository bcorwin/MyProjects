from django import forms

class SaveImgForm(forms.Form):
    img = forms.CharField(label='Image', max_length=10000000, widget=forms.HiddenInput(),
            error_messages = {'required': 'Please draw something before submitting.'})