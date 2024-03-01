<%
class cls_product

	Public iId, sName, iUserID, dUpdatedTS, bDeleted, iUnitPrice, iBTW, iQuantity
	
	Private Sub Class_Initialize		
		iId=0	
		bDeleted=false
		iBTW=21		
	End Sub	
	
	public function check
	
		check=true
		
		if aspl.isempty(sName) then
			aspl.addErr(l("nameismandatory"))
			check=false
		end if		
		
		if aspl.convertnmbr(iUnitPrice)=0 then
			aspl.addErr("Eenheidsprijs mag alleen cijfers bevatten")
			check=false		
		end if
		
	end function
			
	
	public function pick(id)	

		dim RS
		
		if aspl.isNumber(id) then
		
			dim sql : sql = "select * from tblProduct where bDeleted=false and iUserID=" & user.iId & " and iId=" & id
			
			set RS = dba.execute(sql)
			
			if not rs.eof then
			
				iId					= rs("iId")
				sName				= rs("sName")
				iUserID				= rs("iUserID")				
				dUpdatedTS			= rs("dUpdatedTS")
				bDeleted			= rs("bDeleted")
				iUnitPrice			= rs("iUnitPrice")
				iBTW				= rs("iBTW")
				iQuantity			= rs("iQuantity")
				
	
			end if
			
			set RS = nothing
			
		end if
		
	end function
	
	
	public function save()
	
		if check() then
			save=true
		else
			save=false
			exit function
		end if		
		
		dim rs : set rs = dba.rs		
		
		if iId=0 then			
			rs.Open "select * from tblProduct where 1=2"
			rs.AddNew			
		else
			rs.Open "select * from tblProduct where bDeleted=false and iUserID=" & user.iId & " and iId="& iId
		end if
		
		rs("sName")					= left(aspl.convertStr(aspl.removeTabs(sName)),255)		
		rs("iUserID")				= aspl.convertNull(user.iId)
		rs("bDeleted")				= aspl.convertBool(bDeleted)
		rs("iBTW")					= aspl.convertNmbr(iBTW)
		rs("iQuantity")				= aspl.convertNmbr(iQuantity)
		rs("iUnitPrice")			= aspl.convertStr(iUnitPrice)		
		
		rs("dUpdatedTS")			= now()	
				
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))		
		
		rs.close
		
		Set rs = nothing		
		
	end function
	
	
	public function remove
	
		remove=false		
		
		if iId<>0 then
		
			bDeleted=true : save()	
			
			remove=true
			
		end if
		
	end function
	
	
	public function copy
	
		copy=false
		
		dim oldID : oldID=iId 
	
		if iId<>0 then		
		
			sName=sName & " (" & l("copyw") & ")" 
			iId=0 : save()		
			
			copy=true
			
		end if
	
	end function
	
	
	public function canBeDeleted
	
		canBeDeleted=true
		
		if iId=0 then canBeDeleted=false
	
	end function		

end class


class cls_products

	public list

	Private Sub Class_Initialize		
		
		Set list = aspL.dict
	
		dim sql : sql="select * from tblProduct where bDeleted=false and iUserID=" & user.iId & " order by sName"
		
		dim product, rs : set rs=dba.execute(sql)				
		
		while not rs.eof			
		
			set product=new cls_product : product.pick(aspl.convertNmbr(rs("iId")))
		
			list.add product.iId,product
			
			set product=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing			

	End Sub	
		
	
	Private Sub Class_Terminate
	
		Set list = nothing
		
	End Sub	
	

end class


class cls_btwlist

	public list

	Private Sub Class_Initialize		
		
		Set list = aspL.dict
		
		list.add 6,6
		list.add 21,21		
		
	end sub


end class

%>