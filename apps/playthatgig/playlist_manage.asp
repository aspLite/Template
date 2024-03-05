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

if aspl.convertNmbr(form.request("iDeletedID"))<>0 then
	playlist.deleteSong(form.request("iDeletedID"))
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
				
		if not aspl.isEmpty(form.request("iDivID")) then
			playlist.setSort form.request("iDivID")
		end if
		
	end if

else
	form.writejs "window.scrollTo(0, 0);"
end if

dim songs : set songs=playlist.songsFast
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

dim iDivID : set iDivID=form.field("hidden")
iDivID.add "value",""
iDivID.add "name","iDivID"
iDivID.add "id","iDivID"

dim doCopy : set doCopy=form.field("hidden")
doCopy.add "value","0"
doCopy.add "name","doCopy"
doCopy.add "id","doCopy"

dim doMail : set doMail=form.field("hidden")
doMail.add "value","0"
doMail.add "name","doMail"
doMail.add "id","doMail"

dim heading : heading=""
heading=heading & "<div class=""container-fluid py-3 justify-content-center text-center"">"
heading=heading & "<h1 class=""display-6 fw-bold"">" & aspl.htmlencode(playlist.sName) & " (" & songs.count & " " & lcase(l("songs")) & ")</h1>"
heading=heading & "<p class=""col-md-12 fs-4"">" & aspl.htmlencode(playlist.sDescription) & "</p>"
heading=heading & "</div>"

form.write heading

dim buttons : buttons="<div class=""justify-content-center text-center"">"

buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" onclick=""" & load("","") & """ id="""" class=""btn btn-secondary"">"&l("back")&"</button>"
buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" onclick=""" & loadmodaliId("playlist_edit.asp",playlist.iId,"&iPlayListID=" & playlist.iId) & """ id="""" class=""btn btn-primary"">"&l("edit")&"</button>"
buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" onclick=""$('#doCopy').val('1');$('#" & form.id & "').submit();return false;"" id="""" class=""btn btn-warning"">"&l("copy")&"</button>"
buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" onclick=""" & loadmodaliId("playlist_delete.asp",playlist.iId,"&iPlayListID=" & playlist.iId) & """ id="""" class=""btn btn-danger"">"&l("delete")&"</button>"
buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" onclick=""" & loadmodaliId("playlist_randomsort.asp",playlist.iId,"") & """ id="""" class=""btn btn-dark"">Random sort</button>"
buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" onclick=""" & loadmodaliId("playlist_export.asp",playlist.iId,"") & """ id="""" class=""btn btn-success"">Export</button>"
buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" onclick=""location.assign('" & directlink("playlist_download.asp","&iId=" & playlist.iId)& "');"" id="""" class=""btn btn-info"">"&l("download")&"</button>"
buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" onclick=""window.prompt('Copy to clipboard: Ctrl+C, Enter', '" & playlist.getToken & "');"" id="""" class=""btn btn-secondary"">Share</button>"
buttons=buttons & "<button style=""margin-right:5px;margin-bottom:5px"" onclick=""$('#doMail').val('1');$('#" & form.id & "').submit();return false;"" id="""" class=""btn btn-warning"">"&l("tomail")&"</button>"
buttons=buttons & "<a style=""margin-right:5px;margin-bottom:5px"" href=""" & directlink("playlist_golive.asp","&iId=" &playlist.iId) & """ target=""_blank"" class=""btn btn-primary"">Go live <span class=""spinner-grow spinner-grow-sm"" role=""status"" aria-hidden=""true""></span></a>"
buttons=buttons & "</div>"

form.write buttons

form.newline

if songs.count=0 then
	form.write "<div style=""margin:0 auto;width:85%"" class=""alert alert-warning lead"">" & l("thisplaylisthasnosongsyet") & "</div>"
end if

dim drag : drag="<div id=""sortable"" style=""margin:0 auto;width:85%"">"

for each song in songs
	
	drag=drag & "<div id=""dd" & song & """ class=""alert alert-warning"" style=""cursor:move;margin-bottom:4px"">"
		
		drag=drag & "<div class=""row"" style=""width:100%"">"
		
			drag=drag & "<div class=""col"" "
			drag=drag & "style=""max-width:50px;background-size:50px 50px;background-position:center;background-repeat:no-repeat;"
			drag=drag & "background-image:url('" & myApp.sPath & "/includes/drag.png')"" >"
			drag=drag & "</div>"		
			
			drag=drag & "<div class=""col"">"					
				
				drag=drag & "<strong><a class=""link link-primary"" href=""#"" "
				drag=drag & " onclick=""" & loadmodalXLiId("song_view.asp",songs(song).iId,"&iLinkID=" & song &"&iPlaylistID=" & playlist.iId) & """>" 
				drag=drag & aspl.htmlencode(songs(song).sTitle) & "</a></strong>"		
				
				dim extra : extra=""
				
				if not aspl.isEmpty(songs(song).sComments) then
					extra=extra & " <small><strong>" & aspl.htmlencode(songs(song).sComments) & "</strong></small>"
				end if
				if not aspl.isEmpty(songs(song).sTuning) then
					extra=extra & " <small>T <strong>" & aspl.htmlencode(songs(song).sTuning) & "</strong></small>"
				end if
				if not aspl.isEmpty(songs(song).sBPM) then
					extra=extra & " <small>B <strong>" & aspl.htmlencode(songs(song).sBPM) & "</strong></small>"
				end if	

				if not aspl.isEmpty(extra) then
					drag=drag & "<span> " & aspl.convertStr(extra) & "</span>"
				end if
			
			drag=drag & "</div>"
		
		drag=drag & "</div>"
	
	drag=drag & "</div>"
	
next

drag=drag & "</div>"

form.write drag
form.newline

dim createnewsong 
createnewsong="<div class=""justify-content-center text-center"" style=""margin:0 auto"">"
createnewsong=createnewsong & "<button onclick=""" & loadmodaliId("song_edit.asp","","&addTo=1&iPlayListID=" & playlist.iId) & """ class=""btn btn-success"">"
createnewsong=createnewsong & l("createnewsong") 
createnewsong=createnewsong & "</button></div>"

form.write createnewsong

dim allRS : set allRS=songRS
dim table : table="<table style=""margin:0 auto;width:85%"" id=""newsongs"" class=""table table-striped"">"

table=table & "<thead>"
table=table & "<tr>"
table=table & "<th></th>"
table=table & "<th></th>"
table=table & "<th></th>"
table=table & "</tr>"
table=table & "</thead>"

while not allRS.eof

	table=table & "<tr>"
	
	table=table & "<td style=""width:135px"">"
	
	if not songids.exists(aspl.convertNmbr(allRS("iId"))) then
	
		table=table & "<a href=""#"" onclick=""$('#iSongID').val('" & aspl.convertStr(allRS("iId")) & "');$('#" & form.id & "').submit();return false;"" "
		table=table & " class=""btn btn-primary"">" & l("add") & "</a>"
	
	else
	
		table=table & "<a href=""#"" onclick=""return false;"" class=""btn btn-secondary"">" & l("added") & "</a>"	
	
	end if
	
	table=table & "</td>"
	
	table=table & "<td>" & aspl.htmlencode(aspl.convertStr(allRS("sTitle"))) & "</td>"
	table=table & "<td>" & aspl.htmlencode(aspl.convertStr(allRS("sArtist"))) & "</td>"	
	
	table=table & "</tr>"	
	
	allRS.movenext

wend

set allRS=nothing

table=table & "</tbody></table>"

form.write table

%>