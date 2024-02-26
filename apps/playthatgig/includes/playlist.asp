<%
class cls_playlist

	Public iId, sName, sDescription, iUserID, dUpdatedTS, bDeleted
	
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
		else
			rs.Open "select * from tblPlaylist where bDeleted=false and iUserID=" & user.iId & " and iId="& iId
		end if
		
		rs("sName")					= left(aspl.convertStr(aspl.removeTabs(sName)),255)		
		rs("sDescription")			= aspl.convertStr(aspl.removeTabs(sDescription))
		rs("iUserID")				= aspl.convertNull(user.iId)
		rs("bDeleted")				= aspl.convertBool(bDeleted)
		rs("dUpdatedTS")			= now()	
				
		rs.Update 
		
		iId = aspl.convertNmbr(rs("iId"))		
		
		rs.close
		
		Set rs = nothing		
		
	end function
	
	
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
	
		
	
	public function setSort(source, target)	

		dim rs : set rs=dba.execute("select iSort from tblPlaylistSong where iId=" & target)
		dim rsOld : set rsOld=dba.execute("select iSort from tblPlaylistSong where iId=" & source)
		
		dim oldR : oldR=rsOld(0)
		dim newR : newR=rs(0)

		if oldR>newR then
			sql="update tblPlaylistSong set iSort=iSort+1 where "
			sql=sql&" iSort>=" & newR & " and iSort<" & oldR & " and iPlayListID="& iId
		else
			sql="update tblPlaylistSong set iSort=iSort-1 where "
			sql=sql&" iSort>" & oldR & " and iSort<=" & newR & " and iPlayListID="& iId
		end if
		
		dba.execute(sql)

		dba.execute("update tblPlaylistSong set iSort=" & newR & " where iId=" & source)
	
	end function
	
	
	public function canBeDeleted
	
		canBeDeleted=true
		
		if iId=0 then canBeDeleted=false
	
	end function	
	

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