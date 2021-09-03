<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
var Usu_ID = Parametro("Usu_ID",-1)

var Alr_QueryContadorCasos = ""

//estatus          
//<span class="badge">92</span>
//<span class="badge badge-success">15</span>
//<span class="badge badge-warning">4</span>
//<span class="badge badge-danger">6</span>
//<span class="badge badge-info">45</span>
//<span class="badge badge-inverse">10</span>

function ProcesaBuscadorDeParametros(sValor) {

	var sRespuesta = sValor
	var arrPrm    = new Array(0)
	var iPos = sRespuesta.indexOf("{");
	if (iPos > -1) {
		var Antes = sRespuesta.substr(0, iPos);
        var Despues = sRespuesta.substr(iPos  + 1, sRespuesta.length - iPos)
		var iPos2 = Despues.indexOf("}");
		var sParm = Despues.substr(0, iPos2);
		var Despues = Despues.substr(iPos2 + 1, Despues.length - iPos2)
		// resuelve el parametro
		var arrPrm = sParm.split(",")
		var sTmpPP = Parametro(arrPrm[0],arrPrm[1])
		sRespuesta = Antes + sTmpPP + Despues
		sRespuesta = ProcesaBuscadorDeParametros(sRespuesta)
	} 
	return sRespuesta
	
}




%>
<style type="text/css">
	.T_info {
		font-size:11px;
		margin-left: 20px;
	} 
	.T_infofechas {
		font-size:11px;
		margin-left: 20px;
		margin-top: 4px;
	}
	.Semaforo {
    width: 60px;
    min-width: 16px;
    text-align: center;
    display: inline-block;
	}

</style> 
        <h2>Avisos y alertas</h2>
        <small>Tareas pendientes por atender</small>
        <ul class="list-group clear-list m-t">
<%  
// primera parte avisos programados por la accion de un proceso y que estan registrados en la tabla de BPM_Proceso_Flujo_Decision_Alerta


	var Llaves = "" 
	var Alr_MostrarSiEsCero = 0
	var Alr_SemaforoVerde = 0
	var Alr_SemaforoAmarillo = 0
	var Alr_SemaforoRojo = 0
	var iRenglon = " fist-item"
	var bMostrar = true
 	
  	var sSQL = "Select * from dbo.tuf_BPM_AvisosAlertas(" + Usu_ID + ")"	
//Response.Write("<br>" + sSQL)
 	var rsAvisos = AbreTabla(sSQL,1,0)	
	while (!rsAvisos.EOF){ 
	Llaves = "" + rsAvisos.Fields.Item("Alr_ID").Value
	
	Alr_MostrarSiEsCero  = rsAvisos.Fields.Item("Alr_MostrarSiEsCero").Value
    Alr_SemaforoVerde    = rsAvisos.Fields.Item("Alr_SemaforoVerde").Value
	Alr_SemaforoAmarillo = rsAvisos.Fields.Item("Alr_SemaforoAmarillo").Value
	Alr_SemaforoRojo     = rsAvisos.Fields.Item("Alr_SemaforoRojo").Value
	//el contador dde casos solo sirve si no es suficiente con que etse en el estatsu el paso del proceso y es necesario
	//hacer otra forma de contar los casos
	//la plantilla es la que cargara los casos segun funcione el caso
	Alr_QueryContadorCasos = FiltraVacios(rsAvisos.Fields.Item("Alr_QueryContadorCasos").Value)
	if(Alr_QueryContadorCasos != "") {
		Alr_QueryContadorCasos = ProcesaBuscadorDeParametros(Alr_QueryContadorCasos)
		var rsContador = AbreTabla(Alr_QueryContadorCasos,1,0)	
	    if (!rsContador.EOF){ 
			Alr_SemaforoVerde = rsContador.Fields.Item(0).Value
		}
		rsContador.Close()
	}
	
	
	bMostrar = Alr_SemaforoVerde > 0 	
	if( Alr_MostrarSiEsCero == 1 ) {
		bMostrar = true
	}
	
    if (bMostrar) {
%> 
			<li class="list-group-item<%=iRenglon%>" >
                <span class="pull-right">
                    <i class="<%=rsAvisos.Fields.Item("Alr_Icono").Value%>"></i>
                </span>
                
                <span class="Semaforo" ><span class="badge badge-success"><%=Alr_SemaforoVerde%></span></span>                
				<a href="javascript:CargaAviso(<%=Llaves%>)" title="<%=rsAvisos.Fields.Item("Alr_Ayuda").Value%>" >
                   <%=rsAvisos.Fields.Item("Alr_Letrero").Value%></a>
            </li>
<%
	}
		iRenglon = ""
		rsAvisos.MoveNext() 
	}
	rsAvisos.Close()   

