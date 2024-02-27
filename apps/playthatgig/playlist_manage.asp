<%

form.initialize=false

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")
aspl(myApp.sPath & "/includes/nav.asp")

dim script : script=aspl.loadText(myApp.sPath & "/includes/script.js")
script=replace(script,"[FORMID]",form.id,1,-1,1)

form.writejs script

dim playlist : set playlist=new cls_playlist : playlist.pick (form.request("iId"))
'security
if aspl.convertNmbr(playlist.iId)=0 then form.write "no playlist selected" : aspl.die

if form.request("copied")="1" then
	aspl.addFB(l("itemhasbeencopied"))
end if

if form.postback then

	'session securitycheck
	if form.sameSession then			
	
		if aspl.convertNmbr(form.request("iSongID"))<>0 then
			playlist.addSong(form.request("iSongID"))
		end if	

		if aspl.convertNmbr(form.request("doCopy"))=1 then
			playlist.copy()
			form.writejs loadInTarget("dashboard","playlist_manage.asp","&copied=1&iId=" & playlist.iId)
			form.writejs "window.scrollTo(0, 0);"
		end if	

		if aspl.convertNmbr(form.request("doMail"))=1 then
			playlist.mail()
			aspl.addFB(l("mailsent"))
			form.writejs "window.scrollTo(0, 0);"
		end if			
				
		if aspl.convertNmbr(form.request("iDeleteID"))<>0 then
			playlist.deleteSong(form.request("iDeleteID"))
		end if		
		
		if aspl.convertNmbr(form.request("iDivID"))<>0 and aspl.convertNmbr(form.request("iTargetID"))<>0 then
			playlist.setSort form.request("iDivID"),form.request("iTargetID")
		end if
		
	end if
	
end if

dim songs : set songs=playlist.songs
dim songids : set songids=playlist.songids

'hidden field

dim iId : set iId=form.field("hidden")
iId.add "value",playlist.iId
iId.add "name","iId"
iId.add "id","iId"

dim iSongID : set iSongID=form.field("hidden")
iSongID.add "value","0"
iSongID.add "name","iSongID"
iSongID.add "id","iSongID"

dim iTargetID : set iTargetID=form.field("hidden")
iTargetID.add "value","0"
iTargetID.add "name","iTargetID"
iTargetID.add "id","iTargetID"

dim iDivID : set iDivID=form.field("hidden")
iDivID.add "value","0"
iDivID.add "name","iDivID"
iDivID.add "id","iDivID"

dim iDeleteID : set iDeleteID=form.field("hidden")
iDeleteID.add "value","0"
iDeleteID.add "name","iDeleteID"
iDeleteID.add "id","iDeleteID"

dim doCopy : set doCopy=form.field("hidden")
doCopy.add "value","0"
doCopy.add "name","doCopy"
doCopy.add "id","doCopy"

dim doMail : set doMail=form.field("hidden")
doMail.add "value","0"
doMail.add "name","doMail"
doMail.add "id","doMail"


dim heading : heading=""
heading=heading & "<div class=""container-fluid py-3"">"
heading=heading & "<h1 class=""display-6 fw-bold"">" & aspl.htmlencode(playlist.sName) & " (" & songs.count & " songs)</h1>"
heading=heading & "<p class=""col-md-12 fs-4"">" & aspl.htmlencode(playlist.sDescription) & "</p>"
heading=heading & "</div>"

form.write heading

form.newline 

if songs.count=0 then
	form.write "<div class=""alert alert-warning lead"">" & l("thisplaylisthasnosongsyet") & "</div>"
	form.newline 
	form.newline 

elseif songs.count>5 then
	

	dim home2 : set home2=form.field("button")
	home2.add "html",l("back")
	home2.add "class","btn btn-secondary"
	home2.add "onclick",load("","")

	dim edit2 : set edit2 = form.field("button")
	edit2.add "html",l("edit")
	edit2.add "class","btn btn-primary"
	edit2.add "onclick",loadmodaliId("playlist_edit.asp",playlist.iId,"&fromManager=1")

	dim copy2 : set copy2 = form.field("button")
	copy2.add "html",l("copy")
	copy2.add "class","btn btn-warning"
	copy2.add "onclick","$('#doCopy').val('1');$('#" & form.id & "').submit();return false;"

	dim delete2 : set delete2 = form.field("button")
	delete2.add "html",l("delete")
	delete2.add "class","btn btn-danger"
	delete2.add "onclick",loadmodaliId("playlist_delete.asp",playlist.iId,"&fromManager=1")

	dim excel2 : set excel2 = form.field("button")
	excel2.add "html","Export"
	excel2.add "class","btn btn-success"
	excel2.add "onclick",loadmodalXLiId("playlist_export.asp",playlist.iId,"")
	
	dim download2 : set download2 = form.field("button")
	download2.add "html","Download"
	download2.add "class","btn btn-info"
	download2.add "onclick","location.assign('" & directlink("playlist_download.asp","&iId=" & playlist.iId)& "');"
	
	dim mail2 : set mail2 = form.field("button")
	mail2.add "html",l("tomail")
	mail2.add "class","btn btn-warning"
	mail2.add "onclick","$('#doMail').val('1');$('#" & form.id & "').submit();return false;"
	
	form.newline
	form.newline
	
