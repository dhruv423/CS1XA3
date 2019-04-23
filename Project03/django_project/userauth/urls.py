from django.urls import path
from . import views

# routed from e/macid/userauthapp/
urlpatterns = [
    path('adduser/', views.add_user , name = 'userauth-add_user') ,
    path('loginuser/', views.login_user , name = 'userauth-login_user') ,
    path('isauth/', views.is_auth , name = 'userauth-is_auth') ,
    path('logoutuser/', views.logout_user , name = 'userauth-logout_user') ,
]

