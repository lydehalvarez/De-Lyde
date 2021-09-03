<script language="JavaScript">
<!--

//

//	$(":input").blur(function() {
//	  if($(this).val() == "") {
//	   alert("Please enter some text!");
//	  }
//	});
	
	//$("div#Contenedor").load("/widgets/Login/Login.asp");
//$("#Entrar").click(alert("clic a entrar"));
	 //$("#Entrar").click(BuscaUsuario); 

//
//$(document).ready(function(){
//	$container = $("#container").notify();
//});

//function create( template, vars, opts ){
//	return $container.notify("create", template, vars, opts);
//}
var randomNo = Math.floor(Math.random()*9999999);

function CambiaVentana(NoVentana) {
	//alert("la ventana a cargar es " + NoVentana);
	document.frmDatos.VentanaIndex.value = NoVentana;
	document.frmDatos.TabIndex.value = -1
	document.frmDatos.submit();	
}

function BuscaUsuario(dato){
	var randomNo = Math.floor(Math.random()*9999999);
	
	$.ajax({
		type:"POST",
		url: "/widgets/Login/Valida2.asp",
		//dataType: "application/x-www-form-urlencoded",
		dataType: "html",
		data: "Usuario=" + $("#Usuario").val() + "&Clave=" + $("#Clave").val() + "&r=" + randomNo,
		async: false,
		processData: false,
		beforeSend: function(){ 
							if ( $("#Usuario").val() == "") { 
								alert("escriba su usuario");
								$("#Usuario").focus();
								return false
							}
							if ( $("#Clave").val() == "") { 
								alert("escriba su contraseña");
								$("#Clave").focus();
								return false
							}
						},
		success: function(msg){ 
				   // $('<div id="Resultado" class="row-box"></div>').html("Loading Content:  ...").appendTo('body').fadeIn();
				  // $('#Resultado').html(msg);
				  // alert(msg);
					if (msg == "Bienvenido") {
						CambiaVentana(1);
					} else if (msg == "Cuenta Vencida") {
							alert("Comuniquese con el administrador");
						} else  {
							alert("Verifique su usuario o su clave");
					}
				  },
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			//alert(XMLHttpRequest);
			//alert(textStatus);
			alert("Error " + errorThrown);
		}
		//success: function(output) {
//                                $("#output").html(output);
//                        },
//                        error: function(output) {
//                                $("#output").html(output);
//                        }
						
	})
}

alert("ya me cargo");
-->
</script>