# myapp/views.py
from django.shortcuts import render

def home(request):
    return render(request, 'blog/home.html')  # به نام قالب خود اشاره کنید
