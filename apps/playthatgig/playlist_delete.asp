<%

form.initialize=false

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist
playlist.pick(form.request("iId"))
if not playlist.canBeDeleted then aspl.die

form.writejs modalLabel(l("deleteplaylist"))

if form.postback then

	'session securitycheck
	if form.sameSession then
	
		if playlist.remove then		
			
			aspl.addFB(l("itemdeleted"))
			
			if aspl.convertNmbr(form.request("fromManager"))=1 then
				form.writejs "setTimeout(function(){$('#crmModal').modal('hide');" & load("","") & "},1600);"
			else
				form.writejs loadInTarget("playlists","playlists.asp","")
				form.writejs "setTimeout(function(){$('#crmModal').modal('hide')},1600);"
			end if
			
			form.build
			
		end if
		
	end if
	
end if

dim iId : set iId=form.field("hidden")
iId.add "value",playlist.iId
iId.add "name","iId"

dim fromManager : set fromManager=form.field("hidden")
fromManager.add "value",form.request("fromManager")
fromManager.add "name","fromManager"

aspl.addWarning(l("deletecmd") & " <b>" & server.htmlencode(playlist.sName) & "</b>?")

dim submit : set submit=form.field("submit")
submit.add "html",l("Delete")
submit.add "class","btn btn-danger"
submit.add "container","span"

dim cancel : set cancel=form.field("button")
cancel.add "html",l("cancel")
cancel.add "class","btn btn-secondary"
cancel.add "container","span"

if aspl.convertNmbr(form.request("fromManager"))=1 then
	cancel.add "databsdismiss","modal"
else
	cancel.add "onclick",loadmodaliId("playlist_edit.asp",playlist.iId,"")
end if
%>