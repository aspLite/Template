<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim addnew : set addNew=form.field("button")
addnew.add "class","btn btn-primary"
addnew.add "html",l("addnew")
addnew.add "onclick",loadmodal("song_edit.asp","")

dim table : table="<table id=""songtable"" class=""table table-striped"">"
table=table & "<thead>"
table=table & "<tr>"
table=table & "<th>"&l("title")&"</th>"
table=table & "<th>Artist</th>"
table=table & "</tr>"
table=table & "</thead>"
table=table & "<tbody>"

dim song, songs : set songs=new cls_songs

set songs=songs.list

for each song in songs
	table=table & "<tr>"
	table=table & "<td><a class=""link link-primary"" href=""#"" onclick=""" & loadmodaliId("song_edit.asp",song,"") & """>" & aspl.htmlencode(songs(song).sTitle) & "</a></td>"
	table=table & "<td>" & aspl.htmlencode(songs(song).sArtist) & "</td>"
	table=table & "</tr>"
next

table=table & "</tbody></table>"

form.write table & datatable("songtable")

%>