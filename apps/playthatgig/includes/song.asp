<%
class cls_song

	Public iId, sTitle, sLyrics, sComments, iUserID, sArtist, sDuration, sBPM, sTuning, sChords, sTab, iLanguageID, dUpdatedTS, bDeleted, iSort
	
	
	Private Sub Class_Initialize		
		iId=0	
		bDeleted=false			
	End Sub	
	
	
	public function check
	
		check=true
		
		if aspl.isempty(sTitle) then
			aspl.addErr(l("titleismandatory"))
			check=false
		end if		
		
		'bestaat reeds? 
		
		dim rs,sql
		sql="select iId from tblSong "
		sql=sql & "where iUserID=" & user.iId & " and sTitle='" & aspl.sqli(aspl.textonly(sTitle)) & "' "
		sql=sql & "and sArtist='" & aspl.sqli(aspl.textonly(sArtist)) & "' "
		sql=sql & "and bDeleted=false and iId<>" & aspl.convertNmbr(iId)
		
		set rs=dba.execute(sql)
		
		if not rs.eof then
			aspl.addErr(l("thissongexistsalready"))
			check=false
		end if
		
	end function
			
	
	public function pick(id)	

		dim RS
		
		if aspl.isNumber(id) then
		
			dim sql : sql = "select * from tblSong where bDeleted=false and iUserID=" & user.iId & " and iId=" & id
			
			set RS = dba.execute(sql)
			
			if not rs.eof then
			
				iId					= rs("iId")
				sTitle				= rs("sTitle")
				sLyrics				= rs("sLyrics")
				sComments			= rs("sComments")
				iUserID				= rs("iUserID")
				sArtist				= rs("sArtist")
				sDuration			= rs("sDuration")
				sBPM				= rs("sBPM")
				sTuning				= rs("sTuning")
				sChords				= rs("sChords")
				sTab				= rs("sTab")
				iLanguageID			= rs("iLanguageID")
				dUpdatedTS			= rs("dUpdatedTS")
				bDeleted			= rs("bDeleted")			
	
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
			rs.Open "select * from tblSong where 1=2"
			rs.AddNew			
		else
			rs.Open "select * from tblSong where bDeleted=false and iUserID=" & user.iId & " and iId="& iId
		end if		
	
		rs("sTitle") 			= left(aspl.textonly(sTitle),255)	
		rs("sLyrics") 			= aspl.convertStr(sLyrics)
		rs("sComments") 		= aspl.convertStr(sComments)
		rs("iUserID") 			= user.iId
		rs("sArtist") 			= left(aspl.textonly(sArtist),255)
		rs("sDuration") 		= aspl.convertStr(sDuration)
		rs("sBPM") 				= sBPM
		rs("sTuning") 			= sTuning
		rs("sChords") 			= sChords
		rs("sTab") 				= sTab
		rs("iLanguageID") 		= aspl.convertNull(iLanguageID)
		rs("bDeleted") 			= bDeleted
		rs("dUpdatedTS") 		= now()
		
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))		
		
		rs.close
		
		Set rs = nothing		
		
	end function
	
	public function remove
	
		remove=false
		
		bDeleted=true : save()
		
		if iId<>0 then
		
			remove=true
			
			'in alle playlists verwijderen!
			dim rs : set rs=dba.execute("select iId, iPlaylistID from tblPlaylistSong where iSongID=" & iId)
			
			while not rs.eof
			
				dim playlist : set playlist=new cls_playlist
				playlist.pick(aspl.convertNmbr(rs("iPlaylistID")))
				playlist.deleteSong(aspl.convertNmbr(rs("iId")))
				set playlist=nothing
				
				rs.movenext
			
			wend 
			
			set rs=nothing
			
			
		end if
		
	end function
	
	public function canBeDeleted
	
		canBeDeleted=true
		
		if iId=0 then canBeDeleted=false
	
	end function

	
	public function drawLyrics	
		
		if not aspl.isEmpty(sLyrics) then
		
			dim line,i, arrL : arrL=split(sLyrics,vbcrlf)
			
			for i=lbound(arrL) to ubound(arrL)
			
				line=lcase(arrL(i))	
				line=replace(line,vbtab," ",1,-1,1)
				line=replace(line,"  "," ",1,-1,1)
				line=trim(line)	

				if instr(line,"page 4/")=0 and instr(line,"page 3/")=0 and instr(line,"page 2/")=0 and instr(line,"page 1/")=0 and instr(line,"----")=0 and instr(line,"    ")=0 and instr(line,"[chorus]")=0 and instr(line,"[intro]")=0 and instr(line,"[verse")=0 and instr(line,"[bridge]")=0 and instr(line,"[outro]")=0 and instr(line,"[interlude]")=0 and instr(line,"e|-")=0  and instr(line,"b|-")=0 and instr(line,"g|-")=0 and instr(line,"d|-")=0 and instr(line,"a|-")=0 then
					
					if line<>"dm7" and line<>"em7" and line<>"dsus4" and line<>"asus2" and line<>"gsus4" and line<>"b7" and line<>"a" and line<>"b" and line<>"c" and line<>"d" and line<>"e" and line<>"f" and line<>"g" and line<>"am" and line<>"bm" and line<>"cm" and line<>"dm" and line<>"em"  and line<>"fm"  and line<>"gm" and instr(line," b ")=0 and instr(line," c ")=0 and instr(line," d ")=0 and instr(line," e ")=0 and instr(line," f ")=0 and instr(line," g ")=0 and instr(line," bm ")=0 and instr(line," cm ")=0 and instr(line," dm ")=0 and instr(line," em ")=0 and instr(line," fm ")=0 and instr(line," gm ")=0 and instr(line," d7 ")=0 and instr(line," a7 ")=0 and instr(line," b7 ")=0 and instr(line," c7 ")=0  and instr(line," e7 ")=0  and instr(line," f7 ")=0  and instr(line," g7 ")=0 then

						drawLyrics=drawLyrics & trim(arrL(i)) & vbcrlf
					
					end if
					
				end if			
			
			next		
		
		end if		
		
		drawLyrics=replace(drawLyrics,vbcrlf & vbcrlf & vbcrlf,vbcrlf & vbcrlf,1,-1,1)
		drawLyrics=replace(drawLyrics,vbcrlf & vbcrlf & vbcrlf,vbcrlf & vbcrlf,1,-1,1)
		drawLyrics=replace(drawLyrics,vbcrlf & vbcrlf & vbcrlf,vbcrlf & vbcrlf,1,-1,1)
		
		drawLyrics=trim(drawLyrics)
		
		while left(drawLyrics,1)=vbcrlf 
			drawLyrics=right(drawLyrics,len(drawLyrics)-1)
		wend
		
		while right(drawLyrics,1)=vbcrlf 
			drawLyrics=left(drawLyrics,len(drawLyrics)-1)
		wend

	end function
	
	public function files
	
		dim songFile, sql
	
		set files=aspl.dict
		
		sql="select iId from tblSongFile "
		sql=sql & " where iSongID=" & iId & " order by sFileName"
		
		dim rs : set rs=dba.execute(sql)
		
		while not rs.eof
		
			set songFile=new cls_songFile
			songFile.pick(rs(0))
			files.add songFile.iId, songFile
			set songFile=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing
	
	
	end function

