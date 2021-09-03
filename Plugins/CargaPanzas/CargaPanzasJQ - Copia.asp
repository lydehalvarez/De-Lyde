
	function randomNo() {
		 return Math.floor(Math.random()*9999999);
	}
	
	
	$.ajax({
		type:"POST",
		url: "{Variable:sTmpComodin04}",
		//dataType: "application/x-www-form-urlencoded",
		dataType: "html",
		data: "r=" + randomNo(),
		async: false,
		processData: false,
//		beforeSend: function(){ 
				   // $('<div id="Resultado" class="row-box"></div>').html("Loading Content:  ...").appendTo('body').fadeIn();
//							if ( $("#Usuario").val() == "") { 
//								alert("escriba su usuario");
//								$("#Usuario").focus();
//								return false
//							}
//							if ( $("#Clave").val() == "") { 
//								alert("escriba su contraseña");
//								$("#Clave").focus();
//								return false
//							}
//						},
		success: function(output){ 
				  $('#{Variable:sTmpComodin05}').html(output);},
							error: function(output) {
									$("#{Variable:sTmpComodin05}").html(output);
				  // alert(msg);
				  },
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			//alert(XMLHttpRequest);
			//alert(textStatus);
			alert("Error " + errorThrown);
		}				
	})
