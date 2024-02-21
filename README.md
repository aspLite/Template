# Template

## Installation
Install as a site or virtual directory. Enable 32bits applications in your IIS application pool as an MS Access database is used.

## Login
Username: admin@admin.com

Password: admin (make sure to change that)

## What?

This Classic ASP/VBScript web application is a template for modern Classic ASP web development. It makes use of Bootstrap 5.3 and the jQuery DataTables plugin. AJAX is used to load specific ASP/VBScript scripts based on specific events (onload, click) in specific areas of your UI. Communication between server and browser happens via the JSON data format.

The idea behind this app is to have something to start from each time you create a new Classic ASP/VBScript web application. Template takes care of:
- User registration / signin / forgot password / confirmation email / my account / signout
- Multilingual application
- Templating (Bootstrap 5)
- System settings / Mail setup
- Compress/Backup database / Recycle application
- Create custom applications on top of Template
- Error handling

## Examples

This template comes with six custom applications, each one demonstrating some basic functionalities. Make sure to check them out. 
Five applications are available to all users. One is available to administrators only. These apps can be found in the apps folder. For each application an entry is needed under "Admin/Applications". 
The code of any custom application is executed in the same namespace of default.asp (the one and only ASP-script that gets executed on each event). Therefore, all built-in functions and classes of the entire Template-project can be used in the custom apps.

## Documentation
Detailed documentation for this project is not yet available.
