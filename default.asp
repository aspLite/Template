<!-- #include file="asplite/asplite.asp"-->
<!-- #include file="asp/includes.asp"-->
<%
'create a database object. 
const dbpath	=	"db/db.mdb"
dim db : set db=aspL.plugin("database") : db.path=dbpath
dim system : set system=new cls_system
dim sec : set sec=new cls_Sec : sec.autologin
dim user : set user=sec.user : user.setLoginTS

if not aspl.isEmpty(aspL.getRequest("asplEvent")) then
	aspL("asp/" & aspL.getRequest("asplEvent") & ".resx")		
end if

'show signup/login form or dashboard?
dim main
if sec.autologin then 
	main=aspl.loadText("html/dashboard.htm")
else
	main=aspl.loadText("html/login.htm")
	
	if system.bAllowNewRegistrations or aspl.convertNmbr(session("userToBeConfirmed"))<>0 then
		main=replace(main,"[display]","",1,-1,1)
	else
		main=replace(main,"[display]","d-none",1,-1,1)
	end if
	
end if

'#######################################################
'#####  NAV
'#######################################################

dim nav
nav="<ul class=""navbar-nav me-auto mb-2 mb-md-0"">"

nav=nav & "<li class=""nav-item"">"
nav=nav & "<a class=""nav-link"" href=""[curPageURL]"">"
nav=nav & getIcon("home")
nav=nav & l("home") & "</a></li>"

if user.bAdmin then
	nav=nav & "<li class=""nav-item"">"	
	nav=nav & "<a class=""nav-link"" href=""#"" onclick=""$('.navbar-collapse').collapse('hide');load('admin_dashboard','dashboard','');return false;"">"
	nav=nav & getIcon("settings")
	nav=nav & l("admin") & "</a></li>"	
end if

if sec.autologin then
	nav=nav & "<li class=""nav-item"">"
	nav=nav & "<a class=""nav-link"" href=""#"" onclick=""$('.navbar-collapse').collapse('hide');modalAspForm('myaccount','','');return false;"">"
	nav=nav & getIcon("person") & l("account ") & "</a>"
	nav=nav & "</li>"
	nav=nav & "<li class=""nav-item"">"
	nav=nav & "<a class=""nav-link"" href=""#"" onclick=""$('.navbar-collapse').collapse('hide');modalAspForm('signout','','');return false;"">"
	nav=nav & getIcon("logout") & l("signout") & "</a>"
	nav=nav & "</li>"
end if

nav=nav & "</ul>"

'response.write default
dim body : body=aspL.loadText("html/default.htm")
body=replace(body,"[main]",main,1,-1,1)
body=replace(body,"[nav]",nav,1,-1,1)
body=replace(body,"[titletag]",system.sName,1,-1,1)
body=replace(body,"[light]",l("light"),1,-1,1)
body=replace(body,"[dark]",l("dark"),1,-1,1)
body=replace(body,"[auto]",l("auto"),1,-1,1)
body=replace(body,"[systemName]",system.sName,1,-1,1)
body=replace(body,"[forgotpassword]",l("forgotpassword"),1,-1,1)
body=replace(body,"[close]",l("close"),1,-1,1)
body=replace(body,"[signin]",l("signin"),1,-1,1)
body=replace(body,"[register]",l("register"),1,-1,1)
body=replace(body,"[curPageURL]",getSiteUrl,1,-1,1)

response.write body

'destroy aspLite
set aspL=nothing

%>
