

	var pzsDataPost = "{Variable:sParametrosSerializados}&r=" + Math.floor(Math.random()*9999999);
	
	$.ajax({
		type:"POST",
       // beforeSubmit:  alert(pzsDataPost),
		url: "{Variable:comodinArchivoAjax}",
		dataType: "html",
        //dataType: "application/x-www-form-urlencoded",
		data: pzsDataPost,
		async: false,
		processData: false,
		success: function(output){ 
			$('#{Variable:comodinNombreDiv}').html(output);},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			$.jGrowl("Ocurrio un error grave en pz, por favor avise al administrador ", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
		}				
	})
