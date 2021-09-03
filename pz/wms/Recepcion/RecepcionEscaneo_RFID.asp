<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var Tarea = Parametro("Tarea", -1)
    var Id_Usuario = Parametro("ID_Usuario",-1)  
	var Cli_ID = Parametro("Cli_ID",-1)  
	var Ser_Serie = Parametro("Ser_Serie",1)
	//var Pt_ID = Parametro("Pt_ID",-1)
	var IR_ID = Parametro("IR_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var Pt_SKU = Parametro("Pt_SKU","")
	var Pt_LPN = Parametro("Pt_LPN","0")
	var Articulos =  parseInt(Parametro("Articulos",1))
	var Rollo =  parseInt(Parametro("Rolo",-1))
	var Cantidad_Rollo =  parseInt(Parametro("Cantidad_MB",-1))
	var Cantidad_Movimiento =  parseInt(Parametro("Cantidad_Movimiento",-1))
	var CliEnt_ID = Parametro("CliEnt_ID", -1)
	var error = Parametro("error", "")
	var Pal = 1
	var inputMB = ""
	var Pt_ID = -1
	if(Pt_LPN != "0"){
		var sSQL  = "SELECT Pro_ID FROM Producto_Movimiento"
      		  sSQL += " WHERE ProM_ID = " + ProM_ID
		var rsMovimiento = AbreTabla(sSQL,1,0) 
		Pro_ID = rsMovimiento.Fields.Item("Pro_ID").Value
	}
	
	var sSQLTr  = "SELECT TPro_ID, Pro_Nombre FROM Producto"
        sSQLTr += " WHERE Pro_ID = " + Pro_ID

		var rsTPro = AbreTabla(sSQLTr,1,0) 
			  Producto = rsMovimiento.Fields.Item("Pro_Nombre").Value


%>
 
<div class="form-horizontal" id="frmDatos">
    <div class="row">
        <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-content">
                        <div class="form-group">
                            <legend class="control-label col-md-12" style="text-align: left;"><h1>Armado etiquetas EPC:&nbsp;<%=Producto%></h1></legend>
                        </div>
                    
                    <div style="overflow-y:scroll; height:655px;">
                    	<div class="table-responsive" id="dvTablaInfo"></div>
                        
                    </div>
                  	<div class="table-responsive" id="dvTablaInfo2"></div>
                        
                    </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<input type="hidden" value="<%=Cli_ID%>" class="agenda" id="Cli_ID"/>
<input type="hidden" value="<%=Pro_ID%>" class="agenda" id="Pro_ID"/>
<input type="hidden" value="<%=CliEnt_ID%>" class="agenda" id="CliEnt_ID"/>
<input type="hidden" value="<%=IR_ID%>" class="agenda" id="IR_ID"/>
<input type="hidden" value="<%=ProM_ID%>" class="agenda" id="ProM_ID"/>
<input type="hidden" value="<%=Id_Usuario%>" class="agenda" id="Id_Usuario"/>

<%
var urlBase = "/pz/wms/Almacen/"
%>

<script type="text/javascript" src="<%= urlBase %>Catalogo/js/Catalogo.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Area/js/Ubicacion_Area.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Rack/js/Ubicacion_Rack.js"></script>
<script type="text/javascript">


$(document).ready(function(e) {

	FunctionRecepcion.GetTabla()
	
		});

//$("#frmDatos").on("keydown", ".Serie", function(e){
//	  if (e.which == 13) {
//        e.preventDefault();
//		FunctionRecepcion.InsertSerie();
//	}
//});
/*
$("#frmDatos").on("click", "#BtnMB", function(e){
       // e.preventDefault();
		FunctionMB.InsertMB();
});
*/
//$("#frmDatos").on("click", ".BtnUbic", function(e){
//        e.preventDefault();
//		FunctionUbic.InsertUbic();
//});

var FunctionRecepcion = {
	GetTabla:function(){
	
		$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
		{ProM_ID:<%=ProM_ID%>,
		Tarea:1
		}
		,function(data){
		$('#dvTablaInfo').html(data)
	},
	ReanudarRollo:function(){
			$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",{
			Tarea:7
			,MB:$('#cboRol').val()
			,ProM_ID:$('#ProM_ID').val()
		}, 
		function(data){
					$('#dvTablaInfo2').html(data)

		var suma = parseInt($('#EscaneadasRolo').text())
				$('#escaneadasValor').val(suma)
				$('#escaneadas').val(suma)
				$('#escaneadasValor').html(suma)
				$('#escaneadas').html(suma)
				$('#RolValor').val($('#cboRollo').val())
				$('#RolActual').val($('#cboRollo').val())
				$('#RolValor').html($('#cboRollo').val())
				$('#RolActual').html($('#cboRollo').val())
				$('#Serie').css('display','block')


		});
	},
		MostrarUbicaciones:function(){
		$('#Pt_Ubicacion').css('display','block')
		$('#BtnUbicM').css('display','block')
		},
	InsertSerie:function(event){
		
		var keyNum = event.which || event.keyCode;
		  
		if(keyNum== 13 ){
		
 			var bien = true;
			var serie = $('.Serie').val()
			$('.Serie').val("")
			var alfanum = $('.Alfanum').val()
	
 			var letra;
			var largo = serie.length
 			for (var i=0; i<largo; i++) {
			  letra=serie.charAt(i).toLowerCase()
			  		if( alfanum == 1){
					bien=false;                              
				 var validos = "0123456789";
			    if (validos.indexOf(letra) == -1){
				  bien=true;
					break;
				  console.log(bien)
				}
			}else{
				 var validos = "0123456789";
			     if (validos.indexOf(letra) == -1){
				  bien=false;
				}
			}
			 }
			  console.log(bien)

			  if (!bien) {
				  Tipo="error"
			  alert("Error en serie " +serie+ ". Caracteres no aceptados");
				$('.Serie').val("")
			    $('.Serie').focus();
			  }else{
			$.ajax({
				method: "POST",
				url: "/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp?",
				data: {
					ProM_ID:<%=ProM_ID%>,
					Tarea:2,
					Pro_ID:<%=Pro_ID%>,
					Rollo:$('.RolActual').val(),
					Serie:serie,
				
				},
				cache: false,
					success: function (data) {
					var response = JSON.parse(data)
					var Tipo = ""
					
					if(response.result == 1){
						Tipo = "success"
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						$('#Serie').focus()	
					}
					if(response.result == 2){
						Tipo = "success"
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						$('.Serie').hide();
						$('#inputRol').css('display','block')
						$('#BtnRol').css('display','block')
						$('#inputRol').val("")
						$("#divRollo").html('<p style="color:#66CC99;"><font size = 10>' + response.message + '. <br/> Rollo escaneado.</font></p>')
					}
					if(response.result == 3){
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						Tipo = "success"
						$('.Serie').hide();
						$('#inputRol').hide();
						$('#BtnRol').hide();
					}
						if(response.result == 4){
						Tipo = "error"
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						$('.Serie').hide();
						//$('#inputMB').css('display','block')
						//$('#BtnMB').css('display','block')
						$('#inputRol').val("")
						$('#inputRol').focus()
						$("#divRollo").html('<p style="color:red;"><font size = 10 >' + response.message + '. <br/>Rollo escaneado.</font></p>')
					}
						if(response.result == 5){
						Tipo = "error"
						$("#divRollo").html('<p style="color:red;"><font size = 10 >' + response.message + '</font></p>')

					}
					if(response.result == 0){
						Tipo = "error"
					}
					$('.Serie').val("")
					Avisa(Tipo,"Aviso",response.message);
					
		
				}
			
			});
	   	  }
		}
	},
				

}
	var FunctionRollo = {
			InsertRollo:function(){
				
					$.ajax({
    method: "POST",
    url: "/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp?",
    data: {ProM_ID:<%=ProM_ID%>,
		Tarea:3,
		MB:$('#MBActual').val(),
		Cantidad_Rollo:$('#inputRollo').val(), 
		IDUsuario:$('#IDUsuario').val()
		},
    cache: false,
    success: function (data) {
			var response = JSON.parse(data)
			var Tipo = ""
			if(response.result == 1){
				Tipo = "success"
				var Rollo = response.Rollo 
				//parseInt($("#MBActual").val()) +1
				var suma = 0
				$("#escaneadasValor").html(suma)
				$("#escaneadas").val(suma)
				$("#RolValor").html(Rollo)
				$("#divRollo").html("")
				$("#RolActual").val(Rollo)		
				$('.Serie').val("")
				$('#Serie').css('display','block')
				$('.inputRol').hide();
				$('.BtnRol').hide();
				$('#Serie').focus()
			}
		
			 if(response.result == 0){
				Tipo = "error"
			}
				
			
			Avisa(Tipo,"Aviso",response.message);
			
	}
		});	
		
		
	//	$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
//		{Pt_ID:<%/*%><%=Pt_ID%><%*/%>,
//		Tarea:3,
//		MB:$('.MBActual').val(),
//		Cantidad_MB:$('.inputMB').val()
//		}
//			,function(data){
//		var response = JSON.parse(data)
//			var Tipo = ""
//			if(response.result == 1){
//				Tipo = "success"
//				var MB = parseInt($("#MBActual").val()) +1
//				$("#MBValor").html(MB)
//				$("#MBActual").val(MB)		
//				$('.Serie').val("")
//				$('#Serie').css('display','block')
//				$('.inputMB').hide();
//				$('.BtnMB').hide();
//			}
//		
//			 if(response.result == 0){
//				Tipo = "error"
//			}
//				
//			
//			Avisa(Tipo,"Aviso",response.message);
//			
//		});				
	},

		}	
		

				var FunctionUbic = {
					InsertUbic:function(){
					$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
					{ProM_ID:$("#ProM_ID").val(),
					Tarea:4,
					IDUsuario:<%=Id_Usuario%>					}
					,	 function(data){
						$('.Serie').hide();
						$('#inputRol').hide();
						$('#BtnRol').hide();
					var folio = $("#ProM_ID").val()
					var cliid = $("#Cli_ID").val()
					var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?ProM_ID="+ folio+"&Tarea=1");
					
					});				
					},
					InsertUbicManual:function(){
					$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
					{ProM_ID:$("#ProM_ID").val(),
					Tarea:6,
					IDUsuario:<%=Id_Usuario%>,
				    Pt_Ubicacion:$("#lblUbiNombre").text()			
					}
					,	 function(data){
						$('.Serie').hide();
						$('#inputRol').hide();
						$('#BtnRol').hide();
					var folio = $("#ProM_ID").val()
					var cliid = $("#Cli_ID").val()
					var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?ProM_ID="+ folio+"&Tarea=1");
					
					});				
					}
					}	
					

</script>            