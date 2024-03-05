<%
class cls_playlist

	Public iId, sName, sDescription, iUserID, dUpdatedTS, bDeleted, sToken
	
	Private Sub Class_Initialize		
		iId=0	
		bDeleted=false		
	End Sub	
	
	public function check
	
		check=true
		
		if aspl.isempty(sName) then
			aspl.addErr(l("nameismandatory"))
			check=false
		end if		
		
	end function
			
	
	public function pick(id)	

		dim RS
		
		if aspl.isNumber(id) then
		
			dim sql : sql = "select * from tblPlaylist where bDeleted=false and iUserID=" & user.iId & " and iId=" & id
			
			set RS = dba.execute(sql)
			
			if not rs.eof then
			
				iId					= rs("iId")
				sName				= rs("sName")
				iUserID				= rs("iUserID")
				sDescription		= rs("sDescription")
				dUpdatedTS			= rs("dUpdatedTS")
				bDeleted			= rs("bDeleted")
				sToken				= rs("sToken")
	
			end if
			
			set RS = nothing
			
		end if
		
	end function
	
	
	public function save()
	
		if check() then
			save=true
		else
			save=false
			exit function
		end if		
		
		dim rs : set rs = dba.rs		
		
		if iId=0 then			
			rs.Open "select * from tblPlaylist where 1=2"			
			rs.AddNew
			rs("sToken")			= aspl.randomizer.CreateGUID(10)			
		else
			rs.Open "select * from tblPlaylist where bDeleted=false and iUserID=" & user.iId & " and iId="& iId
		end if
		
		rs("sName")					= left(aspl.textonly(sName),255)		
		rs("sDescription")			= aspl.convertStr(aspl.removeTabs(sDescription))
		rs("iUserID")				= aspl.convertNull(user.iId)
		rs("bDeleted")				= aspl.convertBool(bDeleted)
		rs("dUpdatedTS")			= now()	
				
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))		
		
		rs.close
		
		Set rs = nothing		
		
	end function
	
	
	public property get getToken
	
		if aspl.isEmpty(sToken) then
		
			sToken=aspl.randomizer.CreateGUID(10)	
		
			dba.execute("update tblPlaylist set sToken='" & aspl.sqli(sToken) & "' where iId=" & iId)
		
		end if
		
		getToken=directlink("share","&iLid=" & user.iLanguageID & "&sToken=" & sToken & "&iId=" & iId)
	
	end property
	
	
	public function remove
	
		remove=false		
		
		if iId<>0 then
		
			bDeleted=true : save()	

			dba.execute("delete from tblPlaylistSong where iPlaylistID=" & iId)
			
			remove=true
			
		end if
		
	end function
	
	
	public function copy
	
		copy=false
		
		dim oldID : oldID=iId 
	
		if iId<>0 then		
		
			sName=sName & " (" & l("copyw") & ")" 
			iId=0 : save()
			
			'alle songs copieren
			dim rs, rsCopy
			set rs=dba.execute("select * from tblPlaylistSong where iPlaylistID=" & oldID)
			set rsCopy=dba.rs
			rsCopy.open "select * from tblPlaylistSong where 1=2"
			
			while not rs.eof
				
				rsCopy.AddNew
				
				rsCopy("iPlaylistID")	=	iId
				rsCopy("iSongID")		=	rs("iSongID")
				rsCopy("iSort")			=	rs("iSort")
								
				rsCopy.Update
				rs.movenext
				
			wend
			
			set rsCopy=nothing
			set rs=nothing
			
			copy=true
			
		end if
	
	end function
	
	
	public function songids
	
		Set songids = aspL.dict
	
		dim sql : sql="select iSongID from tblPlaylistSong where iPlaylistID=" & iId
		
		dim rs : set rs=dba.execute(sql)				
		
		while not rs.eof					
				
			songids.add aspl.convertNmbr(rs("iSongID")),""	
		
			rs.movenext
			
		wend 
		
		set rs=nothing	
		
	end function
	
	public sub randomize
	
		dim rs : set rs=dba.RS
		rs.open "select iSort, iId from tblPlaylistSong where iPlaylistID=" & iId & " order by Rnd(-Timer() * [iId]) Asc"
				
		dim counter : counter=1		
		while not rs.eof	
			
			rs("iSort")=counter	
			rs.update()
			
			rs.movenext
			counter=counter+1
			
		wend
		
		rs.close
		
		set rs=nothing	
	
	end sub
	
	
	public property get songCount
		
		dim rs : set rs=dba.execute("select count(iId) from tblPlaylistSong where iPlaylistID=" & iId)
		songCount=aspl.convertNmbr(rs(0)) : set rs=nothing
	
	end property
	
	public function songs
	
		Set songs = aspL.dict
	
		dim sql : sql="select iId, iSongID from tblPlaylistSong where iPlaylistID=" & iId & " order by iSort asc"
		
		dim song, rs : set rs=dba.execute(sql)				
		
		while not rs.eof			
		
			set song=new cls_song : song.pick(aspl.convertNmbr(rs("iSongID")))
		
			songs.add aspl.convertNmbr(rs("iId")),song
			
			set song=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing	
		
	end function
	
	public function songsFast
	
		Set songsFast = aspL.dict
	
		dim sql
		sql="select tblSong.sTitle, tblSong.sComments, tblSong.sTuning, tblSong.sBPM, tblPlaylistSong.iId, tblPlaylistSong.iSongID, tblPlaylistSong.iSort "
		sql=sql & " from tblPlaylistSong inner join tblSong on tblPlaylistSong.iSongID=tblSong.iId "
		sql=sql & " where tblPlaylistSong.iPlaylistID=" & iId
		sql=sql & " order by tblPlaylistSong.iSort asc"
		
		dim song, rs : set rs=dba.execute(sql)				
		
		while not rs.eof			
		
			set song=new cls_song
			
			song.iId		 	= rs("iSongID")
			song.sTitle		 	= rs("sTitle")
			song.sComments		= rs("sComments")
			song.sBPM		 	= rs("sBPM")
			song.sTitle		 	= rs("sTitle")
			song.sTuning		= rs("sTuning")
			song.iSort			= rs("iSort")
		
			songsFast.add aspl.convertNmbr(rs("iId")),song
			
			set song=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing	
		
	end function
	
	
	public function addSong(songID)
	
		dim rs : set rs=dba.execute("select iId from tblPlaylistSong where iPlaylistID=" & iId & " and iSongID=" & songID)
	
		if rs.eof then 
		
			dim rsAdd : set rsAdd=dba.RS
			rsAdd.open "select * from tblPlaylistSong where 1=2"
			
			rsAdd.AddNew
			rsAdd("iSongID")=songID
			rsAdd("iPlaylistID")=iId
			rsAdd("iSort")=songCount+1
			
			rsAdd.Update
			set rsAdd=nothing
		
		end if
		
	end function
	
	
	public function deleteSong(songID)
	
		dim rs : set rs=dba.execute("select iSort from tblPlaylistSong where iPlaylistID=" & iId & " and iId=" & songID)
	
		if not rs.eof then 				
			
			'rangorde herstellen
			dim rsDel
			set rsDel=dba.execute("update tblPlaylistSong set iSort=iSort-1 where iPlaylistID=" & iId & " and iSort>" & aspl.convertNmbr(rs(0)))
			set rsDel=nothing			
			 
			set rsDel=dba.execute("delete from tblPlaylistSong where iId=" & songID)
			set rsDel=nothing	
			
		end if
		
		set rs=nothing
		
	end function
		
	
	public function setSort(ids)
	
		dim sortIDs : sortIDs=split(ids,",")
		
		dim safeID, i, counter : counter=0
		for i=lbound(sortIDs) to ubound(sortIDS)
			counter=counter+1	
			safeID=replace(sortIDs(i),"dd","",1,-1,1)
			safeID=aspl.convertNmbr(safeID)
			if safeID<>0 then dba.execute("update tblPlayListSong set iSort=" & counter & " where iPlaylistID=" & iId & " and iId=" & safeID)
		next	
		
	end function
	
	
	public function canBeDeleted
	
		canBeDeleted=true
		
		if iId=0 then canBeDeleted=false
	
	end function	
	
	private function scroller
	
		scroller="<button class=""autoscroll"" style=""font-size:16px;border-style:none;background-color:#DC3545;color:#FFF;padding:8px 14px 8px 14px;border-radius:6px;margin-right:5px"" "
		scroller=scroller & "onclick=""scrollpage(this);return false;"" href=""#"">Autoscroll</button>"
		scroller=scroller & "<button onclick=""scrollStarted=0;clearInterval(intervalId);intervalTimeout=intervalTimeout+25;scrollpage(this);return false;"" style=""visibility:hidden;font-size:16px;border-style:none;background-color:#DC3545;color:#FFF;padding:8px 18px 8px 18px;border-radius:6px;margin-right:5px"" class=""tweak"">-</button>"
		scroller=scroller & "<button onclick=""scrollStarted=0;clearInterval(intervalId);intervalTimeout=intervalTimeout-25;scrollpage(this);return false;"" style=""visibility:hidden;font-size:16px;border-style:none;background-color:#DC3545;color:#FFF;padding:8px 18px 8px 18px;border-radius:6px;"" class=""tweak"">+</button>"
	
	end function
	
	
	private function nav(counter,includeJS)
	
			nav="<p>"			
			nav=nav & "<a style=""border-radius:6px;color:#000000;text-decoration:none;background-color:#FFC107;margin-right:10px;margin-top:15px;padding:8px 14px 8px 14px"" href=""#top"">Top</a>"
			nav=nav & "<a style=""border-radius:6px;color:#FFFFFF;text-decoration:none;background-color:#0B5ED7;margin-right:10px;margin-top:15px;padding:8px 14px 8px 14px"" href=""#songID"&counter+1&""">" & l("next") & "</a>"
			nav=nav & "<a style=""border-radius:6px;color:#000000;text-decoration:none;background-color:#0DCAF0;margin-right:10px;margin-top:15px;padding:8px 14px 8px 14px"" href=""#songID"&counter-1&""">" & l("previous") & "</a>"
			nav=nav & "<a style=""border-radius:6px;color:#FFFFFF;text-decoration:none;background-color:#198754;margin-right:10px;margin-top:15px;padding:8px 14px 8px 14px"" href=""#songIDChords"&counter&""">" & l("chords") & "</a>"

			if includeJS then
				nav=nav &  "<div>" & scroller & "</div>"
			end if
			
			nav=nav & "</p>"
	
	end function
	
	public function html(includeJS)
	
		dim drawLyrics, counter, records, song, songsCopy : set songsCopy=songs : records="" : counter=0

		records="<h1>" & aspl.htmlEncode(sName) & " (" & songsCopy.count & " " & lcase(l("songs")) & ")</h1>"
		records=records & "<h3>" & aspl.htmlEncode(sDescription) & "</h3>"
		
		records=records & "<a name=""top""></a>"
		records=records & "<table style=""font-family:Arial"" border=""1"" cellpadding=""5"" cellspacing=""0"">"
		records=records & "<thead>"
		records=records & "<tr>"
		records=records & "<th>N°</th>"
		records=records & "<th>" & l("song") & "</th>"
		records=records & "<th>" & l("artist") & "</th>"
		records=records & "<th>" & l("comments") &"</th>"
		records=records & "<th>" & l("tuning") & "</th>"
		records=records & "<th>BPM</th>"		
		records=records & "</tr>"		
		records=records & "</thead>"
		records=records & "<tbody>"		
		
		for each song in songsCopy
			counter=counter+1	
			records=records & "<tr>"
			records=records & "<td>" & counter & "</td>"
			records=records & "<td><a href=""#songID" & counter & """>" & aspl.htmlEncode(songsCopy(song).sTitle) & "</a></td>"
			records=records & "<td>" & aspl.htmlEncode(songsCopy(song).sArtist) & "</td>"
			records=records & "<td>" & aspl.htmlEncode(songsCopy(song).sComments) & "</td>"
			records=records & "<td>" & aspl.htmlEncode(songsCopy(song).sTuning) & "</td>"
			records=records & "<td>" & aspl.htmlEncode(songsCopy(song).sBPM) & "</td>"
			records=records & "</tr>"
		next
		
		records=records & "</tbody></table>"
		
		records=records & "<div style=""page-break-after: always;""></div>"

		counter=0
		for each song in songsCopy		
		
			counter=counter+1	
			
			records=records & "<a name=""songID" & counter & """ alt="""" href=""#""></a>"						
			records=records & "<div>"
			records=records & "<h2>" & counter & ". " & aspl.htmlEncode(songsCopy(song).sTitle) &" (" & aspl.htmlEncode(songsCopy(song).sArtist)  & ")</h2>"	
						
			'################################### nav
			records=records & nav(counter,includeJS)
			'################################### end nav
			
			records=records & "<p style=""background-color:#F8D7DA;padding:10px;border-radius:6px"">"			
			
			records=records & aspl.htmlEncode(songsCopy(song).sComments) 
			
			if not aspl.isEmpty(songsCopy(song).sTuning) then
				records=records & "&nbsp;" & l("tuning") & ": <strong>" & aspl.htmlEncode(songsCopy(song).sTuning)  & "</strong>"
			end if
			
			if not aspl.isEmpty(songsCopy(song).sBPM) then
				records=records & "&nbsp;BPM: <strong>" & aspl.htmlEncode(songsCopy(song).sBPM)& "</strong>"
			end if
			
			records=records & "</p>"	
			
			'song files
			dim songfile,songfiles : set songfiles=songsCopy(song).files			
			
			if songfiles.count>0 then			
				
				dim images
				
				for each songfile in songfiles
				
					records=records & "<div style=""border-radius:6px;border:1px solid #CCC;padding:10px;text-align:center;float:left;width:130px;background-color:#F8F9FA;margin-top:1px;margin-right:10px"">"
									
					select case lcase(songfiles(songfile).sExt)
					
						case "jpg","jpeg","gif","png"
						
							records=records & "<a style=""font-size:13px;color:#000000;text-decoration:none;"" target=""_blank"" href=""" & songfiles(songfile).imageSrc(1600) & """><img alt=""" & aspl.htmlEncode(songfiles(songfile).sFilename) & """ src=""" & songfiles(songfile).imageSrc(110) & """ style=""border-radius:6px;width:100%"" /><br />"
						
						case else
						
							records=records & "<a style=""color:#000000;text-decoration:none;"" href=""" & directlink("song_filedownload.asp","&iId=" & songfile) & """>"
						
						
					end select				
					
					records=records & aspl.htmlEncode(songfiles(songfile).sFilename) & "." & aspl.htmlEncode(songfiles(songfile).sExt) & "</a></div>"
					
				next				
				
				records=records & "<div style=""clear:both""><br /></div>"
				
			end if			

			drawLyrics=br(aspl.htmlEncode(songsCopy(song).drawLyrics))
			
			if not aspl.isEmpty(drawLyrics) then
				records=records & "<div style=""border-radius:6px;background-color:#fffec8;padding:20px;font-size:16px;"">" & drawLyrics & "</div>"				
			end if			

			'######################################## nav
			records=records & nav(counter,includeJS)
			'######################################## end nav			
			
			if not aspl.isEmpty(songsCopy(song).sLyrics) then				
				records=records & "<a name=""songIDChords" & counter & """></a><pre style=""border-radius:6px;background-color:#F8F9FA;padding:20px;"">" & aspl.htmlEncode(songsCopy(song).sLyrics) & "</pre>"
			end if			
						
			records=records & "</div>"
			
		next
		
		set songsCopy=nothing
				
		dim cdomessage : set cdomessage=aspL.plugin("cdomessage")
		records=cdomessage.wrapInHTML(records,sName)
		set cdomessage=nothing
		
		records=replace(records,"<body>","<body style=""font-family:Arial;font-size:16px"">",1,-1,1)
		
		if includeJS then
			records=replace(records,"</head>","<script>" & vbcrlf & aspl.loadText(myApp.sPath & "/includes/scroll.js") & vbcrlf & "</script>" & vbcrlf & "</head>",1,-1,1)
		end if		
				
		html=records


	end function

	public sub mail
	
		dim cdomessage : set cdomessage=aspL.plugin("cdomessage")		
		cdomessage.receiveremail=user.sEmail
		cdomessage.subject=sName	
		cdomessage.body=html(false)
		cdomessage.send
		set cdomessage=nothing
	
	end sub
	

end class

class cls_playlists

	public list

	Private Sub Class_Initialize		
		
		Set list = aspL.dict
	
		dim sql : sql="select * from tblPlaylist where bDeleted=false and iUserID=" & user.iId & " order by sName"
		
		dim playlist, rs : set rs=dba.execute(sql)				
		
		while not rs.eof			
		
			set playlist=new cls_playlist : playlist.pick(aspl.convertNmbr(rs("iId")))
		
			list.add playlist.iId,playlist
			
			set playlist=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing			

	End Sub	
	
	
	
	Private Sub Class_Terminate
	
		Set list = nothing
		
	End Sub	
	

end class

%>