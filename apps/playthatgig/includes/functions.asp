<%
function isNewUser

	if dba.execute("select iId from tblPlaylist where iUserID=" & user.iId).eof then 
		isNewUser=true
	else
		isNewUser=false
	end if

end function
%>