from django.db import models
from django.contrib.auth.models import User

class UserInfoManager(models.Manager):
    def create_user_info(self, username, password):
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

class ExpenseInfo(models.Model):
    
    Groceries = 'GR'
    Entertainment = 'EN'
    Other = 'OT'
    
    EXPENSE_CHOICES = (
                       (Groceries, 'Groceries'),
                       (Entertainment, 'Entertainment'),
                       (Other, 'Other'),
                       )
        
                       
    expenseVal = models.FloatField(default=0)
    expenseType = models.CharField(max_length=60, blank = "True", default="Works from Django New Model", choices = EXPENSE_CHOICES)
    user = models.ForeignKey(UserInfo, on_delete=models.CASCADE)


