<%

form.initialize=false

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim product : set product=new cls_product
product.pick(form.request("iId"))

form.writejs modalLabel("Product bewerken/invoegen")

if form.postback then

	'session securitycheck
	if form.sameSession then	
		
		product.sName			=	aspl.textOnly(form.request("sName"))	
		product.iUnitPrice		=	aspl.textOnly(form.request("iUnitPrice"))
		product.iQuantity		=	form.request("iQuantity")
		product.iBTW			=	form.request("iBTW")
						
		if product.save then
			
			aspl.addFB(l("changeshavebeensaved"))				
			
			form.writejs loadInTarget("products","products.asp","")
			
		
		end if
		
	end if
	
end if

dim iId : set iId=form.field("hidden")
iId.add "value",product.iId
iId.add "name","iId"

dim sName : set sName=form.field("text")
sName.add "required",true
sName.add "class","form-control"
sName.add "label",l("name")
sName.add "name","sName"
sName.add "value",product.sName
sName.add "maxlength",255

form.newline

dim iUnitPrice : set iUnitPrice=form.field("text")
iUnitPrice.add "class","form-control"
iUnitPrice.add "label","Eenheidsprijs (&euro;) - decimalen achter komma vb: 23,10"
iUnitPrice.add "name","iUnitPrice"
iUnitPrice.add "value",product.iUnitPrice

form.newline

dim iQuantity : set iQuantity=form.field("number")
iQuantity.add "class","form-control"
iQuantity.add "label","Hoeveelheid"
iQuantity.add "name","iQuantity"
iQuantity.add "value",product.iQuantity

form.newline

dim iBTWlist : set iBTWlist=new cls_btwlist : set iBTWlist=iBTWlist.list

dim iBTW : set iBTW=form.field("select")
iBTW.add "value",product.iBTW
iBTW.add "name","iBTW"
iBTW.add "id","iBTW"
iBTW.add "options",iBTWlist
iBTW.add "label","BTW (%)"

form.newline

dim submit : set submit=form.field("submit")
submit.add "html",l("Save")
submit.add "class","btn btn-primary"
submit.add "container","span"

if product.canBeDeleted then

	dim delete : set delete=form.field("button")
	delete.add "html",l("Delete")
	delete.add "class","btn btn-secondary"
	delete.add "container","span"
	delete.add "onclick",loadmodaliId("product_delete.asp",product.iId,"")
end if

%>