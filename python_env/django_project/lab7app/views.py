from django.shortcuts import render
from django.http import HttpResponse

def lab7_app(request):
  name = request.POST.get("name","")
  password = request.POST.get("password","")

  if name == "Jimmy" and password == "Hendrix":
     html = "Cool"
  else:
     html = "Bad User Name"
  return HttpResponse(html)
