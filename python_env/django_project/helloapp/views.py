from django.shortcuts import render
from django.http import HttpResponse

def hello_world(request):
     html = "<html><body>Hello World</body></html>"
     return HttpResponse(html)

def get_test(request):
	name = request.GET.get("name","")
	age = request.GET.get("age", "")
	return HttpResponse("Your name: " + name + "\nYour age: " + age)
