<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

form.write aspl.loadText(myApp.sPath & "/default.htm")

form.writejs loadInTarget("products","products.asp","")
%>