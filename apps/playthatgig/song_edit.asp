<%
form.initialize=false

'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim bNew, song : set song=new cls_song : bNew=false
song.pick(form.request("iId"))

form.writejs modalLabel("Add/edit song")

if form.postback then

	'session securitycheck
	if form.sameSession then	
		
		song.sTitle		=	form.request("sTitle")
		song.sLyrics	=	form.request("sLyrics")
		song.sComments	=	form.request("sComments")
		song.sTuning	=	form.request("sTuning")
		song.sBPM		=	form.request("sBPM")
		song.sArtist	=	form.request("sArtist")
		
		if song.iId=0 then bNew=true
						
		if song.save then
			
			aspl.addFB(l("changeshavebeensaved"))	
			
			if aspl.convertNmbr(form.request("fromManager"))<>0 then
			
				form.writejs loadInTarget("dashboard","playlist_manage.asp","&iId=" & form.request("fromManager"))
			
			else
			
				form.writejs loadInTarget("songs","songs.asp","")
			
			end if
			
		else
			bNew=false
		end if
		
	end if
	
end if

dim iId : set iId=form.field("hidden")
iId.add "value",song.iId
iId.add "name","iId"

dim fromManager : set fromManager=form.field("hidden")
fromManager.add "value",form.request("fromManager")
fromManager.add "name","fromManager"

dim sTitle : set sTitle=form.field("text")
sTitle.add "required",true
sTitle.add "class","form-control"
sTitle.add "label",l("title")
sTitle.add "name","sTitle"
sTitle.add "value",song.sTitle
sTitle.add "maxlength",255

form.newline

dim sArtist : set sArtist=form.field("text")
sArtist.add "class","form-control"
sArtist.add "label","Artist"
sArtist.add "name","sArtist"
sArtist.add "value",song.sArtist
sArtist.add "maxlength",255

form.newline

dim sComments : set sComments=form.field("textarea")
sComments.add "class","form-control"
sComments.add "label",l("comments")
sComments.add "name","sComments"
sComments.add "value",song.sComments

form.newline

dim sLyrics : set sLyrics=form.field("textarea")
sLyrics.add "class","form-control"
sLyrics.add "label","Lyrics/Chords"
sLyrics.add "name","sLyrics"
sLyrics.add "value",song.sLyrics
sLyrics.add "style","height:120px"

form.newline

dim tuninglist : set tuninglist=new cls_tuning

set sTuning = form.field("select")
sTuning.add "value",song.sTuning
sTuning.add "name","sTuning"
sTuning.add "id","sTuning"
sTuning.add "options",tuninglist.list
sTuning.add "label","Tuning"

form.newline

dim bpmList : set bpmList=new cls_bpm

set sBPM = form.field("select")
sBPM.add "value",song.sBPM
sBPM.add "name","sBPM"
sBPM.add "id","sBPM"
sBPM.add "options",bpmList.list
sBPM.add "label","BPM"

form.newline

dim submit : set submit=form.field("submit")
submit.add "html",l("Save")
submit.add "class","btn btn-primary"
submit.add "container","span"

if bNew then
	dim addAnother : set addAnother=form.field("button")
	addAnother.add "html",l("addanother")
	addAnother.add "class","btn btn-warning"
	addAnother.add "container","span"
	addAnother.add "onclick",loadmodaliId("song_edit.asp","","")
end if

if song.canBeDeleted and aspl.convertNmbr(form.request("fromManager"))=0 then

	dim view : set view=form.field("button")
	view.add "html",l("view")
	view.add "class","btn btn-secondary"
	view.add "container","span"
	view.add "onclick","$('#crmModal').modal('hide');" & loadmodalXLiId("song_view.asp",song.iId,"")

	dim delete : set delete=form.field("button")
	delete.add "html",l("Delete")
	delete.add "class","btn btn-secondary"
	delete.add "container","span"
	delete.add "onclick",loadmodaliId("song_delete.asp",song.iId,"")
	
end if

%>