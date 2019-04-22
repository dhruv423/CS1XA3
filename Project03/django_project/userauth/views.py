from django.http import HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login
import json
from .models import UserInfo

def add_user(request):
    """recieves a json request containing username and password, saves it to the database
        and logs them in """
    
    json_req = json.loads(request.body)
    uname = json_req.get('username','')
    passw = json_req.get('password','')
    
    if uname != '':
        newUser = UserInfo.objects.create_user_info(username=uname,
                                        password=passw, info = "info")
        newUser.save()
        login(request,newUser.user)
        return HttpResponse('LoggedIn')

    else:
        return HttpResponse('RegisterFailed')

def save_user_profile(request):
    



def login_user(request):
    """recieves a json request { 'username' : 'val0' : 'password' : 'val1' } and
        authenticates and loggs in the user upon success """
    
    json_req = json.loads(request.body)
    uname = json_req.get('username','')
    passw = json_req.get('password','')
    
    user = authenticate(request,username=uname,password=passw)
    if user is not None:
        login(request,user)
        return HttpResponse('LoggedIn')
    else:
        return HttpResponse('LoginFailed')

def user_info(request):
    """serves content that is only available to a logged in user"""
    
    if not request.user.is_authenticated:
        return HttpResponse("LoggedOut")
    else:
        # do something only a logged in user can do
        return HttpResponse("Hello " + request.user.first_name)

def logout_user(request):
    logout(request)
    return HttpResponse("LoggedOut")
