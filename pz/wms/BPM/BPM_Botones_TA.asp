<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

    var Pro_ID = Parametro("Pro_ID",-1)
    var IDUnica = Parametro("IDUnica",-1)
    var CliOC_ID = Parametro("CliOC_ID",-1)
    var Cli_ID = Parametro("Cli_ID",-1)
    var TA_ID = Parametro("TA_ID",-1)
 
 var MercaDaniada = utf8_decode("Mercancía dañada")
 
 var UsuID = 0
 var BPM_Pro_ID = 0
 var BPM_Flujo = 0
 var BPM_Estatus = 0
 var Estatus = ""
 var TipoUsuario= ""
 var LLaveUsuario = 0
 var ProD_FuncionQueEvalua = ""
 var Evaluacion = true
 
 var sSQL  = " SELECT Tipo, ID "
	 sSQL += " FROM dbo.ufn_Usuario_Identifica(" + IDUnica + ") " 
   
 var rsTP = AbreTabla(sSQL,1,0)
 if (!rsTP.EOF){
	TipoUsuario = rsTP.Fields.Item("Tipo").Value
	LLaveUsuario = rsTP.Fields.Item("ID").Value	
 }
 rsTP.Close()
 
 if(TipoUsuario ==""){
	 Response.Write("NO se pudo determinar el tipo de usuario, validar los parametros")
	 Response.End()
 }
   
 if (TA_ID > -1 ) { 
   	var sSQL1  = "select BPM_Pro_ID, BPM_Flujo, BPM_Estatus "
        sSQL1 += " ,(SELECT ProE_Nombre FROM BPM_Proceso_Estatus WHERE Pro_ID = BPM_Pro_ID "
	    sSQL1 +=      " AND ProE_ID = BPM_Estatus) AS Estatus "
        sSQL1 += " from TransferenciaAlmacen "
	    sSQL1 += " where TA_ID = " + TA_ID
 }
if (CliOC_ID > -1 ) { 
   	var sSQL1  = "select BPM_Pro_ID, BPM_Flujo, BPM_Estatus "
        sSQL1 += " ,(SELECT ProE_Nombre FROM BPM_Proceso_Estatus WHERE Pro_ID = BPM_Pro_ID "
        sSQL1 +=      " AND ProE_ID = BPM_Estatus) AS Estatus "
        sSQL1 += " from Cliente_OrdenCompra "
	    sSQL1 += " where Cli_ID = " + Cli_ID
	    sSQL1 += " and CliOC_ID = " + CliOC_ID
 }	
  
var rsVtc = AbreTabla(sSQL1,1,0)
if (!rsVtc.EOF){
	BPM_Pro_ID = rsVtc.Fields.Item("BPM_Pro_ID").Value
	BPM_Flujo = rsVtc.Fields.Item("BPM_Flujo").Value	
	BPM_Estatus = rsVtc.Fields.Item("BPM_Estatus").Value
	Estatus = rsVtc.Fields.Item("Estatus").Value	
}

var sSQL  = " SELECT ProD_ID, ProD_Descripcion, ProD_Estilo, ProD_Etiqueta " 
	sSQL += " , ProD_EnviarA_ProF_ID, ProD_ConEstatus_ProE_ID, ProD_FuncionQueEvalua "
	sSQL += " FROM BPM_Proceso_Flujo_Decisiones d, BPM_Proceso_Rol_Usuario r " 
	sSQL += " WHERE  d.Pro_ID = r.Pro_ID AND d.Pro_ID = " + BPM_Pro_ID
	sSQL += " AND ProD_TipoCG301 = 1 AND ProD_Activo = 1 "	 
	sSQL += " AND d.ProF_ID = " + BPM_Flujo
	sSQL += " AND d.ProR_ID = r.ProR_ID "
                                     
	if(TipoUsuario == 'U'){
		 sSQL += " AND r.Usu_ID = " + LLaveUsuario 
	}
	if(TipoUsuario == 'E'){
		 sSQL += " AND r.Emp_ID = " + LLaveUsuario 
	}
	if(TipoUsuario == 'O'){
		 sSQL += " AND r.Ope_ID = " + LLaveUsuario 
	}
	sSQL += " ORDER BY ProD_Orden " 
 //Response.Write("<br>query que carga los botones " + sSQL ) 
  
	var rsDecision = AbreTabla(sSQL,1,0)

 while (!rsDecision.EOF){
	Evaluacion = true 
 	ProD_FuncionQueEvalua = FiltraVacios(rsDecision.Fields.Item("ProD_FuncionQueEvalua").Value)	
 	if(ProD_FuncionQueEvalua != "") {
		ProD_FuncionQueEvalua = ProcesaBuscadorDeParametros(ProD_FuncionQueEvalua)
 		var RspEvaluacion = EjecutaObjetoBD(ProD_FuncionQueEvalua,0) 
		Evaluacion = RspEvaluacion == 1		 
	}
    if(Evaluacion) {      
%>                
    <button type="button" id="<%=rsDecision.Fields.Item("ProD_Estilo").Value%>"
     class="btn btn-outline btnEstatus <%=rsDecision.Fields.Item("ProD_Estilo").Value%>" 
    	    title="<%=rsDecision.Fields.Item("ProD_Descripcion").Value%>"
             data-prodid="<%=rsDecision.Fields.Item("ProD_ID").Value%>"><%=rsDecision.Fields.Item("ProD_Etiqueta").Value%></button>
<%
	}
	rsDecision.MoveNext()  
	} 
