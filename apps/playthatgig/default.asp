<%
'load all includes
aspl(myApp.sPath & "/includes/begin.asp")
aspl(myApp.sPath & "/includes/nav.asp")

'load dashboard
dim defaulthtm : defaulthtm=aspl.loadText(myApp.sPath & "/default.htm")
defaulthtm=replace(defaulthtm,"[PLAYLISTS]",l("playlists"),1,-1,1)
defaulthtm=replace(defaulthtm,"[SONGS]",l("songs"),1,-1,1)

form.write defaulthtm

form.writejs loadInTarget("playlists","playlists.asp","")
form.writejs loadInTarget("songs","songs.asp","")

'aspl(myApp.sPath & "/fill.txt")

%>