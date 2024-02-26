<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim song : set song=new cls_song
song.pick(form.request("iId"))

dim edit : set edit=form.field("button")
edit.add "html",l("edit")
edit.add "class","btn btn-primary"
edit.add "onclick","$('#crmModalXL').modal('hide');" & loadmodaliId("song_edit.asp",song.iId,"&fromManager="& form.request("fromManager"))

form.newline

form.writejs modalLabelXL(song.sTitle & " (" & song.sArtist & ")")

dim extra

if not aspl.isEmpty(song.sTuning) then 
	extra=extra & "Tuning: <strong>" & aspl.htmlencode(song.sTuning) & "</strong>&nbsp;"
end if

if not aspl.isEmpty(song.sBPM) then 
	extra=extra & "BPM: <strong>" & aspl.htmlencode(song.sBPM) & "</strong>&nbsp;"
end if

if not aspl.isEmpty(extra) then
	form.write "<div class=""alert alert-info"">" & extra & "</div>"
end if

if not aspl.isEmpty(song.sComments) then 
	form.write "<div class=""alert alert-warning"">" & br(song.sComments) & "</div>"
end if

if not aspl.isEmpty(song.sLyrics) then 
	form.write "<div class=""alert alert-light""><pre>" & br(song.sLyrics) & "</pre></div>"
end if


%>