// Segunda parte, los avisos extraidos por un query

	
	
  	var sSQL = "SELECT a.AlrS_ID, a.Alr_ID, Alr_Descripcion, Alr_Letrero, Alr_Ayuda, Alr_Icono "
		sSQL += ", ISNULL(Alr_QueryContadorCasos,'') as Casos, Alr_QueryDatos, Alr_MostrarSiEsCero "
		sSQL += " FROM Alertamientos a, Usuario_Alertamientos u "
		sSQL += " WHERE a.AlrS_ID = u.AlrS_ID AND a.Alr_ID = u.Alr_ID "
		sSQL += " AND Alr_EsParaPantalla = 1 "
		sSQL += " AND u.Alr_Pantalla = 1 "
		sSQL += " AND u.Alr_Habilitado = 1 "
		sSQL += " AND Alr_Habilitada = 1 "
		sSQL += " AND Alr_VisibleAdmin = 1 AND Acc_TipoCG302 = 2 "		
		sSQL += " AND u.ID_Usuario = " + Usu_ID
	
	var iRenglon = " fist-item"
	var bMostrar = true

 	var rsAvisos = AbreTabla(sSQL,1,0)	
	while (!rsAvisos.EOF){ 
	Llaves = "" + rsAvisos.Fields.Item("Alr_ID").Value
	Alr_QueryContadorCasos = rsAvisos.Fields.Item("Casos").Value
	Alr_MostrarSiEsCero  = rsAvisos.Fields.Item("Alr_MostrarSiEsCero").Value
    Alr_SemaforoVerde = 0
	if(Alr_QueryContadorCasos != "") {
		Alr_QueryContadorCasos = ProcesaBuscadorDeParametros(Alr_QueryContadorCasos)
		var rsContador = AbreTabla(Alr_QueryContadorCasos,1,0)	
	    if (!rsContador.EOF){ 
			Alr_SemaforoVerde = rsContador.Fields.Item(0).Value
		}
		rsContador.Close()
	}
	bMostrar = Alr_SemaforoVerde > 0 	
	if( Alr_MostrarSiEsCero == 1 ) {
		bMostrar = true
	}
	
    if (bMostrar) {
%> 
			<li class="list-group-item<%=iRenglon%>" >
                <span class="pull-right">
                    <i class="<%=rsAvisos.Fields.Item("Alr_Icono").Value%>"></i>
                </span>
                
                <span class="Semaforo" ><span class="badge badge-success"><%=Alr_SemaforoVerde%></span></span>                
				<a href="javascript:CargaAviso(<%=Llaves%>)" title="<%=rsAvisos.Fields.Item("Alr_Ayuda").Value%>" >
                   <%=rsAvisos.Fields.Item("Alr_Letrero").Value%></a>
            </li>
<%
	}
		iRenglon = ""
		rsAvisos.MoveNext() 
	}
	rsAvisos.Close()     
%>

        </ul>
      
<script>

function CargaAviso(alr){
	$("#dvCalendario").hide()
	$("#dvNotificaciones").empty().show()
	$("#dvNotificaciones").load("/pz/agt/Inicio/CargaTareas.asp?Alr_ID="+alr+"&IDUsuario="+$("#IDUsuario").val())
	

}

</script>