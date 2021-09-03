



	function randomNo() {
		 return Math.floor(Math.random()*9999999);
	}
	
	
	$.ajax({
		type:"POST",
		url: "{Variable:comodinArchivoAjax}",
		dataType: "html",
		data: "r=" + randomNo(),
		async: false,
		processData: false,
		success: function(output){ 
				  $('#{Variable:comodinNombreDiv}').html(output);},
							error: function(output) {
									$("#{Variable:comodinNombreDiv}").html(output);
				  },
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			alert("Error " + errorThrown);
		}				
	})
