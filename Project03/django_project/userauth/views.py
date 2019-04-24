from django.http import HttpResponse
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.http import JsonResponse
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
        user = authenticate(request, username=uname, password=passw)
        newUser.save()
        login(request,user)
        
        return HttpResponse('LoggedIn')

    else:
        
        return HttpResponse('RegisterFailed')

def is_auth(request):
    if request.user.is_authenticated:
        return HttpResponse("IsAuth")
    else:
        return HttpResponse("NotAuth")


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


def logout_user(request):
    logout(request)
    return HttpResponse("LoggedOut")


def get_user_info(request):
    user = UserInfo.objects.get(user=request.user)
    uInfo = {}
    uInfo["income"] = user.income
    uInfo["expense"] = user.expense
    uInfo["expensetype"] = user.expenseType
    uInfo["loanamount"] = user.loanAmount
    uInfo["loanperiod"] = user.loanPeriod
    uInfo["loaninterest"] = user.loanInterest
    return JsonResponse(uInfo)
