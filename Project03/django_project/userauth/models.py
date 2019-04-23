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
        
    # Information about User
    income = models.FloatField(default=0)
    expense = models.FloatField(default=0)
    expenseType = models.CharField(max_length=60, blank = "True")
    loanAmount = models.FloatField(default=0)
    loanPeriod = models.FloatField(default=0)
    loanInterest = models.FloatField(default=0)
                                
    objects = UserInfoManager()
