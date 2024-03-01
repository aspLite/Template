<%
aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist : playlist.pick (form.request("iId"))
'security
if aspl.convertNmbr(playlist.iId)=0 then form.write "no playlist selected" : aspl.die

form.writejs modalLabelXL("Export playlist" & " " & playlist.sName)

dim table : table=aspl.loadText(myApp.sPath & "/includes/export.txt")

dim counter, records, song, songs : set songs=playlist.songs : records="" : counter=0

for each song in songs

	counter=counter+1

	records=records & "<tr>"
	records=records & "<td>" & counter &"</td>"
	records=records & "<td>" & aspl.htmlEncode(songs(song).sTitle) &"</td>"	
	records=records & "<td>" & aspl.htmlEncode(songs(song).sArtist) &"</td>"	
	records=records & "<td>" & aspl.htmlEncode(songs(song).sComments) &"</td>"
	records=records & "<td>" & aspl.htmlEncode(songs(song).sTuning) &"</td>"
	records=records & "<td>" & aspl.htmlEncode(songs(song).sBPM) &"</td>"
	records=records & "</tr>"	

next

table=replace(table,"[RECORDS]",records,1,-1,1)
table=replace(table,"[PLAYLIST]",aspl.htmlencjs(playlist.sName),1,-1,1)

form.write table

%>