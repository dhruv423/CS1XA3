# Project 03 - FinTrack
This is the final project pertaining to this course.

## Setting Up

* Clone this repository by either downloading it or `git clone https://github.com/bhavsd1/CS1XA3.git` to your prefered location
* Create a Python Virtual Environment by `python3 venv envirname` in the prefered location
* Go in the virtual environment `cd envirname` and start it up `source bin/activate`
* Verify that you have the environment name in the front of the line in terminal
* Navigate back `cd ..`
* Install the required packages to run this app `pip install -r requirements.txt`
* After that is done downloading, go to the `django_project` folder `cd CS1XA3/Project03/django_project`
* Run the Django server `python3 manage.py runserver localhost:8000`
* Open up your browser and go to [http://localhost:8000/static/registerpage.html](http://localhost:8000/static/registerpage.html)
* Now create an account and play around with the app!


## Features

**Client Side**
Coming Soon

**Backend (Django)**
userauth app is used for user authentication related request.
Many models such as ExpenseInfo, LoanInfo and built-in User
ExpenseInfo and LoanInfo are Field.Choices which uses a Foreign Key Relationship



## Resources
The website for FinTrack was made from [SB Admin Free Bootstrap Template](https://startbootstrap.com/templates/sb-admin/) including the CSS.
The login and register page is modelled after [ColorLib Free Login Form](https://colorlib.com/wp/template/login-form-v2/).




