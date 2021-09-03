<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

    var bDebug = true
    var iRegistros = 0
   
    var iEqp_ID = utf8_decode(Parametro("BusEqp_ID",-1))   
    var iAgt_ID = utf8_decode(Parametro("BusAgt_ID",-1))

    var sCliNombre = utf8_decode(Parametro("BusCli_Nombre",""))
    var sCliRFC = utf8_decode(Parametro("BusCli_RFC",""))   
    var iBusCot_EstatusCG93 = utf8_decode(Parametro("BusCot_EstatusCG93",-1))   
   
    var sCondCot = ""  
   
    var sSQL  = " SELECT * "
        sSQL += " ,dbo.fn_CatGral_DameDato(93,Cot_EstatusCG93) as Estatus "
        sSQL += " ,dbo.fn_CatGral_DameTexto(93,Cot_EstatusCG93) as EstatusEstilo "
        sSQL += " FROM Cotizacion "   

   
var sSQL  = " SELECT CO.Cli_ID, (SELECT C.Cli_Nombre FROM Cliente C WHERE C.Cli_ID = CO.Cli_ID) AS ACLIENTE "
    sSQL += ", CO.Cot_ID, CO.Cot_Nombre, CO.Cot_Descripcion, CO.Cot_FechaTerminada, CONVERT(NVARCHAR(20),CO.Cot_FechaTerminada,103) AS FECHATERMINADA "
    sSQL += ", CO.Cot_FechaPresentada, CONVERT(NVARCHAR(20), CO.Cot_FechaPresentada,103) AS FECHAPRESENTADA "
    sSQL += ", CO.Cot_FechaRegistro, CONVERT(NVARCHAR(20), CO.Cot_FechaRegistro,103) AS FECHAREGISTRO "
    sSQL += ", CONVERT(NVARCHAR(150), CO.Cot_FechaRegistro,104) AS FECHAFORMATO "
    sSQL += ", CO.Cot_EstatusCG93, dbo.fn_CatGral_DameDato(93, CO.Cot_EstatusCG93) AS ESTATUS "
    sSQL += ", dbo.fn_CatGral_DameTexto(93, CO.Cot_EstatusCG93) AS ESTATUSESTILO "
    sSQL += ", CO.Des_ID, (SELECT D.Des_Nombre FROM Desarrollo D WHERE D.Des_ID = CO.Des_ID) AS DESARROLLO "
    sSQL += ", CO.Pro_ID, (SELECT Dp.Pro_Nombre FROM Desarrollo_Producto DP WHERE DP.Des_ID = CO.Des_ID AND DP.Pro_ID = CO.Pro_ID) AS PRODUCTO "
    sSQL += ", CO.Cot_ProximaCita, CONVERT(NVARCHAR(20), CO.Cot_ProximaCita,103) AS FECHAPROXCITA "
    sSQL += ", CONVERT(NVARCHAR(150), CO.Cot_ProximaCita,104) AS FECHAPROXCITAFOR "
    sSQL += ", dbo.fn_CatGral_DameDato(94, CO.Cot_TipoEventoCG94) AS TIPOEVENTO "
    sSQL += ", (SELECT AV.Agt_Nombre FROM CRM_AgentesDeVentas AV WHERE AV.Agt_ID = CO.Cot_Atendiendo_Usu_ID1) AS QUIEN_ATIENDE "
    sSQL += "FROM CRM_Cotizacion CO "
   
   
    if (iEqp_ID > -1) {
        if (sCondCot != "") { sCondCot += " AND " }
        sCondCot += " CO.Eqp_ID = "+ iEqp_ID
    }   
    
    if (iAgt_ID > -1) {
        if (sCondCot != "") { sCondCot += " AND " }
        sCondCot += " CO.Cot_Asesor_Usu_ID = "+ iAgt_ID
    }   
    
    if (sCliNombre != "") {
        if ( sCondCot != "") { sCondCot += " AND " }
        //sCondCot += " CO.Cli_Nombre LIKE '%"+ sCliNombre +"%'"
        sCondCot += " CO.Cli_ID IN (SELECT CLI.Cli_ID FROM Cliente CLI WHERE CLI.Cli_Nombre LIKE '%"+ sCliNombre +"%')"
    }

    if (sCliRFC != "") {
        if ( sCondCot != "") { sCondCot += " AND " }
        //sCondCot += " CO.Cli_RFC LIKE '%"+ sCliRFC +"%'"
        sCondCot += " CO.Cli_ID IN (SELECT CLI.Cli_ID FROM Cliente CLI WHERE CLI.Cli_RFC LIKE '%"+ sCliRFC +"%')"
    }
    
    if (iBusCot_EstatusCG93 > -1) {
        if (sCondCot != "") { sCondCot += " AND " }
        sCondCot += " CO.Cot_EstatusCG93 = "+ iBusCot_EstatusCG93
    }    

    if (sCondCot != "") {
	    sSQL += " WHERE " + sCondCot
	}   
    
    //1	En proceso     | Warning
    //2	Terminada      | Default
    //3	Revisión       | Primary
    //4	Presentada     | Default
    //5	En seguimiento | Info
    //6	Aceptada       | Success
    //7	Rechazada      | Danger
    //8	Cambio         | Info  
   
