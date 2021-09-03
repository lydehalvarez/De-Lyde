<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var Tarea = Parametro("Tarea", -1)
    var Id_Usuario = Parametro("ID_Usuario",-1)  
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)  
	var OV_ID = Parametro("OV_ID",-1)
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
      		  sSQL += " WHERE Pt_LPN = '" + Pt_LPN +"' AND Pt_SKU = '"+Pt_SKU+"'"

		var rsPallet = AbreTabla(sSQL,1,0) 
		if(!rsPallet.EOF){
			Pt_ID = rsPallet.Fields.Item("Pt_ID").Value
		Pro_ID = rsPallet.Fields.Item("Pro_ID").Value
		
	
	var sSQLTr  = "SELECT TPro_ID, Pro_RFIDCG160 FROM Producto"
        sSQLTr += " WHERE Pro_ID = " + Pro_ID

		var rsTPro = AbreTabla(sSQLTr,1,0) 
			%>
				<input type="hidden" value="1" class="agenda" id="EsSKU"/>

				<%

		}else{
			
			Response.Write("<font color='red'><strong>El SKU no coincide con el LPN, favor de verificar.</strong></font>")
	%>
				<input type="hidden" value="0" class="agenda" id="EsSKU"/>

				<%
		if(CliOC_ID > -1){
	var sSQL = "SELECT CliOC_NumeroOrdenCompra FROM Cliente_OrdenCompra WHERE  Cli_ID = "+Cli_ID+" AND CliOC_ID = "+CliOC_ID
   var rsArt = AbreTabla(sSQL,1,0)
    var Tipo = "O.C.- "
	var Folio =  rsArt.Fields.Item("CliOC_NumeroOrdenCompra").Value

	}if(OC_ID > -1){
		var sSQL = "SELECT OC_Folio FROM Proveedor_OrdenCompra WHERE Prov_ID = "+Prov_ID+" AND OC_ID = "+OC_ID
   var rsArt = AbreTabla(sSQL,1,0)
    var Tipo = "O.C.- "
	var Folio =  rsArt.Fields.Item("OC_Folio").Value

	}
	if(TA_ID > -1){
	var sSQL = "SELECT TA_Folio FROM TransferenciaAlmacen WHERE  TA_ID = "+TA_ID
   var rsArt = AbreTabla(sSQL,1,0)
    var Tipo = "Transferencia: "
	var Folio =  rsArt.Fields.Item("TA_Folio").Value
	}
	if(OV_ID > -1){
	var sSQL = "SELECT OV_Folio FROM Orden_Venta WHERE  OV_ID = "+OV_ID
	Response.Write(sSQL)
   var rsArt = AbreTabla(sSQL,1,0)
    var Tipo = "S.O.- "
	var Folio =  rsArt.Fields.Item("OV_Folio").Value
	}

		if(Cli_ID == 6){
	   		sSQL = "SELECT ASN_FolioCliente FROM ASN WHERE IR_ID = "+ IR_ID
			var rsASN = AbreTabla(sSQL,1,0)
			var ASN =  rsASN.Fields.Item("ASN_FolioCliente").Value
		}
	}
}
	   sSQL = "SELECT IR_Folio FROM Inventario_Recepcion WHERE IR_ID = "+ IR_ID
	   var rsCita = AbreTabla(sSQL,1,0)
	   var Cita =  rsCita.Fields.Item("IR_Folio").Value

%>
 
