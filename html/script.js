

	var checked=false;

	function loadQS(qs) {
		aspAjax('GET',aspLiteAjaxHandler,qs,aspForm)
	};

	function load(event,target,addQS) {	
		//$('#' + target).html(aspLiteSpinner);
		aspAjax('GET',aspLiteAjaxHandler,'asplEvent=' + event + addQS + '&asplTarget=' + target,aspForm)
	};
	
	function loadID(event,target,iId) {	
		//$('#' + target).html(aspLiteSpinner);
		aspAjax('GET',aspLiteAjaxHandler,'iId=' + iId + '&asplEvent=' + event + '&asplTarget=' + target,aspForm)
	};
	
	function modalAspForm (event,qs,qs2) {
		$('#crmModal').modal({backdrop: 'static',keyboard: false}); //beletten dat de modal per ongeluk sluit
		$('#crmModal').modal('show'); //modalwindow alvast openen
		//$('#modalform').html(aspLiteSpinner); //modalwindow initialiseren met wachtend rondje
		aspAjax ("post",aspLiteAjaxHandler,"iId=" + qs + "&asplTarget=modalform" + qs2 + "&asplEvent=" + event,successModalAspForm)
	};	
	
	function modalAspFormXL (event,qs,qs2) {
			$('#crmModalXL').modal({backdrop: 'static',keyboard: false}); //beletten dat de modal per ongeluk sluit
			$('#crmModalXL').modal('show'); //modalwindow alvast openen
			//$('#modalformXL').html(aspLiteSpinner); //modalwindow initialiseren met wachtend rondje
			aspAjax ("post",aspLiteAjaxHandler,"iId=" + qs + "&asplTarget=modalformXL" + qs2 + "&asplEvent=" + event,successModalAspForm)
		};
		
	function modalAspFormFM (event,qs,qs2) {
			$('#crmModalFM').modal({backdrop: 'static',keyboard: false}); //beletten dat de modal per ongeluk sluit
			$('#crmModalFM').modal('show'); //modalwindow alvast openen
			//$('#modalformFM').html(aspLiteSpinner); //modalwindow initialiseren met wachtend rondje
			aspAjax ("post",aspLiteAjaxHandler,"iId=" + qs + "&asplTarget=modalformFM" + qs2 + "&asplEvent=" + event,successModalAspForm)
		};

	function successModalAspForm(data) {		
		aspForm(data)			
	};	
	
	//as we only use 1 modal form, we have to make sure to empty the 
	//title and the body upon close, otherwise aspLite forms may
	//act a little sticky
	$('#crmModal').on('hidden.bs.modal', function () {
		$('#crmModalLabel').html('');
		$('#modalform').html('');	
		checked=false;		
	});	
	
	function drawSimpleDT(id){
		$('#' + id ).DataTable( {
			info:false,
			responsive:true,			
			paging:false			
			} 
		);
	}	
	
	//export to Excel
	
	var buttonID;
	
	function createXLS (butID,buttonEvent,buttonHTML,options,qs) {
		buttonID=butID;
		button=buttonHTML;
		$('#' + buttonID +'').html('Even geduld <i class="fa fa-circle-o-notch fa-spin"></i>')
		$('#' + buttonID +'').removeClass('btn-success')
		$('#' + buttonID +'').addClass('btn-warning')
		aspAjax ("get",aspLiteAjaxHandler,"asplEvent=" + buttonEvent + qs + "&options=" + options,createFile)	
	}

	function createFile(data) {		

		var wb = XLSX.utils.book_new(), ws = XLSX.utils.json_to_sheet(data.aspl,{raw: true})
		XLSX.utils.book_append_sheet(wb, ws, 'Blad')
		XLSX.writeFile(wb, 'export.xlsx', {type: 'file'})
		
		$('#' + buttonID + '').removeClass('btn-warning')
		$('#' + buttonID + '').addClass('btn-success')
		$('#' + buttonID + '').html('Klaar!')
			
		setTimeout(function() {
			$('#' + buttonID + '').html(button)
		}, 2000);
	}	
	
	function checkboxes() {
	
		if(!checked) {
			$('input:checkbox').prop('checked', true);
			checked=true;
			}
			else
			{
			$('input:checkbox').prop('checked', false);
			checked=false;
			}		
	}
	
	
	function delay(callback, ms) {
	  var timer = 0;
	  return function() {
		var context = this, args = arguments;
		clearTimeout(timer);
		timer = setTimeout(function () {
		  callback.apply(context, args);
		}, ms || 0);
	  };
	}
	
	
	function PrintElem(elem,title,subtitle) {
	
		var mywindow = window.open('', 'PRINT', 'height=500,width=750');

		mywindow.document.write('<!doctype html><html lang="nl"><head><style>body {font-size:16pt} .no-print {display:none}</style>');
		mywindow.document.write('<meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">');
		mywindow.document.write('<title>' + document.title  + '</title>');
		mywindow.document.write('</head><body>');
		mywindow.document.write('<h3>' + title + '</h3>');
		mywindow.document.write('<h4>' + subtitle + '</h4>');
		mywindow.document.write(document.getElementById(elem).innerHTML);
		mywindow.document.write('</body></html>');
		
		mywindow.document.close(); // necessary for IE >= 10
		mywindow.focus(); // necessary for IE >= 10*/

		mywindow.print();
		mywindow.close();

		return true;
	}
		
	function downloadPDF(id,butID) {
	
		$('#' + butID).html("<i class='fa fa-circle-o-notch fa-spin'></i> PDF");
		
		$.ajax({
			url: '/?asplEvent=topdf',
			method: 'POST',
			data: 'html=' + encodeURIComponent(document.getElementById(id).innerHTML),
			xhrFields: {
				responseType: 'blob'
			},
			success: function (data) {
				var a = document.createElement('a');
				var url = window.URL.createObjectURL(data);
				a.href = url;
				a.download = 'export.pdf';
				document.body.append(a);
				a.click();
				a.remove();
				window.URL.revokeObjectURL(url);
				$('#' + butID).html("PDF");
				}
			});
		}
	
	function downloadAsHTML(title,id,butID) {
	
		var origB=document.getElementById(butID).innerHTML;
			
		$('#' + butID).html('<i class="fa fa-circle-o-notch fa-spin"></i> ' + origB);
		
		$.ajax({
			url: '/?asplEvent=tofile',
			method: 'POST',
			data: 'title=' + encodeURIComponent(title) + '&html=' + encodeURIComponent(document.getElementById(id).innerHTML),
			dataType: 'html',
			success: function (data) {
				
				$('#' + butID).html(origB);			
				
				//werkt ook!!!! var blob = new Blob([document.getElementById(id).innerHTML],{type : "text/plain;charset=utf-8"});
				var blob = new Blob([data],{type : "text/plain;charset=utf-8"});
			
				var a = document.createElement('a');
				var url = window.URL.createObjectURL(blob);
				a.href = url;
				a.download = 'export.htm';
				document.body.append(a);
				a.click();
				a.remove();
				window.URL.revokeObjectURL(url);
				
				}
			});
		};	
	