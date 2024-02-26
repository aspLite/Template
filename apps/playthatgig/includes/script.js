  function allowDrop(ev) {
        ev.preventDefault();
    }

    function drag(ev) {
        ev.dataTransfer.setData("text", ev.target.id);		
    }

    function drop(ev) {
        ev.preventDefault();
        var data = ev.dataTransfer.getData("text");	

        thisdiv = ev.target;
        $(document.getElementById(data)).insertBefore(thisdiv);
	
		$('#iTargetID').val(ev.target.id);
		$('#iDivID').val(data);
		$('#[FORMID]').submit();
		return false;		
		
    }