<div class="form-horizontal">
    <div class="row">
        <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-content">
                        <div class="form-group">
                            <legend class="control-label col-md-12" style="text-align: left;"><h1>Cita:&nbsp;<%=Cita%><%/*%> &nbsp;<%=Tipo%>&nbsp;<%=Folio%>&nbsp;
                             <% if(Cli_ID==6){%>ASN:&nbsp;<%=ASN%><% }%><%*/%></h1></legend>
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
		var EsSKU = $("#EsSKU").val()
		console.log(EsSKU)
		if(EsSKU==0){
		$("#inputLPN").css('display','block')
		$("#inputLPN").focus()
		}else{

		$("#inputLPN").hide()
		$("#inputSKU").hide()
		$('#inputMB').css('display','block')
		$('#BtnMB').css('display','block')
		var serializado = $("#Pro_Serializado").val()
		if(serializado == 0){
			$('.Serie').hide();
		}
		}
		}
		$("#inputLPN").val("")
		});				
	},
		InsertSim:function(event){

		var keyNum = event.which || event.keyCode;
		  
		if(keyNum== 13 ){
		var SIMFin =	$('#SIMFin').val()
				if(SIMFin != ""){
		FunctionMB.InsertMB()
		FunctionRecepcion.ReanudarMB()

		$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
		{Pt_ID:<%=Pt_ID%>,
		Pro_ID:<%=Pro_ID%>,
		MB:$('#cboMB').val(),
		SIMIni:$('#SIMIni').val(),
		SIMFin:$('#SIMFin').val(),
		Tarea:9
		}
		,function(data){
			var response = JSON.parse(data)
					
					if(response.result == 1){
						beepOK()
						$("#divMB").html('<p style="color:#66CC99;"><font size = 10> ' +response.suma+ ' SIMS capturadas correctamente<br/> </font></p>')
					}
					if(response.result == 0){
						beep()
						$("#divMB").html('<p style="color:red;"><font size = 10> Ocurrio un error en la captura <BR/>Intente de nuevo<br/> </font></p>')
					}
					$('#SIMIni').val('')
					$('#SIMFin').val('')
					$('#SIMIni').focus()
			});
				}else{
					$('#SIMFin').focus()
				}
		}
			
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
				//$('#Serie3D').css('display','block')
				var RFID = $("#Pro_RFIDCG160").val()
				if(RFID == 1||RFID==2){
					$("#RFID").css('display','block')
				}
				var serializado = $("#Pro_Serializado").val()
				if(serializado == 0){
					$(".Serie").hide()
				}

		});
	},
		MostrarUbicaciones:function(){
		$('#Pt_Ubicacion').css('display','block')
		$('#BtnUbicM').css('display','block')
		},
	InsertSerie:function(event){
		
		var keyNum = event.which || event.keyCode;
		  
		if(keyNum== 13 ){
			
			var largoRFID =0
			var SerieRFID=$("#RFID").val()
 			var Serializado = $("#Pro_Serializado").val()
			if(Serializado == 0){
				$(".Serie").val(SerieRFID)
			}
			var serie = $('.Serie').val()
	   		var PrefijoSerie = serie.slice(0,4)
			var rfidopc = $("#RFIDOpc").val()
			$('.RFID').val("")
			var RFID = $("#Pro_RFIDCG160").val()
			
 			var bien = true;
			var alfanum = $('.Alfanum').val()
	
 			var letra;
			var largo = serie.length
			if(RFID>0){
			 largoRFID = SerieRFID.length
			}
			console.log(RFID)
			console.log($("#Digitos").val())
			if((largo == $("#Digitos").val() && RFID<3) ||(largo == $("#Digitos").val() && largoRFID == 16 && RFID==3)){
			//if((largo > 13 && largo < 18  && RFID<3) ||(largo > 13 && largo < 18 && largoRFID == 16 && RFID==3)){
				if((rfidopc==0 && SerieRFID !="") || rfidopc ==1||RFID<3){
			if(RFID==3||Serializado == 0){
				serie = SerieRFID
				largo = largoRFID
				alfanum =0
				 var PrefijoRFID = SerieRFID.slice(0,4)

			}
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
				  beep()
				  Tipo="error"
			  	if(RFID==3){
			$("#divMB").html('<p style="color:red;"><font size = 10 >Error en RFID ' +SerieRFID+ ' Caracteres no aceptados <br/> Escanea la etiqueta del masterbox.</font></p>')
				$('.RFID').val("")
			    $('.RFID').focus();
			
			}else{
				beep()
				$("#divMB").html('<p style="color:red;"><font size = 10 >Error en serie ' +serie+ '. Caracteres no aceptados <br/> Escanea la etiqueta del masterbox.</font></p>')
				  
				$('.Serie').val("")
			    $('.Serie').focus();
			}
			  }else{
			  	serie=$('.Serie').val()
				console.log(PrefijoRFID)
				console.log(PrefijoSerie)
				console.log($("#PrefijoRFID").val())
				if(RFID==0||(RFID==3 && PrefijoRFID==$("#PrefijoRFID").val() && PrefijoSerie != $("#PrefijoRFID").val() && Serializado ==1)||(RFID==1 && PrefijoRFID==$("#PrefijoRFID").val() && PrefijoSerie == $("#PrefijoRFID").val() && Serializado ==0)){  
				
			$('.Serie').val("")
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
					Escaneos: $("#escaneadas").val(),
					Serie:serie,
					RFID:SerieRFID,
				},
				cache: false,
					success: function (data) {
					var response = JSON.parse(data)
					var Tipo = ""
					
					if(response.result == 1){
						beepOK()
						Tipo = "success"
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						$('#Serie').focus()	
						$('#Pro_RFIDCG160').val(response.rfid)
						$("#divMB").html('<p style="color:#66CC99;"><font size = 10>Serie numero ' +suma+ ' escaneada correctamente<br/> </font></p>')

					}
					if(response.result == 2){
						beepOK()
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
						$('#RFID').hide();
						$("#divMB").html('<p style="color:#66CC99;"><font size = 10>' + response.message + '. <br/> Escanea la etiqueta del masterbox.</font></p>')
						$('#Pro_RFIDCG160').val(response.rfid)
					}
					if(response.result == 3){
						beepOK()
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						Tipo = "success"
						$('.Serie').hide();
						$('#inputMB').hide();
						$('#BtnMB').hide();
						$('#inputMBSerie').css('display','block')
						$('#Pro_RFIDCG160').val(response.rfid)
					}
						if(response.result == 4){
						beep()
						Tipo = "error"
						var suma = parseInt($("#escaneadas").val()) +1
						$("#escaneadasValor").html(suma)
						$("#escaneadas").val(suma)
						$('.Serie').hide();
						$('#inputMBSerie').css('display','block')
						$('#Pro_RFIDCG160').val(response.rfid)
						$('#RFID').hide();
						//$('#inputMB').css('display','block')
						//$('#BtnMB').css('display','block')
						$('#inputMB').val("")
						$('#inputMB').focus()
						$("#divMB").html('<p style="color:red;"><font size = 10 >' + response.message + '. <br/> Escanea la etiqueta del masterbox.</font></p>')
					}
						if(response.result == 5){
						beep()
						Tipo = "error"
						$("#divMB").html('<p style="color:red;"><font size = 10 >' + response.message + '</font></p>')
						$('#Pro_RFIDCG160').val(response.rfid)
					}
					if(response.result == 6){
					Tipo = "error"	
					$("#divMB").html('<p style="color:red;"><font size = 10>'+response.message+'</font></p>')
					$('.Serie').val("")
					$('.Serie').focus()
					//Avisa(Tipo,"Aviso",response.message);
					beep()
					}
					if(response.result == 7){
					Tipo = "error"	
					$("#divMB").html('<p style="color:red;"><font size = 10>'+response.message+'</font></p>')
					$('.Serie').val("")
					$('.Serie').focus()
					$("#Pro_RFIDCG160").val('1')
					//Avisa(Tipo,"Aviso",response.message);
					beep()
					}
					if(response.result == 8){
					Tipo = "error"	
					$("#divMB").html('<p style="color:red;"><font size = 10>'+response.message+'</font></p>')
					$('.Serie').val("")
					$('.Serie').focus()
					$("#Pro_RFIDCG160").val('1')
					$("#escaneadas").val('0')
					$("#escaneadasValor").html('0')
					//Avisa(Tipo,"Aviso",response.message);
					beep()
					}
					if(response.result == 0){
						beep()
						Tipo = "error"
						$('#Pro_RFIDCG160').val(response.rfid)
						$('.Serie').focus()
					}
					$('.Serie').val("")
					Avisa(Tipo,"Aviso",response.message);
					
		
				}
			
			});
				}
				if(RFID==3 && PrefijoRFID != $("#PrefijoRFID").val()){
					beep()
					$("#divMB").html('<p style="color:red;"><font size = 10 >El RFID no coincide con el formato.</font></p>')
				}

				if(RFID==3 && PrefijoSerie == $("#PrefijoRFID").val() && Serializado ==1){
					beep()
					$("#divMB").html('<p style="color:red;"><font size = 10 >No escanear el RFID en lugar de la serie.</font></p>')
					$(".Serie").val('')
					$("#Serie").focus()
					 $("#Pro_RFIDCG160").val('1')
				}
					if(RFID==3 && PrefijoSerie != $("#PrefijoRFID").val() && Serializado ==0){
					beep()
					$("#divMB").html('<p style="color:red;"><font size = 10 >No se escaneo el RFID en la serie.</font></p>')
					$(".Serie").val('')
					$("#Serie").focus()
					 $("#Pro_RFIDCG160").val('1')
				}
				if(RFID==1||RFID==2){
					$("#RFID").focus()
					$("#Pro_RFIDCG160").val("3")
					if(RFID==1){
						$("#RFIDOpc").val("0")
					}
					
				}
			  }
			  }else{
				  beep()
					$("#divMB").html('<p style="color:red;"><font size = 10 >El RFID es obligatorio.</font></p>')
			  }
		    	
			  	  }else{
					  beep()
						$("#divMB").html('<p style="color:red;"><font size = 10 >El largo de caracteres esta configurado a '+ $("#Digitos").val() +'  digitos</font></p>')
						$('.Serie').val("")
						$('.RFID').val("")
						$('.Serie').focus()
					  var RFID =  $("#Pro_RFIDCG160").val()
					  if(RFID == 3){
					    $("#Pro_RFIDCG160").val('1')
					  }
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
						beep()
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
						beep()
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
					beep()
					}
			

					});
					
					}	
		}
}
	var FunctionMB = {
			InsertMB:function(){
			var Sim = $('#SIMFin').val()

					$.ajax({
    method: "POST",
    url: "/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp?",
    data: {Pt_ID:<%=Pt_ID%>,
		SIMFin:Sim,
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
				$('#RFID').val("")
				$('#RFID').css('display','block')
				$('.inputMB').hide();
				$('.BtnMB').hide();
				$('#Serie').focus()
				var serializado = $("#Pro_Serializado").val()
				if(serializado == 0){
					$("#Serie").hide()
					$('#RFID').focus()
				}
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
				beepOK()
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
				beep()
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
			var Pt_SKU = $("#inputSKU").val()
		
				var EsSKU = 0;
		if(Pt_SKU.substr(0,3) == "+C1"){
			EsSKU = 1
			Pt_SKU = Pt_SKU.substr(3,100)
		}
		if((Pt_SKU.length >4) || (Pt_SKU.length == 6)){
			EsSKU = 1
		}
				if(Pt_SKU != "" && EsSKU==1){
					var lpn = $("#inputLPN").val()
					lpn=lpn.replace("'","-")
					var proid =  $("#Pro_ID").val()
					var clientid =  $("#CliEnt_ID").val()
					var cliocid =  $("#CliOC_ID").val()
					var ocid =  $("#OC_ID").val()
					var cliid = $("#Cli_ID").val()
					var provid = $("#Prov_ID").val()
					var irid = $("#IR_ID").val()
					$("#Contenido").load("/pz/wms/Recepcion/RecepcionEscaneo.asp?Pt_LPN=" + lpn+"&Pro_ID="+proid
+"&CliEnt_ID="+clientid+"&CliOC_ID="+cliocid+"&OC_ID="+ocid+"&Cli_ID="+cliid+"&Prov_ID="+provid+"&IR_ID="+irid+"&Pt_SKU="+Pt_SKU+"")
					$.post("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",
					{IR_ID:$("#IR_ID").val(),
					Tarea:10
					},	 
					function(data){
					});
			}else{
				$("#inputLPN").css('display','block')
				$("#inputSKU").focus()
			}
		}
						}			
					}
function beep() { 
var snd = new Audio("/Sonido/Error.mp3"); snd.play(); 
}
function beepOK(){
//var snd = new Audio("/Sonido/Continuar.mp3"); snd.play(); 

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