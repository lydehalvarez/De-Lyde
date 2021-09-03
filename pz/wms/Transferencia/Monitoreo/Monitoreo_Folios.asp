<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->

<%
	var Fecha = Parametro("Fecha",-1)
	var Pendiente = Parametro("Pendiente",-1)
	var Packing = Parametro("Packing",-1)
	var Shipping = Parametro("Shipping",-1)
	var Transito = Parametro("Transito",-1)
	var Entregado = Parametro("Entregado",-1)
	var Devuelto = Parametro("Devuelto",-1)
	var PendienteNE = Parametro("PendienteNE",-1)
	var Cancelado = Parametro("Cancelado",-1)
	
	var Cli_ID = Parametro("Cli_ID",-1)	
		
	var Datos = new Array("Pendiente de surtir","Packing","Shipping","Transito","Entregado","Devuelto","PendienteNE","Cancelado");
	var DatosNum = new Array(1,3,4,5,10,16,19,11);
	var DatosActuales = new Array(Pendiente,Packing,Shipping,Transito,Entregado,Devuelto,PendienteNE,Cancelado);

%>
<link href="/Template/inspina/css/plugins/iCheck/blue.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/iCheck/red.css" rel="stylesheet">

<style>
.bg-completado{
	background:#3F9	
}


</style>

<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
<%	
for(var i = 0; i < Datos.length; i++){
	if(DatosActuales[i] != 0){
%>

  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse<%=i%>" aria-controls="collapseOne">
          <div class="panel-title">
              <div>
                <h3><%=Datos[i]%>&nbsp;<small>Cantidad Actual: <%=DatosActuales[i]%></small></h3>
                <div class="text-right"><a class="btn btn-white btn-sm" onclick='Monitoreo.Exportar(<%=DatosNum[i]%>,"<%=Fecha%>")'><i class="fa fa-file"></i> Exportar</a></div>              
              </div>
              
          </div>
        </a>
    </div>
    <div id="collapse<%=i%>" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">
      	<div class="table-responsive">
                        <table class="table">
                          <thead> 
                            <tr>
                              <th scope="col">#</th>
                              <th scope="col">Folio</th>
                              <th scope="col">Numero Pedido</th>
                              <th scope="col">Estatus</th>
                              <th scope="col">Transportista</th>
                              <th scope="col">Guia</th>
                              <%if(DatosNum[i] >= 5){%>
                              <th scope="col">Manifiesto</th>
                              <th scope="col">Remision</th>
                              <%}%>
                              <%if(DatosNum[i] == 5){%>
                              <th scope="col">D&iacute;as en transito</th>
                              <%}%>
                              <%if(DatosNum[i] >10){%>
                              <th scope="col">Entrada</th>
                              <%}%>
                              
                              <th scope="col">Ver</th>
                            </tr>
                          </thead>
                          <tbody>
					<%
					var sSQLRTI = "SELECT  TA_Folio,TA_ID,Cli_ID,TA_FolioCliente,TA_Transportista,TA_Guia,Cat_Nombre as Estatus "
						sSQLRTI += " , ISNULL((SELECT Man_Folio FROM Manifiesto_Salida WHERE Man_ID = a.Man_ID),'N/A') as Manifiesto "
						sSQLRTI += " , (SELECT TA_FolioRemision FROM TransferenciaAlmacen_FoliosEKT WHERE TAF_ID = 1 AND TA_ID = a.TA_ID) Remision "
						sSQLRTI += " , (SELECT TAF_FolioEntrada FROM TransferenciaAlmacen_FoliosEKT WHERE TAF_ID = 1 AND TA_ID = a.TA_ID) Entrada "
						sSQLRTI += " , ISNULL((SELECT DATEDIFF(dd,[TA_FechaRegistro],getdate()) FROM TransferenciaAlmacen_Historico WHERE TA_EstatusCG51 = 5 AND TA_ID = a.TA_ID),0) DiasTransito "
						sSQLRTI += " FROM TransferenciaAlmacen a, Cat_Catalogo b "
						sSQLRTI += " WHERE TA_EstatusCG51 = "+DatosNum[i]
						sSQLRTI += " AND Cli_ID = "+Cli_ID
						sSQLRTI += " AND Sec_ID = 51 "
						sSQLRTI += " AND Cat_ID = a.TA_EstatusCG51 "
						sSQLRTI += " AND CONVERT(date, TA_FechaRegistro, 120) = '"+Fecha+"'"
						sSQLRTI += " ORDER BY DiasTransito DESC "
						
					var rsRTI = AbreTabla(sSQLRTI,1,0)

                    var Renglon = 0
					var TA_ID = -1
					var Estatus = "";
					var Fondo = "";
					var FechaSalida = -1
					while(!rsRTI.EOF){
						TA_ID = rsRTI.Fields.Item("TA_ID").Value 
						Estatus = rsRTI.Fields.Item("Estatus").Value
						DiasTransito = rsRTI.Fields.Item("DiasTransito").Value
						if(DatosNum[i] == 5){
							if(DiasTransito > 8){
								Fondo = "bg-danger"
							}else if(DiasTransito > 5){
								Fondo = "bg-warning"
							}else if(DiasTransito > 3){
								Fondo = "bg-primary"
							}else{
								Fondo = ""
							}
						}
                        %>
                        
                            <tr class="<%=Fondo%>" id="trTA_<%=TA_ID%>">
                              <th scope="row"><%=++Renglon%></th>
                              <td><%=rsRTI.Fields.Item("TA_Folio").Value%></td>
                              <td><%=rsRTI.Fields.Item("TA_FolioCliente").Value%></td>
                              <td><%=Estatus%></td>
                              <td><%=rsRTI.Fields.Item("TA_Transportista").Value%></td>
                              <td><%=rsRTI.Fields.Item("TA_Guia").Value%></td>
                              <%if(DatosNum[i] >= 5){%>
                              <td><%=rsRTI.Fields.Item("Manifiesto").Value%></td>
                              <td><%=rsRTI.Fields.Item("Remision").Value%></td>
                              <%}%>
                              <%if(DatosNum[i] == 5){%>
                              <td><%=rsRTI.Fields.Item("DiasTransito").Value%></td>
                              <%}%>
                              <%if(DatosNum[i] >10){%>
                              <td><%=rsRTI.Fields.Item("Entrada").Value%></td>
                              <%}%>
                              <td><a class="btn btn-white btn-sm" style="color:#000" onclick="Monitoreo.Ficha(<%=TA_ID%>,<%=rsRTI.Fields.Item("Cli_ID").Value%>)" data-toggle="modal" data-target="#ModalFicha"><i class="fa fa-eye"></i> Ver</a></td>
                            </tr>
                        <%
                        rsRTI.MoveNext() 
                    }
                    rsRTI.Close()   
                    %>
                </tbody>
            </table>     
         </div>                              
      </div>
    </div>
</div>
<%
	}	
}
%>