<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim addnew : set addNew=form.field("button")
addnew.add "class","btn btn-primary"
addnew.add "html",l("addnew")
addnew.add "onclick",loadmodal("product_edit.asp","")

dim printDate : set printDate=form.field("date")
printDate.add "class","form-control"
printDate.add "style","width:220px"
printDate.add "id","printDate"
printDate.add "name","printDate"
printDate.add "value",aspl.convertHtmlDate(date)

form.newline

dim records, table : table=aspl.loadText(myApp.sPath & "/includes/export.txt")

dim product, products : set products=new cls_products

set products=products.list

dim totalEx, totalInc : totalEx=0 : totalInc=0

for each product in products

	on error resume next
	
	records=records & "<tr>"
		records=records & "<td><a class=""link link-primary"" href=""#"" onclick=""" & loadmodaliId("product_edit.asp",product,"") & """>"
		records=records & aspl.htmlencode(products(product).sName) & "</a></td>"
		records=records & "<td>&euro; " & products(product).iUnitPrice & "</td>"
		records=records & "<td>" & products(product).iQuantity & "</td>"
		records=records & "<td>" & products(product).iBTW & "%</td>"
		
		totalEx=totalEx + round(products(product).iUnitPrice * products(product).iQuantity,2) 
		
		records=records & "<td>&euro;  " & round(products(product).iUnitPrice * products(product).iQuantity,2)  & "</td>"
		
		totalInc=totalInc + round((products(product).iUnitPrice * products(product).iQuantity) + (products(product).iUnitPrice * products(product).iQuantity)/100* products(product).iBTW,2)
		
		records=records & "<td>&euro; " & round((products(product).iUnitPrice * products(product).iQuantity) + (products(product).iUnitPrice * products(product).iQuantity)/100* products(product).iBTW,2) & "</td>"
	
	
	if err.number<>0 then
		records=records & "<td style=""color:#FFF"" class=""bg-danger"">probleem met eenheidsprijs</td>"
		records=records & "<td style=""color:#FFF"" class=""bg-danger"">probleem met eenheidsprijs</td>"	
	end if
	
	records=records & "</tr>"
	
	on error goto 0
	
next


records=records & "<tr>"
records=records & "<td></td>"
records=records & "<td></td>"
records=records & "<td></td>"
records=records & "<td></td>"
records=records & "<td><strong>&euro; " & totalEx &"</strong></td>"
records=records & "<td><strong>&euro; " & totalInc &"</strong></td>"
records=records & "</tr>"

table=replace(table,"[RECORDS]",records,1,-1,1)

form.write table

%>