rsDecision.Close()   
%> 


<script type="application/javascript">

$(document).ready(function(e) {
	
	$('.btnEstatus2').click(function(e){
		
		
		e.preventDefault();
		var dato = $(this)
		var tipo = $(this).attr('id');
		var Nombre = $(this).text()
		dato.addClass('disabled');
		
		var titulo = ""
		var type = ""
		var texto = ""
		var ConfirmButton = ""
		var ConfirmButtonColor = ""
		var sDato = "<%=MercaDaniada%>"
		
		//console.log(tipo+" "+Nombre+" "+sDato)
	 	
		if(tipo == "btn-primary"){ 
			titulo = "Ir a &quot;"+Nombre+"&quot;"
			texto = "&iquest;Deseas continuar con el siguiente paso?"
			ConfirmButton = "Claro, avanzar!" 
			ConfirmButtonColor = "#55c5dd"
			type = "success"
		}else{
			titulo = "Ir a &quot;"+Nombre+"&quot;"
			texto = "&iquest;Seguro que deseas cancelar el proceso?"
			ConfirmButton = "Si, cancelar!" 
			ConfirmButtonColor = "#DD6B55"
			type = "error"
		}
		if(Nombre == sDato){
			titulo = "Mercanc&iacute;a da&ntilde;ada!"
			texto = "&iquest;Marcar como mercanc&iacute;a da&ntilde;ada?"
			ConfirmButton = "Si, adelante!" 
			ConfirmButtonColor = "#55c5dd"
			type = "error"
			console.log("Caso "+Nombre)
		}		
		
		swal({
			  title: titulo,
			  text: texto,
			  type: type,
			  showCancelButton: true,
			  confirmButtonColor: ConfirmButtonColor,
			  confirmButtonText: ConfirmButton, 
			  closeOnConfirm: true,
			  html: true
			},
			function(data){
				if(data){
					BotonEstatus(dato)
					dato.addClass('disabled');
					
				}else{
					$('.btnEstatus').show('slow')
					dato.removeClass('disabled');
			}
		});	
	});	
	
    $('.btnEstatus').click(function(e){
        e.preventDefault();
        BotonEstatus($(this))
    });	
});

<!--

function BotonEstatus(o){
	
	$(".btnEstatus").removeClass("active")
	o.addClass("active")

	$("#BPMBotones").hide("slow")

	$.post( "/pz/wms/BPM/BPM_Ajax.asp" 
		 , {  Tarea:1
			 ,Pro_ID:<%=Pro_ID%>
			 ,Flujo:<%=BPM_Flujo%>	
			 ,ProD_ID:o.data("prodid")
			 ,TA_ID:<%=TA_ID%>	
             ,Cli_ID:<%=Cli_ID%>
             ,CliOC_ID:<%=CliOC_ID%>
			 ,IDUnica:$("#IDUsuario").val() }
			 , function(data) { 
			 	if(data > -1){
                    var sMensaje= "Se actualiz&oacute; el estatus correctamente.";
                    Avisa("success",'Actualizaci&oacute;n de estatus',sMensaje)	
				}
				CargaEstatus(o.data("prodid"))
	});		

}

function CargaEstatus(prodid){
	
	$.post( "/pz/wms/BPM/BPM_Ajax.asp" 
		 , {  Tarea:2
			 ,Pro_ID:<%=Pro_ID%>
			 ,Flujo:<%=BPM_Flujo%>	
			 ,ProD_ID:prodid
			 ,TA_ID:<%=TA_ID%>	
             ,Cli_ID:<%=Cli_ID%>
             ,CliOC_ID:<%=CliOC_ID%>
			 ,IDUnica:$("#IDUsuario").val() }	   
			 , function(estatus) { 
				$("#BPMBotones").html(estatus).show("slow");
			});	
	
}

-->
</script> 	
	   
		