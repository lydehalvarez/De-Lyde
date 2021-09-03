<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
//	Esta ventana es del BPM
//  carga el archivo inicial del proceso, el que esta indicado en el paso 1 del proceso
//  este archivo iniciara el proceso 
    var bIQon4Web = false
	var ProT_ID = Parametro("ProT_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	
	var For_Archivo = ""
	var For_ArchivoJS = ""	
	var For_Parametros = ""	
	var For_Nombre = ""
	var For_Descripcion = ""
	var For_ArchivoCSS = ""		
	
    //Paso 1 - UNO
	var sSQL = "SELECT For_Nombre, For_Descripcion, For_Archivo, For_ArchivoCSS "
	    sSQL += " , For_ArchivoJS, For_Parametros, For_DivDeCarga "	
	    sSQL += " FROM BPM_Proceso_Flujo pf, Formato f "
		sSQL += " WHERE pf.For_ID = f.For_ID "
		sSQL += " AND f.For_Habilitado = 1 "
		sSQL += " AND pf.Pro_ID = " + Pro_ID    //el proceso tiene id unico para no complicar la operacion con la llave de tipo
		sSQL += " AND pf.ProF_ID = 1 " 			
        if(bIQon4Web) { Response.Write(sSQL) }
   
	var rsFormato = AbreTabla(sSQL,1,0)
   
    if (!rsFormato.EOF){
		For_Archivo = FiltraVacios( rsFormato.Fields.Item("For_Archivo").Value )
		For_ArchivoJS = FiltraVacios( rsFormato.Fields.Item("For_ArchivoJS").Value )
		For_Parametros = FiltraVacios( rsFormato.Fields.Item("For_Parametros").Value )
		For_Nombre = FiltraVacios( rsFormato.Fields.Item("For_Nombre").Value	)
		For_Descripcion = FiltraVacios( rsFormato.Fields.Item("For_Descripcion").Value )	
		For_ArchivoCSS = FiltraVacios( rsFormato.Fields.Item("For_ArchivoCSS").Value	)					
	}

	if(For_Parametros != "") {
		For_Parametros = "?" + ProcesaBuscadorDeParametros(For_Parametros)
	}
	
	if(For_Archivo != ""){
%>

<div class="animated fadeInRight">    
    <div class="ibox-content forum-container">
        <div class="forum-item active" style="border-bottom: none;padding-bottom: 2px">
            <div class="row">
                <div class="col-md-9">
                    <div class="forum-icon">
                        <i class="fa fa-file-text-o"></i>
                    </div>
                    <a href="#" class="forum-item-title"><%=For_Nombre%></a>
                    <div class="forum-sub-title"><%=For_Descripcion%></div>
                </div>
                <div class="col-md-1 forum-info">
                    <span class="views-number">
                        <a href="javascript:GuardaOC()" id="btnGuardar" class="btn btn-primary btn-sm" style="display:none">Guardar Orden de Compra</a>
                    </span>
                </div>
            </div>
        </div>
        <div class="forum-item">
            <div id="dvFor_Archivo"></div>        
        </div>       
    </div>
</div>        
<%  } 
 	if(For_ArchivoCSS != ""){  
		Response.Write("<link href='" + For_ArchivoCSS + "' rel='stylesheet'>")
 	} 
%>
<script type="text/javascript">

	$(document).ready(function() {
		
<%	if(For_Archivo != ""){ %>
		$('#dvFor_Archivo').load('<%=For_Archivo + For_Parametros%>');
<%	} %>
		
	});
	
	function EstadoBoton(Visible) {
		if( Visible == 1 ) {
			$("#btnGuardar").show("slow")
		} else {
			$("#btnGuardar").hide("slow")		
		}
	}

</script>
<%	if(For_ArchivoJS != ""){  
		Response.Write("<script src='" + For_ArchivoJS + "'></script>")
 	}
%>
	
    
    
    