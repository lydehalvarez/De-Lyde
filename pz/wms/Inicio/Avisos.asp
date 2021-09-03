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

//Catalogo general 302
//1	Alerta por BPM           Es lanzada por alguna decisión tomada, despues de tomar la decisión
//2	Alerta por query         Es lanzada por alguna condicion que se cumpla, a la consulta y que cumpla
//3	Alerta por seguimiento   Es un consecutivo de seguimientos, al cumplir la fecha y hora  (calendario)

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



<!--        <div class="panel">
            <div class="panel-heading">
              <h2 class="panel-title">
                 <a data-toggle="collapse" data-parent="#accordion" href="#collapse">
-->                    <h2>Avisos y alertas</h2>
                            <small>Tareas pendientes por atender</small>
<!--                    </a>
              </h2>
              <div id="collapse" class="collapse">
-->                <ul class="list-group clear-list m-t">      
<%  
// primera parte avisos programados por la accion de un proceso y que 
// estan registrados en la tabla de BPM_Seguimiento
// En esta version no usaremos semaforo

	var Llaves = "" 
	var Alr_MostrarSiEsCero = 0
	var Alr_SemaforoVerde = 0
	var Alr_SemaforoAmarillo = 0
	var Alr_SemaforoRojo = 0
	var iRenglon = " fist-item"
	var bMostrar = true
 	
  	var sSQL = "Select * from dbo.tuf_BPM_AvisosAlertas(" + Usu_ID + ", 1 )"
	
//  	var sSQL = "Select COUNT(S.Alr_ID) as Alertas, P.Alr_ID, P.Alr_Letrero "
//		sSQL += ", S.Alr_MostrarSiEsCero, S.Alr_SemaforoAmarillo " 
//		sSQL += ", S.Alr_SemaforoRojo, S.Alr_QueryContadorCasos "
//		sSQL += ", P.Alr_Icono,P.Alr_Ayuda "
//		sSQL += " FROM dbo.tuf_BPM_AvisosAlertas(" + Usu_ID + ") S inner join Alertamientos P  "
//		sSQL += " ON S.Alr_ID = P.Alr_ID AND P.Alr_Habilitada = 1 "
//		sSQL += " GROUP BY P.Alr_ID, P.Alr_Letrero,S.Alr_MostrarSiEsCero "
//		sSQL += ", S.Alr_SemaforoAmarillo "
//		sSQL += ", S.Alr_SemaforoRojo, S.Alr_QueryContadorCasos "
//		sSQL += ", P.Alr_Icono,P.Alr_Ayuda "
	
		
 	var rsAvisos = AbreTabla(sSQL,1,0)	
	while (!rsAvisos.EOF){ 
		Llaves = "" + rsAvisos.Fields.Item("Alr_ID").Value
	
//	Alr_MostrarSiEsCero  = rsAvisos.Fields.Item("Alr_MostrarSiEsCero").Value
//  Alr_SemaforoVerde    = rsAvisos.Fields.Item("Alr_SemaforoVerde").Value
//	Alr_SemaforoAmarillo = rsAvisos.Fields.Item("Alr_SemaforoAmarillo").Value
//	Alr_SemaforoRojo     = rsAvisos.Fields.Item("Alr_SemaforoRojo").Value
%> 
			<li class="list-group-item<%=iRenglon%>" >
                <span class="pull-right">
                    <i class="<%=rsAvisos.Fields.Item("Alr_Icono").Value%>"></i>
                </span>
                
                <span class="Semaforo"><span class="badge badge-success"><%=rsAvisos.Fields.Item("Alr_NumeroDeCasos").Value%></span></span> 
                <a href="javascript:CargaAviso(<%=Llaves%>)"  title="<%=rsAvisos.Fields.Item("Alr_Ayuda").Value%>">
                   <%=rsAvisos.Fields.Item("Alr_Letrero").Value%></a>               
            </li>
<%
		iRenglon = ""
		rsAvisos.MoveNext() 
	}
	rsAvisos.Close()   




// Segunda parte, los avisos extraidos por un query

//  	var sSQL = "SELECT a.AlrS_ID, a.Alr_ID, Alr_Descripcion, Alr_Letrero, Alr_Ayuda, Alr_Icono "
//		sSQL += ", ISNULL(Alr_QueryContadorCasos,'') as Casos, Alr_QueryDatos, Alr_MostrarSiEsCero "
//		sSQL += " FROM Alertamientos a, Usuario_Alertamientos u "
//		sSQL += " WHERE a.AlrS_ID = u.AlrS_ID AND a.Alr_ID = u.Alr_ID "
//		sSQL += " AND Alr_EsParaPantalla = 1 "
//		sSQL += " AND u.Alr_Pantalla = 1 "
//		sSQL += " AND u.Alr_Habilitado = 1 "
//		sSQL += " AND Alr_Habilitada = 1 "
//		sSQL += " AND Alr_VisibleAdmin = 1 AND Alr_TipoCG302 = 2 "		
//		sSQL += " AND u.ID_Usuario = " + Usu_ID
		
var sSQL = "Select * from dbo.tuf_BPM_AvisosAlertas(" + Usu_ID + ", 2 )"
//Response.Write("<br>" + sSQL)
	var iRenglon = " fist-item"
	var bMostrar = true

 	var rsAvisos = AbreTabla(sSQL,1,0)	
	while (!rsAvisos.EOF){ 
		Llaves = "" + rsAvisos.Fields.Item("Alr_ID").Value
		Alr_QueryContadorCasos = rsAvisos.Fields.Item("Alr_QueryContadorCasos").Value
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
                
                <span class="Semaforo"><span class="badge badge-success"><%=Alr_SemaforoVerde%></span></span>                
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
<!--         </div>
      </div>
   </div>
-->      
<script>

function CargaAviso(alr){
	$("#dvCalendario").hide()
	$("#dvNotificaciones").empty().show()
	$("#dvNotificaciones").load("/pz/wms/Inicio/CargaTareas.asp?Alr_ID="+alr+"&IDUsuario="+$("#IDUsuario").val())
	

}

</script>