end class

class cls_songs

	public list

	Private Sub Class_Initialize		
		
		Set list = aspL.dict
	
		dim sql : sql="select * from tblSong where bDeleted=false and iUserID=" & user.iId & " order by sTitle asc"
		
		dim song, rs : set rs=dba.execute(sql)				
		
		while not rs.eof			
		
			set song=new cls_song
			
			song.iId		= aspl.convertNmbr(rs("iId"))
			song.sArtist	= aspl.convertStr(rs("sArtist"))
			song.sTitle		= aspl.convertStr(rs("sTitle"))
					
			list.add song.iId,song
			
			set song=nothing
		
			rs.movenext
			
		wend 
		
		set rs=nothing	
		
	End Sub	
	
end class

function songRS
	
	dim sql : sql="select tblSong.iId, tblSong.sTitle, tblSong.sArtist from "
	sql=sql & " tblSong where tblSong.bDeleted=false and tblSong.iUserID=" & user.iId & " order by sTitle asc"
	
	set songRS=dba.execute(sql)

end function

class cls_tuning

	public list

	Private Sub Class_Initialize		
		
		Set list = aspL.dict
		
		list.add "A","A"
		list.add "A#","A#"
		list.add "B","B"
		list.add "C","C"
		list.add "C#","C#"
		list.add "D","D"
		list.add "Eb","Eb"
		list.add "E","E"
		list.add "F","F"
		list.add "F#","F#"
		list.add "G","G"
		list.add "Ab","Ab"
		
		
	end sub


end class

class cls_bpm

	public list

	Private Sub Class_Initialize		
		
		Set list = aspL.dict
		
		dim i
		for i=20 to 250		
			list.add i,aspl.padLeft(i, 3, 0)
		next
		
		
	end sub


end class


%>