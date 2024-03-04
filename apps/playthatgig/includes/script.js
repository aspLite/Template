		
$( function() {
	$( "#sortable" ).sortable({
	  revert: true,	 
	  forceFallback: true,
	  update: function(event,ui){	  
		$('#iDivID').val($(this).sortable('toArray', { attribute: 'id' }));		
		$('#[FORMID]').submit();
		},
	  start: function(event, ui) {
        $(this).height('auto');
		$(ui.item).css('background-color','#FFDC7C');
		}
	});
	$( "#sortable" ).droppable({
	 drop: function(event, ui) {			
		}
	});
	$( "#draggable" ).draggable({
	  connectToSortable: "#sortable",
	  helper: "clone",
	  revert: "invalid"
	});
	$( "ul, li" ).disableSelection();
  } );