end if

dim drag : drag="<div id=""draggable"" ondrop=""drop(event)"" ondragover=""allowDrop(event)"">"

for each song in songs
	
	drag=drag & "<div id=""" & song & """ class=""lead alert alert-warning"" draggable=""true"" style=""cursor:move;width:100%"" ondragstart=""drag(event)"">"
					
				drag=drag & "<a  class=""link link-danger"" href=""#"" "
				drag=drag & "onclick=""$('#iDeleteID').val('" & song & "');$('#" & form.id & "').submit();return false;"">"
				drag=drag & "<span style=""width:30px"" class=""material-symbols-outlined icon"">delete</span></a>"		
			
		
			drag=drag & "<strong><a class=""link link-primary"" href=""#"" "
			drag=drag & " onclick=""" & loadmodalXLiId("song_view.asp",songs(song).iId,"&fromManager=" & playlist.iId) & """>" 
			drag=drag & aspl.htmlencode(songs(song).sTitle) & "</a></strong>"		
			
			dim extra : extra=""
			
			if not aspl.isEmpty(songs(song).sComments) then
				extra=extra & "&nbsp;<small><strong>" & aspl.htmlencode(songs(song).sComments) & "</strong></small>"
			end if
			if not aspl.isEmpty(songs(song).sTuning) then
				extra=extra & "&nbsp;<small>T <strong>" & aspl.htmlencode(songs(song).sTuning) & "</strong></small>"
			end if
			if not aspl.isEmpty(songs(song).sBPM) then
				extra=extra & "&nbsp;<small>B <strong>" & aspl.htmlencode(songs(song).sBPM) & "</strong></small>"
			end if	

			if not aspl.isEmpty(extra) then
				drag=drag & "<span style=""margin-left:15px"">" & aspl.convertStr(extra) & "</span>"
			end if
			
	
	drag=drag & "</div>"
next

drag=drag & "</div>"

form.write drag


dim home : set home=form.field("button")
home.add "html",l("back")
home.add "class","btn btn-secondary"
home.add "onclick",load("","")

dim edit : set edit = form.field("button")
edit.add "html",l("edit")
edit.add "class","btn btn-primary"
edit.add "onclick",loadmodaliId("playlist_edit.asp",playlist.iId,"&fromManager=1")

dim copy : set copy = form.field("button")
copy.add "html",l("copy")
copy.add "class","btn btn-warning"
copy.add "onclick","$('#doCopy').val('1');$('#" & form.id & "').submit();return false;"

dim delete : set delete = form.field("button")
delete.add "html",l("delete")
delete.add "class","btn btn-danger"
delete.add "onclick",loadmodaliId("playlist_delete.asp",playlist.iId,"&fromManager=1")

dim excel : set excel = form.field("button")
excel.add "html","Export"
excel.add "class","btn btn-success"
excel.add "onclick",loadmodalXLiId("playlist_export.asp",playlist.iId,"")

dim download : set download = form.field("button")
download.add "html","Download"
download.add "class","btn btn-info"
download.add "onclick","location.assign('" & directlink("playlist_download.asp","&iId=" & playlist.iId)& "');"

dim mail : set mail = form.field("button")
mail.add "html",l("tomail")
mail.add "class","btn btn-warning"
mail.add "onclick","$('#doMail').val('1');$('#" & form.id & "').submit();return false;"

form.newline 
form.newline 


dim allRS : set allRS=songRS
dim table : table="<table id=""newsongs"" class=""table table-striped"">"

table=table & "<thead>"
table=table & "<tr>"
table=table & "<th></th>"
table=table & "<th></th>"
table=table & "<th></th>"
table=table & "</tr>"
table=table & "</thead>"

while not allRS.eof

	table=table & "<tr>"
	table=table & "<td>" & aspl.htmlencode(aspl.convertStr(allRS("sTitle"))) & "</td>"
	table=table & "<td>" & aspl.htmlencode(aspl.convertStr(allRS("sArtist"))) & "</td>"
	table=table & "<td style=""width:135px"">"
	
	if not songids.exists(aspl.convertNmbr(allRS("iId"))) then
	
		table=table & "<a href=""#"" onclick=""$('#iSongID').val('" & aspl.convertStr(allRS("iId")) & "');$('#" & form.id & "').submit();return false;"" "
		table=table & " class=""btn btn-primary"">" & l("add") & "</a>"
	
	else
	
		table=table & "<a href=""#"" onclick=""return false;"" class=""btn btn-secondary"">" & l("added") & "</a>"	
	
	end if
	
	table=table & "</td></tr>"	
	
	allRS.movenext

wend

set allRS=nothing

table=table & "</tbody></table>"

form.write table

%>