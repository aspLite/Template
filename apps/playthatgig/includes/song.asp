<%
class cls_song

	Public iId, sTitle, sLyrics, sComments, iUserID, sArtist, sDuration, sBPM, sTuning, sChords, sTab, iLanguageID, dUpdatedTS, bDeleted
	
	
	Private Sub Class_Initialize		
		iId=0	
		bDeleted=false			
	End Sub	
	
	
	public function check
	
		check=true
		
		if aspl.isempty(sTitle) then
			aspl.addErr(l("nameismandatory"))
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
	
		rs("sTitle") 			= left(aspl.convertStr(aspl.removeTabs(sTitle)),255)	
		rs("sLyrics") 			= aspl.convertStr(sLyrics)
		rs("sComments") 		= aspl.convertStr(sComments)
		rs("iUserID") 			= user.iId
		rs("sArtist") 			= left(aspl.convertStr(aspl.removeTabs(sArtist)),255)
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
		end if
		
	end function
	
	public function canBeDeleted
	
		canBeDeleted=true
		
		if iId=0 then canBeDeleted=false
	
	end function	

end class

class cls_songs

	public list

	Private Sub Class_Initialize		
		
		Set list = aspL.dict
	
		dim sql : sql="select * from tblSong where bDeleted=false and iUserID=" & user.iId & " order by sTitle asc"
		
		dim song, rs : set rs=dba.execute(sql)				
		
		while not rs.eof			
		
			set song=new cls_song : song.pick(aspl.convertNmbr(rs("iId")))
		
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