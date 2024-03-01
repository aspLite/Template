<%
class cls_songFile

	public iId, sFilename, iFilesize, iSongID, sExt
	
	private sub class_initialize
		iId=0				
	end sub

	public function pick(id)
	
		if aspL.convertNmbr(id)<>0 then	
			
			dim rs : set rs=dba.rsOpen("select * from tblSongFile where iId=" & id)
			
			if not rs.eof then
			
				iId				=	rs("iId")
				sFilename		=	rs("sFilename")	
				sExt			=	rs("sExt")
				iFilesize		=	rs("iFilesize")
				iSongID			=	rs("iSongID")			
			
			end if
					
			set rs=nothing
		
		end if
	
	end function
	
	private function check
	
		check=true				
	
	end function
	
	public function save		
	
		if check then
		
			dim rs : set rs=dba.rs 

			if iId<>0 then
				rs.Open "select * from tblSongFile where iId="& aspl.convertNmbr(iId)				
			else
				rs.Open "select * from tblSongFile where 1=2"				
				rs.AddNew							
			end if		
			
			rs("sFilename")			= sFilename
			rs("sExt")				= sExt
			rs("iFilesize")			= iFilesize
			rs("iSongID")			= aspl.convertNmbr(iSongID)			
			
			rs.update()
			
			iId = aspl.convertNmbr(rs("iId"))
			
			rs.close		
			
			set rs=nothing
			
			save=true				
		
		else
		
			save=false
		
		end if
	
	end function
	
	
	public function remove
	
		remove=false	

		on error resume next
		
		if iId<>0 then			
			
			'first remove file$
			aspl.fso.deletefile(server.mappath(myApp.sPath & "/uploads") & "\" & iId & ".resx")
		
			set rs=dba.execute("delete from tblSongFile where iId="& iId)
			set rs=nothing
			
			remove=true
			
		end if
		
		on error goto 0
		
	end function
	
	public function canBeDeleted
	
		canBeDeleted=true
	
		if iId=0 then canBeDeleted=false
	
	end function
	
	public function song
	
		set song=new cls_song
		song.pick(iSongID)		
	
	end function
	
	public property get downloadLink
	
		downloadLink="location.assign('" & directlink("song_filedownload.asp","&iId=" & iId)& "');"
		
	end property

end class
%>