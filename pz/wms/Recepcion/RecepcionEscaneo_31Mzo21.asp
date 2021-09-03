<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var Tarea = Parametro("Tarea", -1)
    var Id_Usuario = Parametro("ID_Usuario",-1)  
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)  
	var Cli_ID = Parametro("Cli_ID",-1)  
	var Ser_Serie = Parametro("Ser_Serie",1)
	//var Pt_ID = Parametro("Pt_ID",-1)
	var IR_ID = Parametro("IR_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var Pt_SKU = Parametro("Pt_SKU","")
	var Pt_LPN = Parametro("Pt_LPN","0")
	var Articulos =  parseInt(Parametro("Articulos",1))
	var MB =  parseInt(Parametro("MB",-1))
	var Pallet =  parseInt(Parametro("Pallet",-1))
	var Cantidad_MB =  parseInt(Parametro("Cantidad_MB",-1))
	var Cantidad_Pallet =  parseInt(Parametro("Cantidad_Pallet",-1))
	var CliEnt_ID = Parametro("CliEnt_ID", -1)
	var error = Parametro("error", "")
	var Pal = 1
	var inputMB = ""
	var Pt_ID = -1
	if(Pt_LPN != "0"){
		var sSQL  = "SELECT Pt_ID, Pro_ID FROM Recepcion_Pallet"
      		  sSQL += " WHERE Pt_LPN = '" + Pt_LPN +"'"

		var rsPallet = AbreTabla(sSQL,1,0) 
		Pt_ID = rsPallet.Fields.Item("Pt_ID").Value
		Pro_ID = rsPallet.Fields.Item("Pro_ID").Value
	}
	
	var sSQLTr  = "SELECT TPro_ID FROM Producto"
        sSQLTr += " WHERE Pro_ID = " + Pro_ID

		var rsTPro = AbreTabla(sSQLTr,1,0) 
		
		if(CliOC_ID > -1){
	var sSQL = "SELECT CliOC_Folio FROM Cliente_OrdenCompra WHERE  Cli_ID = "+Cli_ID+" AND CliOC_ID = "+CliOC_ID
   var rsArt = AbreTabla(sSQL,1,0)
	var Folio =  rsArt.Fields.Item("CliOC_Folio").Value
	}if(OC_ID > -1){
		var sSQL = "SELECT OC_Folio FROM Proveedor_OrdenCompra WHERE Prov_ID = "+Prov_ID+" AND OC_ID = "+OC_ID
   var rsArt = AbreTabla(sSQL,1,0)
	var Folio =  rsArt.Fields.Item("OC_Folio").Value

	}
		   
%>
 
<div class="form-horizontal" id="frmDatos">
    <div class="row">
        <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-content">
                        <div class="form-group">
                            <legend class="control-label col-md-12" style="text-align: left;"><h1>Folio:&nbsp;<%=Folio%></h1></legend>
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
<input type="hidden" value="<%=Folio%>" class="agenda" id="Folio"/>
<input type="hidden" value="<%=CliOC_ID%>" class="agenda" id="CliOC_ID"/>
<input type="hidden" value="<%=OC_ID%>" class="agenda" id="OC_ID"/>
<input type="hidden" value="<%=Prov_ID%>" class="agenda" id="Prov_ID"/>
<input type="hidden" value="<%=TA_ID%>" class="agenda" id="TA_ID"/>
<input type="hidden" value="<%=Cli_ID%>" class="agenda" id="Cli_ID"/>
<input type="hidden" value="<%=Pro_ID%>" class="agenda" id="Pro_ID"/>
<input type="hidden" value="<%=CliEnt_ID%>" class="agenda" id="CliEnt_ID"/>
<input type="hidden" value="<%=IR_ID%>" class="agenda" id="IR_ID"/>
<input type="hidden" value="<%=Pt_LPN%>" class="agenda" id="Pt_LPN"/>
<input type="hidden" value="<%=Pt_ID%>" class="agenda" id="Pt_ID"/>
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
		{Pt_ID:<%=Pt_ID%>,
		Pallet:<%=Pallet%>,
		Tarea:1
		}
		,function(data){
		$('#dvTablaInfo').html(data)
		if($("#Pt_LPN").val() != "0"){
		$("#inputLPN").hide()
		$('#inputMB').css('display','block')
		$('#BtnMB').css('display','block')
		
		}
		$("#inputLPN").val("")
		});				
	},
	ReanudarMB:function(){
			$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",{
			Tarea:7
			,MB:$('#cboMB').val()
			,Pt_ID:$('#Pt_ID').val()
		}, 
		function(data){
					$('#dvTablaInfo2').html(data)

		var suma = parseInt($('#EscaneadasMB').text())
				$('#escaneadasValor').val(suma)
				$('#escaneadas').val(suma)
				$('#escaneadasValor').html(suma)
				$('#escaneadas').html(suma)
				$('#MBValor').val($('#cboMB').val())
				$('#MBActual').val($('#cboMB').val())
				$('#MBValor').html($('#cboMB').val())
				$('#MBActual').html($('#cboMB').val())
				$('#Serie').css('display','block')
				$('#Serie3D').css('display','block')


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
					Pt_ID:<%=Pt_ID%>,
					Tarea:2,
					Pro_ID:<%=Pro_ID%>,
					CliEnt_ID:<%=CliEnt_ID%>,
					Pallet:<%=Pallet%>,
					MB:$('.MBActual').val(),
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
						$('#inputMBSerie').css('display','block')
						$('#inputMB').hide();
						$('#BtnMB').hide();
						//$('#inputMB').css('display','block')
						//$('#BtnMB').css('display','block')
						$('#inputMB').val("")
						$('#inputMBSerie').focus()
						$("#divMB").html('<p style="color:#66CC99;"><font size = 10>' + response.message + '. <br/> Escanea la etiqueta del masterbox.</font></p>')
					}
					if(response.result == 3){
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						Tipo = "success"
						$('.Serie').hide();
						$('#inputMB').hide();
						$('#BtnMB').hide();
						$('#inputMBSerie').css('display','block')
					}
						if(response.result == 4){
						Tipo = "error"
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						$('.Serie').hide();
						$('#inputMBSerie').css('display','block')
						//$('#inputMB').css('display','block')
						//$('#BtnMB').css('display','block')
						$('#inputMB').val("")
						$('#inputMB').focus()
						$("#divMB").html('<p style="color:red;"><font size = 10 >' + response.message + '. <br/> Escanea la etiqueta del masterbox.</font></p>')
					}
						if(response.result == 5){
						Tipo = "error"
						$("#divMB").html('<p style="color:red;"><font size = 10 >' + response.message + '</font></p>')

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
	InsertSerie3D:function(event){
		
		var keyNum = event.which || event.keyCode;
		  
		if(keyNum== 13 ){
 			var bien = true;
			var serie3D = $('.Serie3D').val()
			var serie1 = serie3D.slice(0,15)
			var serie2 = serie3D.slice(16,31)
			var serie3 = serie3D.slice(32,47)
			var serie4 = serie3D.slice(48,63)
			var serie5 = serie3D.slice(64,79)
			var serie6 = serie3D.slice(80,95)
			var serie7 = serie3D.slice(96,111)
			var serie8 = serie3D.slice(112,127)
			var serie9 = serie3D.slice(128,143)
			var serie10 = serie3D.slice(144,159)
			
//			var alfanum = $('.Alfanum').val()
//	
// 			var letra;
//			var largo = serie.length
// 			for (var i=0; i<largo; i++) {
//			  letra=serie.charAt(i).toLowerCase()
//			  		if( alfanum == 1){
//					bien=false;                              
//				 var validos = "0123456789";
//			    if (validos.indexOf(letra) == -1){
//				  bien=true;
//					break;
//				  console.log(bien)
//				}
//			}else{
//				 var validos = "0123456789";
//			     if (validos.indexOf(letra) == -1){
//				  bien=false;
//				}
//			}
//			 }
//			  console.log(bien)
//
//			  if (!bien) {
//				  Tipo="error"
//			  alert("Error en serie " +serie+ ". Caracteres no aceptados");
//				$('.Serie3D').val("")
//			    $('.Serie3D').focus();
//			  }else{
			$.ajax({
				method: "POST",
				url: "/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp?",
				data: {
					Pt_ID:<%=Pt_ID%>,
					Tarea:8,
					Pro_ID:<%=Pro_ID%>,
					CliEnt_ID:<%=CliEnt_ID%>,
					Pallet:<%=Pallet%>,
					MB:$('.MBActual').val(),
					serie1:serie1,
					serie2:serie2,
					serie3:serie3,
					serie4:serie4,
					serie5:serie5,
					serie6:serie6,
					serie7:serie7,
					serie8:serie8,
					serie9:serie9,
					serie10:serie10				
				},
				cache: false,
					success: function (data) {
					var response = JSON.parse(data)
					var Tipo = ""
					
					if(response.result == 1){
						Tipo = "success"
						var suma = parseInt($("#escaneadas").val()) +10
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						$('#Serie3D').focus()	
						response.result = 2
						
					}
					if(response.result == 2){
						Tipo = "success"
						//var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						$('#Serie3D').hide();
						//$('#inputMBSerie').css('display','block')
						$('#inputMB').hide();
						$('#BtnMB').hide();
					
						$('#inputMB').val("")
						$('#inputMBSerie').focus()
						$("#divMB").html('<p style="color:#66CC99;"><font size = 10>' + response.message + '. <br/> Escanea la etiqueta del masterbox.</font></p>')
						FunctionMB.Mostrar3D()	

					}
					if(response.result == 3){
						var suma = parseInt($("#escaneadas").val()) +10
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						Tipo = "success"
						$('#Serie3D').hide();
						$('#inputMB').hide();
						$('#BtnMB').hide();
						//$('#inputMBSerie').css('display','block')
						$('#BtnUbic').css('display','block')
						$('#BtnMuestraUbic').css('display','block')
						$('#BtnUbicM').css('display','block')
						FunctionMB.Mostrar3D()	
						$('#Serie3D').hide();
					}
						if(response.result == 4){
						Tipo = "error"
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						$('#Serie3D').hide();
						$('#inputMBSerie').css('display','block')
						//$('#inputMB').css('display','block')
						//$('#BtnMB').css('display','block')
						$('#inputMB').val("")
						$('#inputMB').focus()
						$("#divMB").html('<p style="color:red;"><font size = 10 >' + response.message + '. <br/> Escanea la etiqueta del masterbox.</font></p>')
				

					}
						if(response.result == 5){
						Tipo = "error"
						$("#divMB").html('<p style="color:red;"><font size = 10 >' + response.message + '</font></p>')

					}
					if(response.result == 0){
						Tipo = "error"
					}
					$('.Serie3D').val("")
					Avisa(Tipo,"Aviso",response.message);
					
		
				}
			
			});
	   	 // }
				if(response.result == 3){
				$('#Serie3D').hide();
				}
		}
			
	},
//		$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
//		{Pt_ID:<%/*%><%=Pt_ID%><%*/%>,
//		Tarea:2,
//		Pro_ID:<%/*%><%=Pro_ID%><%*/%>,
//		CliEnt_ID:<%/*%><%=CliEnt_ID%><%*/%>,
//		Pallet:<%/*%><%=Pallet%><%*/%>,
//		MB:$('.MBActual').val(),
//		Serie:$('.Serie').val()
//		}
//		,function(data){
//			var response = JSON.parse(data)
//			var Tipo = ""
//			
//			if(response.result == 1){
//				Tipo = "success"
//				var suma = parseInt($("#escaneadas").val()) +1
//				$("#escaneadasValor").html(suma)
//				$("#escaneadas").val(suma)
//			}
//			 if(response.result == 2){
//				Tipo = "success"
//				var suma = parseInt($("#escaneadas").val()) +1
//				$("#escaneadasValor").html(suma)
//				$("#escaneadas").val(suma)
//				$('.Serie').hide();
//				$('#inputMB').css('display','block')
//				$('#BtnMB').css('display','block')
//			}
//				if(response.result == 3){
//				var suma = parseInt($("#escaneadas").val()) +1
//				$("#escaneadasValor").html(suma)
//				$("#escaneadas").val(suma)
//				Tipo = "success"
//				$('.Serie').hide();
//				$('#inputMB').hide();
//				$('#BtnMB').hide();
//				$('#BtnUbic').css('display','block')
//				}
//				
//				
//			 if(response.result == 0){
//				Tipo = "error"
//			}
//			Avisa(Tipo,"Aviso",response.message);
//			$('.Serie').val("")
//		});	
				

			
		InsertMBSerie:function(event){
		var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13){
					$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
					{Pt_ID:<%=Pt_ID%>,
					MB_Serie:$('#inputMBSerie').val(),
					IDUsuario:$('#IDUsuario').val(),
					Tarea:5
					}
					,	 function(data){
					var response = JSON.parse(data)
					var Tipo = ""
						if(response.result == 1){
					Tipo = "success"
					$('.inputMBSerie').val("")	
					$('.inputMBSerie').hide();
					$('#inputMB').css('display','block')
					$('#BtnMB').css('display','block')
					$('#Btn3D').css('display','block')
					$('#inputMB').val("")
					$("#divMB").html('<p style="color:#66CC99;"><font size = 10>Masterbox serializado correctamente</font></p>')
					}
					if(response.result == 2){
					Tipo = "success"
					$('.inputMBSerie').val("")	
					$('.inputMBSerie').hide();
					$('#BtnUbic').css('display','block')
					$('#BtnMuestraUbic').css('display','block')
					$('#BtnUbicM').css('display','block')
					$("#divMB").html('<p style="color:#66CC99;"><font size = 10>Masterbox serializado correctamente</font></p>')
					}
						if(response.result == 3){
					Tipo = "success"
					$('.inputMBSerie').val("")	
					$('.inputMBSerie').hide();
					$('#inputMB').css('display','block')
					$('#BtnMB').css('display','block')
					$('#inputMB').val("")
					$('#Btn3D').css('display','block')
					$("#divMB").html('<p style="color:red;"><font size = 10>'+response.message+'</font></p>')
					$('#inputMB').focus()
					}
					if(response.result == 4){
					Tipo = "success"
					$('.inputMBSerie').val("")	
					$('.inputMBSerie').hide();
					$('#BtnUbic').css('display','block')
					$('#BtnMuestraUbic').css('display','block')
					$('#BtnUbicM').css('display','block')
					$("#divMB").html('<p style="color:red;"><font size = 10>'+response.message+'</font></p>')
					}
					if(response.result == 0){
					Tipo = "error"	
					$("#divMB").html('<p style="color:red;"><font size = 10>'+response.message+'</font></p>')
					$('#inputMBSerie').val("")
					$('#inputMBSerie').focus()
					//Avisa(Tipo,"Aviso",response.message);
					}

					});
					
					}	
		}
}
	var FunctionMB = {
			InsertMB:function(){
				
					$.ajax({
    method: "POST",
    url: "/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp?",
    data: {Pt_ID:<%=Pt_ID%>,
		Tarea:3,
		MB:$('#MBActual').val(),
		Cantidad_MB:$('#inputMB').val(), 
		IDUsuario:$('#IDUsuario').val()
		},
    cache: false,
    success: function (data) {
			var response = JSON.parse(data)
			var Tipo = ""
			if(response.result == 1){
				Tipo = "success"
				var MB = response.MB 
				//parseInt($("#MBActual").val()) +1
				var suma = 0
				$("#escaneadasValor").html(suma)
				$("#escaneadas").val(suma)
				$("#MBValor").html(MB)
				$("#divMB").html("")
				$("#MBActual").val(MB)		
				$('.Serie').val("")
				$('#Serie').css('display','block')
				$('.inputMB').hide();
				$('.BtnMB').hide();
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
				Mostrar3D:function(){
			$.ajax({
    method: "POST",
    url: "/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp?",
    data: {Pt_ID:<%=Pt_ID%>,
		Tarea:3,
		TriDim:1,
		MB:$('#MBActual').val(),
		Cantidad_MB:$('#inputMB').val(), 
		IDUsuario:$('#IDUsuario').val()
		},
    cache: false,
    success: function (data) {
			var response = JSON.parse(data)
			var Tipo = ""
			if(response.result == 1){
				Tipo = "success"
				var MB = response.MB 
				//parseInt($("#MBActual").val()) +1
			//	var suma = 0
//				$("#escaneadasValor").html(suma)
//				$("#escaneadas").val(suma)
				$("#MBValor").html(MB)
				$("#divMB").html("")
				$("#MBActual").val(MB)		
				$('.Serie').val("")
				$('.Serie').hide();
				$('#Serie3D').css('display','block')
				$('.inputMB').hide();
				$('.Btn3D').hide();
				$('.BtnMB').hide();
				$('#Serie3D').focus()
				$("#divMB").html('<p style="color:#66CC99;"><font size = 10>Masterbox serializado correctamente</font></p>')

			}
		
			 if(response.result == 0){
				Tipo = "error"
			$("#divMB").html('<p style="color:red"><font size = 10>Error en etiqueta de masterbox ' + $('#MBActual').val() + ' /font></p>')

			}
				
			
			Avisa(Tipo,"Aviso",response.message);
			
	}
		});	
		
					
					
					}
		}	
		

				var FunctionUbic = {
					InsertUbic:function(){
					$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
					{Pt_LPN:$("#Pt_LPN").val(),
					Tarea:4,
					IDUsuario:<%=Id_Usuario%>,
					IR_ID:<%=IR_ID%>
					}
					,	 function(data){
						$('.Serie').hide();
						$('#inputMB').hide();
						$('#BtnMB').hide();
						$('#inputLPN').css('display','block')
					var lpn = $("#Pt_LPN").val()
					var folio = $("#Folio").val()
					var cliid = $("#Cli_ID").val()
					var provid = $("#Prov_ID").val()
					var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?Pt_LPN="+ lpn+"&FolioOC="+ folio+"&Tarea=1");
					
					});				
					},
					InsertUbicManual:function(){
					$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
					{Pt_LPN:$("#Pt_LPN").val(),
					Tarea:6,
					IDUsuario:<%=Id_Usuario%>,
				    Pt_Ubicacion:$("#lblUbiNombre").text(),
					IR_ID:<%=IR_ID%>
					}
					,	 function(data){
						$('.Serie').hide();
						$('#inputMB').hide();
						$('#BtnMB').hide();
						$('#inputLPN').css('display','block')
					var lpn = $("#Pt_LPN").val()
					var folio = $("#Folio").val()
					var cliid = $("#Cli_ID").val()
					var provid = $("#Prov_ID").val()
					var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?Pt_LPN="+ lpn+"&FolioOC="+ folio+"&Tarea=1");
					
					});				
					}
					}	
					
					var FunctionPallet = {
						CargaPallet:function(event){
								var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){
					var lpn = $("#inputLPN").val()
					lpn=lpn.replace("'","-")
					var proid =  $("#Pro_ID").val()
					var clientid =  $("#CliEnt_ID").val()
					var cliocid =  $("#CliOC_ID").val()
					var ocid =  $("#OC_ID").val()
					var cliid = $("#Cli_ID").val()
					var provid = $("#Prov_ID").val()
					$("#Contenido").load("/pz/wms/Recepcion/RecepcionEscaneo.asp?Pt_LPN=" + lpn+"&Pro_ID="+proid
					+"&CliEnt_ID="+clientid+"&CliOC_ID="+cliocid+"&OC_ID="+ocid+"&Cli_ID="+cliid+"&Prov_ID="+provid)
		}
						}			
					}
			
	$('.btnClasificar').click(function(e) {
		e.preventDefault()
		
		var Params = "?CliOC_ID=" + $(this).data("cliocid")
	    Params += "&OC_ID=" + $(this).data("ocid")
		Params += "&Cli_ID=" +  $(this).data("cliid") 
		Params += "&Prov_ID=" + $(this).data("provid") 
        Params += "&IR_ID=" + $(this).data("irid") 
 		Params += "&CliEnt_ID=" +$(this).data("client") 
	 	Params += "&IDUsuario=" + <%=IDUsuario%>
		$("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet.asp" + Params)
		});
</script>            