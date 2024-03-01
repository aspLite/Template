<%
aspl(myApp.sPath & "/includes/begin.asp")

dim playlist : set playlist=new cls_playlist : playlist.pick (form.request("iId"))
'security
if aspl.convertNmbr(playlist.iId)=0 then aspl.die

aspl.dump playlist.html(true)
%>