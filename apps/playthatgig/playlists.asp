<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")

dim addnew : set addNew=form.field("button")
addnew.add "class","btn btn-primary"
addnew.add "html",l("addnew")
addnew.add "onclick",loadmodal("playlist_edit.asp","")

dim table : table="<table id=""playliststable"" class=""table table-striped"">"
table=table & "<thead>"
table=table & "<tr>"
table=table & "<th>"&l("name")&"</th>"
table=table & "<th></th>"
table=table & "</tr>"
table=table & "</thead>"
table=table & "<tbody>"

dim playlist, playlists : set playlists=new cls_playlists

set playlists=playlists.list

for each playlist in playlists
	table=table & "<tr>"
		table=table & "<td><a class=""link link-primary"" href=""#"" onclick=""" & loadmodaliId("playlist_edit.asp",playlist,"") & """>" & aspl.htmlencode(playlists(playlist).sName) & "</a></td>"
		table=table & "<td><a href=""#"" onclick=""" & load("playlist_manage.asp","&iId=" & playlist) & """ class=""btn btn-secondary"">" & l("manage") & "</a></td>"
	table=table & "</tr>"
next

table=table & "</tbody>"
table=table & "</table>"

form.write table & datatable("playliststable")
%>