<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
  var bIQon4Web = false

  //Manejo de las Transferencias
  //Mostrar todos los tras
  
  var iProvID = Parametro("Prov_ID",-1)
  var iProGID = Parametro("ProG_ID",-1)
  var sCondProvGuia = " Prov_ID = " + iProvID + " AND ProG_ID = " + iProGID
  
  //Num. de Guía
  var sProGNumeroGuia = BuscaSoloUnDato("ProG_NumeroGuia","Proveedor_Guia",sCondProvGuia,"",0)
  
  if(bIQon4Web){ Response.Write("ProG_NumeroGuia: " + sProGNumeroGuia + "<br>") }

  var sOrdVta = "SELECT OV.OV_Folio "
      sOrdVta += ",OV.OV_CUSTOMER_NAME ,OV.OV_Calle + ' ' + OV.OV_NumeroExterior + ' ' + OV.OV_NumeroInterior + ' , '"
      sOrdVta += " + OV.OV_Colonia + ' ' + OV.OV_Delegacion + ' , ' + OV.OV_Ciudad + ' , ' "
      sOrdVta += " + OV.OV_Estado + ' , CP ' + OV.OV_CP AS DIRECC "
      sOrdVta += ",OV.OV_CUSTOMER_NAME AS Responsable "
      sOrdVta += ",OV.OV_Telefono "
      sOrdVta += ",(SELECT ISNULL(ProG_Recibio,'') PGI FROM Proveedor_Guia PGI "
      sOrdVta += "     WHERE PGI.ProG_NumeroGuia = OV.OV_TRACKING_NUMBER AND PGI.OV_ID = OV.OV_ID) AS ProG_Recibio "
      sOrdVta += ",(SELECT ISNULL(ProG_Comentario,'') PGI FROM Proveedor_Guia PGI "
      sOrdVta += "     WHERE PGI.ProG_NumeroGuia = OV.OV_TRACKING_NUMBER AND PGI.OV_ID = OV.OV_ID) AS ProG_Comentario "
      sOrdVta += " FROM Orden_Venta OV "
      sOrdVta += "WHERE OV.OV_ID IN (SELECT PG.OV_ID FROM Proveedor_Guia PG WHERE PG.Prov_ID = " + iProvID
      sOrdVta += " AND PG.ProG_NumeroGuia = '"+sProGNumeroGuia+"')" 
      sOrdVta += " ORDER BY OV.OV_FechaRegistro"
   
      if(bIQon4Web){ Response.Write("sOrdVta: " + sOrdVta + "<br>") }       
      //Response.End()     
%>

  
<div class="table-responsive">
  <table class="table table-condensed table-hover" width="100%">
    <thead>
      <tr>
        <th width="2%" class="text-center">#</th>
        <th width="12%" class="text-left">Folio</th>
        <th width="23%" class="text-left">Direcci&oacute;n</th>
        <th width="15%" class="text-left">Recibe</th>
        <th width="14%" class="text-left">Tel&eacute;fono</th>
        <th width="17%" class="text-left">Recibi&oacute;</th>
        <th width="17%" class="text-left">Comentario</th>
      </tr>
      </thead>
      <tbody>
      <%
        var iRenglon = 0
        var rsOV = AbreTabla(sOrdVta,1,0)

             while (!rsOV.EOF){
                 iRenglon++             
      %>
      <tr>
        <td class="text-center"><%=iRenglon%></td>
        <td class="text-left"><a href="#" class="text-navy"><%=rsOV.Fields.Item("OV_Folio").Value%></a></td>
        <td class="text-left"><div class="small m-t-xs"><%=rsOV.Fields.Item("DIRECC").Value%></div></td>
        <td class="text-left"><div class="small m-t-xs"><%=rsOV.Fields.Item("Responsable").Value%></div></td>
        <td class="text-left"><div class="small m-t-xs"><%=rsOV.Fields.Item("OV_Telefono").Value%></div></td>
        <td class="text-left"><div class="small m-t-xs"><%=rsOV.Fields.Item("ProG_Recibio").Value%></div></td>        
        <td class="text-left"><div class="small m-t-xs"><%=rsOV.Fields.Item("ProG_Comentario").Value%></div></td>  
      </tr>
      <%
            rsOV.MoveNext() 
          }
        rsOV.Close()   
      %>        
      </tbody>
    
  </table>
</div>  
<%
// =============================================
// Author: JD
// Create date: 15/04/2021
// Description:	Caída de datos de la(s) OrdenesDeVenta de la Guía seleccionada
// ----- Modify ------
// Author: 
// Modify date: dd/mm/aaaa
// Description:
// =============================================   
%>   