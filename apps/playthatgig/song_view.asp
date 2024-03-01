<%
'load all includes

form.initialize=false

aspl(myApp.sPath & "/includes/begin.asp")

dim song : set song=new cls_song
song.pick(form.request("iId")) : if song.iId=0 then aspl.die

dim playlist : set playlist=new cls_playlist : playlist.pick(form.request("iPlaylistID"))

dim edit : set edit=form.field("button")
edit.add "html",l("edit")
edit.add "class","btn btn-primary"
edit.add "onclick","$('#crmModalXL').modal('hide');" & loadmodaliId("song_edit.asp",song.iId,"&iPlaylistID="& playlist.iId)

if playlist.iId<>0 then
	dim remove : set remove=form.field("button")
	remove.add "html",l("delete")
	remove.add "class","btn btn-danger"
	remove.add "onclick","$('#crmModalXL').modal('hide');" & loadInTarget("dashboard","playlist_manage.asp","&iId=" & playlist.iId & "&iDeletedID=" & form.request("iLinkID"))
end if

dim metronome : set metronome=form.field("submit")
metronome.add "html",l("metronome")
metronome.add "class","btn btn-info"

'dim autoscroll : set autoscroll=form.field("button")
'autoscroll.add "html","Autoscroll"
'autoscroll.add "class","btn btn-danger"
'autoscroll.add "onclick","var intervalId;var scrollDistance = 5;intervalId = setInterval(function() {window.scrollTo(0, window.pageYOffset + scrollDistance);}, 100);"

dim close : set close=form.field("button")
close.add "html",l("close")
close.add "class","btn btn-secondary"
close.add "databsdismiss","modal"

dim button, songfiles, songfile : set songfiles=song.files

if songfiles.count>0 then form.newline
 
for each songfile in songfiles
	set button=form.field("button")
	button.add "html",getIcon("download") & songfiles(songfile).sFilename
	button.add "class","btn btn-sm btn-warning"
	button.add "onclick",songfiles(songfile).downloadLink
next

dim iId : set iId=form.field("hidden")
iId.add "value",song.iId
iId.add "name","iId"
iId.add "id","iId"

dim iPlaylistID : set iPlaylistID=form.field("hidden")
iPlaylistID.add "value",form.request("iPlaylistID")
iPlaylistID.add "name","iPlaylistID"
iPlaylistID.add "id","iPlaylistID"

dim iLinkID : set iLinkID=form.field("hidden")
iLinkID.add "value",form.request("iLinkID")
iLinkID.add "name","iLinkID"
iLinkID.add "id","iLinkID"

if form.postback then
	form.newline
	form.write "<iframe style=""border-radius:20px;width:350px;height:350px"" src=""" & myapp.sPath & "/metronome.asp?sBPM=" & song.sBPM & """></iframe>"
end if

form.newline

form.writejs modalLabelXL(song.sTitle & " (" & song.sArtist & ")")

dim extra

if not aspl.isEmpty(song.sTuning) then 
	extra=extra & l("tuning") & ": <strong>" & aspl.htmlencode(song.sTuning) & "</strong>&nbsp;"
end if

if not aspl.isEmpty(song.sBPM) then 
	extra=extra & "BPM: <strong>" & aspl.htmlencode(song.sBPM) & "</strong>&nbsp;"
end if

if not aspl.isEmpty(extra) then
	form.write "<div class=""alert alert-info"">" & extra & "</div>"
end if

if not aspl.isEmpty(song.sComments) then 
	form.write "<div class=""alert alert-danger"">" & br(song.sComments) & "</div>"
end if

'drawlyrics?
dim drawlyrics : drawlyrics=song.drawlyrics
if not aspl.isEmpty(drawlyrics) then 
	form.write "<div class=""alert alert-warning"">" & br(drawlyrics) & "</div>"
end if

if not aspl.isEmpty(song.sLyrics) then 
	form.write "<div class=""alert alert-light""><pre>" & br(song.sLyrics) & "</pre></div>"
end if


%>