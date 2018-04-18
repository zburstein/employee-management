# Information

### *Note that this project is still in development! Many back end structures and processes have been completed, but very little of the front end has been designed yet, with exception of the skeleto of a number of tables and the two dashboards. Furthermore the front end is not designed for mobile devises at the moment

The website I have created here is a rudimentary employee management system built with Ruby on Rails for portfolio purposes. The app allows registered employees to clock in, clock out, and enter sales. The system tracks the number of hours an employee works and determines their wage earned per shift. In addition, it maintains this information within weekly payrolls so that information can be viewed on a weekly basis. This system pools tips based on who was working at the time of the sale and whether they are eligible to share tips. The elegibility and percentages recieved are set within the positions assigned to the employees. 

# Access

A sample site can be accessed at https://sample-employee-management.herokuapp.com/. Give 30 seconds for the app to wake. An employee must be logged in to access the site. The production datbase has not yet been seeded, but a number of employees do exist. 

### Manager:
* Name: Zane
* Employee ID: 53476
* Password: helloworld

### Non-Manager
* Name: Eli
* Employee ID: 76484
* Password: helloworld

An employee's access to the site is limited based upon whether they are a manager or not. 
 
# Functions

All employee funcitons can be executed within the Employee dashboard. This includes clocking in, clocking out, getting current tip amount for the current shift, and editing their profile.

Additionally, managers are given access to a number of additional administrative functions that can be accessed within the managers dashboard. This includes viewing, creating, and editing a number of resources. 

Weekly payrolls are available for viewing, and from there shifts and sales can either be edited or added. When a shift is added, the wage is calculated and added to the weekly payroll's totals. When a sale is edited or added, the tip is redistributed with new values. 

Employees can only be created by managers and certain properties for each employee can only be edited by a manager, such as their position and current wage. Each employee's page shows their weekly payrolls, a list of shifts, and their account details

And finally, positions can be created and edited. 

# Notes
Again, this project is still very much in development with more functionality and design to come. Feel free to mess around with it. 

The free tier of mailers on heroku takes some time to send 