%>
<div class="ibox-title">
    <h5><i class="fa fa fa-black-tie"></i><!--Grupo:&nbsp;Asesor:--></h5>
    <div class="ibox-tools">
        <a href="" class="btn btn-primary btn-xs"><i class="fa fa-plus"> </i> Hacer una nueva cotizaci&oacute;n</a>
    </div>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
        var ESTATUSESTILO = ""   
        var rsCotizacion = AbreTabla(sSQL,1,0)
        while (!rsCotizacion.EOF){
            Llaves = rsCotizacion.Fields.Item("Cli_ID").Value
            Llaves += "," + rsCotizacion.Fields.Item("Cot_ID").Value
            ESTATUSESTILO = rsCotizacion.Fields.Item("ESTATUSESTILO").Value             
        %>    
      <tr>
        <td class="project-status">
            <span class="label label-<%=ESTATUSESTILO%> text-center"><%=rsCotizacion.Fields.Item("ESTATUS").Value%></span>
        </td>
        <td class="project-title">
            <a href="project_detail.html"><%=rsCotizacion.Fields.Item("ACLIENTE").Value%></a>
            <br/>
            <small>Atiende: <%=rsCotizacion.Fields.Item("QUIEN_ATIENDE").Value%></small>
        </td>
        <td class="project-title">
            <a href="project_detail.html"><%=rsCotizacion.Fields.Item("Cot_Nombre").Value%></a>
            <br/>
            <small>Creada <%=rsCotizacion.Fields.Item("FECHAFORMATO").Value%></small>
        </td>
        <td class="project-title">
            <a href="project_detail.html"><%=rsCotizacion.Fields.Item("DESARROLLO").Value%></a>
            <br/>
            <small> <%=rsCotizacion.Fields.Item("PRODUCTO").Value%></small>
        </td>
        <td class="project-title">
            <a href="project_detail.html">Tipo de Evento - Pr&oacute;xima cita</a>
            <br/>
            <small> <%=rsCotizacion.Fields.Item("TIPOEVENTO").Value%> - <%=rsCotizacion.Fields.Item("FECHAPROXCITAFOR").Value%></small>
        </td>
        <!--td class="project-completion" width="82">Grupo<br>
        Agente</td>
        <td class="project-completion" width="90">Fecha contacto 00/00/00<br>
        Ultimo contacto 00/0/00</td>
        <td class="project-completion" width="90">
          <small>Avance: 48%</small>
          <div class="progress progress-mini">
            <div class="progress-bar" style="width: 48%;"></div>
          </div>
        </td-->
        <!--td class="project-people" width="185">
          <a href=""><img alt="image" class="img-circle" src="/Template/inspina/img/a3.jpg"></a> <a href=""><img alt="image" class="img-circle" src="/Template/inspina/img/a1.jpg"></a> <a href=""><img alt="image" class="img-circle" src="/Template/inspina/img/a2.jpg"></a> <a href=""><img alt="image" class="img-circle" src="/Template/inspina/img/a4.jpg"></a> <a href=""><img alt="image" class="img-circle" src="/Template/inspina/img/a5.jpg"></a>
        </td-->
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargaCliente(<%=Llaves%>)"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsCotizacion.MoveNext() 
            }
        rsCotizacion.Close()   
        %>       
    </tbody>
  </table>
</div>
<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    
    
    
    
    
    
});
    
    
function CargaCliente(f){
		
    $("#Cli_ID").val(f);
    CambiaSiguienteVentana();
			
}            
            
            
            
            
            
            
            
            
            
            

    
    
    
    
    
    
</script>    
    