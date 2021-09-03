<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
var Usu_ID = Parametro("IDUsuario",-1)

//estatus          
//<span class="badge">92</span>
//<span class="badge badge-success">15</span>
//<span class="badge badge-warning">4</span>
//<span class="badge badge-danger">6</span>
//<span class="badge badge-info">45</span>
//<span class="badge badge-inverse">10</span>

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
    width: auto;
    min-width: 16px;
    text-align: center;
    display: inline-block;
	}

</style> 
        <h2>Avisos y alertas</h2>
        <small>Tareas pendientes por atender</small>
        <ul class="list-group clear-list m-t">
<%  
  	var sSQL = "Select * from dbo.tuf_Usuario_AvisosAlertas(" + Usu_ID + ")"
	var Llaves = "" 
	var Alr_MostrarSiEsCero = 0
	var Alr_SemaforoVerde = 0
	var Alr_SemaforoAmarillo = 0
	var Alr_SemaforoRojo = 0
	var iRenglon = " fist-item"

 	var rsAvisos = AbreTabla(sSQL,1,0)	
	while (!rsAvisos.EOF){ 
	Llaves = "" + rsAvisos.Fields.Item("AlrS_ID").Value
	Llaves += "," + rsAvisos.Fields.Item("Alr_ID").Value
	
	Alr_MostrarSiEsCero  = rsAvisos.Fields.Item("Alr_MostrarSiEsCero").Value
    Alr_SemaforoVerde    = rsAvisos.Fields.Item("Alr_SemaforoVerde").Value
	Alr_SemaforoAmarillo = rsAvisos.Fields.Item("Alr_SemaforoAmarillo").Value
	Alr_SemaforoRojo     = rsAvisos.Fields.Item("Alr_SemaforoRojo").Value
%> 
			<li class="list-group-item<%=iRenglon%>" >
                <span class="pull-right">
                    <i class="<%=rsAvisos.Fields.Item("Alr_Icono").Value%>"></i>
                </span>
                <span class="Semaforo label-success" ><%=Alr_SemaforoVerde%></span> 
                <span class="Semaforo label-warning" ><%=Alr_SemaforoAmarillo%></span>                 
                <span class="Semaforo label-danger"><%=Alr_SemaforoRojo%></span>                 
				<a href="javascript:CargaAviso(<%=Llaves%>)" title="<%=rsAvisos.Fields.Item("Alr_Ayuda").Value%>" >
                   <%=rsAvisos.Fields.Item("Alr_Letrero").Value%></a>
            </li>
<%
		iRenglon = ""
		rsAvisos.MoveNext() 
	}
	rsAvisos.Close()   

%>  
        </ul>

<div style="display:none">
        <ul class="list-group clear-list m-t">
            <li class="list-group-item fist-item">
                <span class="pull-right">
                    <i class="fa fa-table"></i>
                </span>
                <span class="label label-success">7</span> Please contact me
            </li>
            <li class="list-group-item">
                <span class="pull-right">
                    <i class="fa fa-warning"></i>
                </span>
                <span class="label label-info">15</span> Sign a contract
            </li>            
            <li class="list-group-item">
                <span class="pull-right">
                    <i class="fa fa-table"></i>
                </span>
                <span class="label label-info">15</span> Sign a contract
            </li>
            <li class="list-group-item">
                <span class="pull-right">
                    <i class="fa fa-info"></i>
                </span>
                <span class="label label-primary">1,234</span> Open new shop
            </li>
            <li class="list-group-item">
                <span class="pull-right">
                    <i class="fa fa-check"></i>
                </span>
                <span class="label label-default">129</span> Call back to Sylvia
            </li>
            <li class="list-group-item">
                <span class="pull-right">
                   <i class="fa fa-bolt"></i>
                </span>
                <span class="label label-info">3</span> Sign a contract
            </li>
            <li class="list-group-item">
                <span class="pull-right">
                    <i class="fa fa-bullhorn"></i>
                </span>
                <span class="label label-primary">23</span> Open new shop
            </li>
            <li class="list-group-item">
                <span class="pull-right">
                    <i class="fa fa-recicle"></i>
                </span>
                <span class="label label-default">12</span> Call back to Sylvia
            </li>
            <li class="list-group-item">
                <span class="pull-right">
                    <i class="fa fa-pencil"></i>
                </span>
                <span class="label label-primary">9</span> Write a letter to Sandra
            </li>
        </ul>
  </div>      
        
<script>

function CargaAviso(alrs,alr){
	
	$("#Contenido").load("/pz/agt/Inicio/CargaTareas.asp?AlrS_ID="+alrs+"&Alr_ID="+alr+"&IDUsuario="+$("#IDUsuario").val())

}

</script>