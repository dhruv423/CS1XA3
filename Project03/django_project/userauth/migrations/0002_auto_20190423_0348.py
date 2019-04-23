# Generated by Django 2.1.7 on 2019-04-23 03:48

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('userauth', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userinfo',
            name='info',
        ),
        migrations.AddField(
            model_name='userinfo',
            name='expense',
            field=models.FloatField(default=0),
        ),
        migrations.AddField(
            model_name='userinfo',
            name='expenseType',
            field=models.CharField(blank='True', max_length=60),
        ),
        migrations.AddField(
            model_name='userinfo',
            name='income',
            field=models.FloatField(default=0),
        ),
        migrations.AddField(
            model_name='userinfo',
            name='loanAmount',
            field=models.FloatField(default=0),
        ),
        migrations.AddField(
            model_name='userinfo',
            name='loanInterest',
            field=models.FloatField(default=0),
        ),
        migrations.AddField(
            model_name='userinfo',
            name='loanPeriod',
            field=models.FloatField(default=0),
        ),
    ]