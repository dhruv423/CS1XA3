from django.db import models
from django.contrib.auth.models import User

class UserInfoManager(models.Manager):
    def create_user_info(self, username, password, info):
        user = User.objects.create_user(username=username,password=password)
        userinfo = self.create(user=user)
                                        
        return userinfo

class UserInfo(models.Model):
    user = models.OneToOneField(User,
                                on_delete=models.CASCADE,
                                primary_key=True)
        
    # Information
    income = models.FloatField(blank = "True")
    expense = models.FloatField(blank = "True")
    expenseType = models.CharField(blank = "True")
                                
    objects = UserInfoManager()
