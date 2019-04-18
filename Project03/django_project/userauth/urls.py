from django.urls import path
from . import views

# routed from e/macid/userauthapp/
urlpatterns = [
    path('adduser/', views.add_user , name = 'userauth-add_user') ,
    path('loginuser/', views.login_user , name = 'userauth-login_user') ,
    path('userinfo/', views.user_info , name = 'userauth-user_info') ,
]

