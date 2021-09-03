<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var OV_ID = Parametro("OV_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var IDUnica = Parametro("IDUsuario",-1)	
	var Cort_ID = Parametro("Cort_ID",-1)
	
	var TipoUsuario = ""
    var LLaveUsuario = 0
    var RolActivo = 0
	var For_Archivo = ""
	var For_ArchivoJS = ""	
	var For_Parametros = ""	
	var For_Nombre = ""
	var For_Descripcion = ""
	var For_ArchivoCSS = ""		
	
	var OV_BPM_Pro_ID = ""
	var OV_BPM_Flujo = ""
	var OV_BPM_Estatus = ""	
 
   
   	var sSQL1  = "SELECT TOP 1 * "
        sSQL1 += " FROM Orden_Venta "
	    sSQL1 += " WHERE Cort_ID = "+Cort_ID
   
   var rsTP = AbreTabla(sSQL1,1,0)
	if (!rsTP.EOF){
        OV_BPM_Pro_ID  = rsTP.Fields.Item("OV_BPM_Pro_ID").Value
        OV_BPM_Flujo   = rsTP.Fields.Item("OV_BPM_Flujo").Value
        OV_BPM_Estatus = rsTP.Fields.Item("OV_BPM_Estatus").Value
   }
   
    //Ubico al usuario para cargar el formato correcto
	var sSQL  = " SELECT * "
		sSQL += " FROM dbo.ufn_BPM_UbicaFormulario(" + IDUnica 
        sSQL += "," + OV_BPM_Pro_ID + "," + OV_BPM_Flujo + "," + OV_BPM_Estatus + ") " 

	var rsTP = AbreTabla(sSQL,1,0)
	if (!rsTP.EOF){
		TipoUsuario = rsTP.Fields.Item("Tipo").Value
		LLaveUsuario = rsTP.Fields.Item("ID").Value	
		OV_BPM_Pro_ID = rsTP.Fields.Item("BPM_Pro_ID").Value 
		Pro_ID = OV_BPM_Pro_ID
		ParametroCambiaValor("Pro_ID",OV_BPM_Pro_ID)
		OV_BPM_Flujo = rsTP.Fields.Item("BPM_Flujo").Value 
		OV_BPM_Estatus = rsTP.Fields.Item("BPM_Estatus").Value
		For_Archivo = FiltraVacios( rsTP.Fields.Item("For_Archivo").Value )
		For_ArchivoJS = FiltraVacios( rsTP.Fields.Item("For_ArchivoJS").Value )
		For_Parametros = FiltraVacios( rsTP.Fields.Item("For_Parametros").Value )
		ProF_Nombre = FiltraVacios( rsTP.Fields.Item("ProF_Nombre").Value	)
		ProF_Descripcion = FiltraVacios( rsTP.Fields.Item("ProF_Descripcion").Value )	
		For_ArchivoCSS = FiltraVacios( rsTP.Fields.Item("For_ArchivoCSS").Value	)	
	}
	rsTP.Close()
	
	var ModoConfiguracion = ParametroDeVentanaConUsuario(SistemaActual, VentanaIndex, IDUsuario, "Modo Configuracion",0)
		
	if(For_Parametros != "") {
		For_Parametros = ProcesaBuscadorDeParametros(For_Parametros)
	} else {
		For_Parametros = "OV_ID=" + OV_ID
		For_Parametros += "&Pro_ID=" + Pro_ID
	}

	if(For_Archivo != ""){
%>
<div class="ibox">
<% if(ModoConfiguracion==1 ){ %> 
                         <div class="ibox-title">
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                                <a class="help-link">
                                    <i class="fa fa-question-circle"></i>
                                </a>
                                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                    <i class="fa fa-wrench"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-user">
                                    <li><a href="#">Config option 1</a>
                                    </li>
                                    <li><a href="#">Config option 2</a>
                                    </li>
                                </ul>
                                <a class="Coments-link">
                                    <i class="fa fa-comments-o"></i>
                                </a>
                            </div>
                        </div>
  <% } %>                      
                       
    <div class="ibox-content">                        
        <div class="col-md-col-md-offset-0 forum-icon">
            <i class="fa fa-file-text-o"></i>
        </div>
        <a class="forum-item-title" href="#" style="pointer-events: none">
        <h2><strong><%=ProF_Nombre%></strong></h2></a>    
        <div class="forum-sub-title" style="padding-left:50px;"><%=ProF_Descripcion%></div>
        <span class="pull-right" id="BPMBotones">
        </span>        
        <div class="ibox" id="dvFor_Archivo"></div>
    </div>
  
</div>
      
<%  } 
 	if(For_ArchivoCSS != ""){  
		Response.Write("<link href='" + For_ArchivoCSS + "' rel='stylesheet'>")
 	} 
%>
<script type="text/javascript">

	var Paramts = "IDUnica=" + $("#IDUsuario").val()
	    Paramts += "&<%=For_Parametros%>"

	$(document).ready(function() {
		
		
  $('.collapse-link').on('click', function () {
        var ibox = $(this).closest('div.ibox-title');
        var button = $(this).find('i');
        var content = ibox.children('.ibox-content');
        content.slideToggle(200);
        button.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
        ibox.toggleClass('').toggleClass('border-bottom');
        setTimeout(function () {
            ibox.resize();
            ibox.find('[id^=map-]').resize();
        }, 50);
    });

  
    $('.help-link').on('click', function () {
        console.log("help")
    });
		
	$('.Coments-link').on('click', function () {
        console.log("Comentarios")
    });	
		
		
		
<%	if(For_Archivo != ""){ %>

		$('#dvFor_Archivo').load('<%=For_Archivo%>?' + Paramts);
<%	} %>
		
		BPM_CargaBotonesYEstatus()
	});
	
	function EstadoBoton(Visible) {
		if( Visible == 1 ) {
			$("#btnGuardar").show("slow")
		} else {
			$("#btnGuardar").hide("slow")		
		}
	}
	
	function BPM_CargaBotonesYEstatus(){
		$("#BPMBotones").load("/pz/wms/BPM/BPM_Botones_OS.asp?" + Paramts);
	}

</script>
<%	if(For_ArchivoJS != ""){  
		Response.Write("<script src='" + For_ArchivoJS + "'></script>")
 	}
%>
	