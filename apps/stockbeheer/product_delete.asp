<%

form.initialize=false

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim product : set product=new cls_product
product.pick(form.request("iId"))
if not product.canBeDeleted then aspl.die

form.writejs modalLabel(l("deleteplaylist"))

if form.postback then

	'session securitycheck
	if form.sameSession then
	
		if product.remove then		
			
			aspl.addFB(l("itemdeleted"))
			
			form.writejs loadInTarget("products","products.asp","")
			form.writejs "setTimeout(function(){$('#crmModal').modal('hide')},1600);"
						
			form.build
			
		end if
		
	end if
	
end if

dim iId : set iId=form.field("hidden")
iId.add "value",product.iId
iId.add "name","iId"

aspl.addWarning(l("deletecmd") & " <b>" & server.htmlencode(product.sName) & "</b>?")

dim submit : set submit=form.field("submit")
submit.add "html",l("Delete")
submit.add "class","btn btn-danger"
submit.add "container","span"

dim cancel : set cancel=form.field("button")
cancel.add "html",l("cancel")
cancel.add "class","btn btn-secondary"
cancel.add "container","span"
cancel.add "onclick",loadmodaliId("product_edit.asp",product.iId,"")

%>