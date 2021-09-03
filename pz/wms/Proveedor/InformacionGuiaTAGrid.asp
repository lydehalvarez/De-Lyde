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
   
  var sSQLTraAlm  = "SELECT TA_Folio, Alm_Responsable, Alm_RespTelefono "
      sSQLTraAlm += ",Alm.Alm_Calle + ' ' + Alm.Alm_NumExt + ' ' + Alm.Alm_NumInt + ' , ' + Alm.Alm_Colonia + ' ' + Alm.Alm_Delegacion + ' , '"
			sSQLTraAlm += " + Alm.Alm_Ciudad + ' , ' + EDO.Edo_Nombre + ' , CP ' + Alm.Alm_CP AS DIRECC "
			sSQLTraAlm += ",(SELECT ISNULL(ProG_Recibio,'') PGI FROM Proveedor_Guia PGI "
      sSQLTraAlm += "     WHERE PGI.ProG_NumeroGuia = TA.TA_Guia AND PGI.TA_ID = TA.TA_ID) AS ProG_Recibio "
			sSQLTraAlm += ",(SELECT ISNULL(ProG_Comentario,'') PGI FROM Proveedor_Guia PGII "
      sSQLTraAlm += "     WHERE PGII.ProG_NumeroGuia = TA.TA_Guia AND PGII.TA_ID = TA.TA_ID) AS ProG_Comentario "
      sSQLTraAlm += " FROM TransferenciaAlmacen TA, Almacen ALM, Cat_estado EDO "
      sSQLTraAlm += " WHERE TA.TA_End_Warehouse_ID = ALM.Alm_ID AND ALM.Edo_ID = EDO.Edo_ID "
      sSQLTraAlm += " AND TA.TA_ID IN (SELECT PG.TA_ID FROM Proveedor_Guia PG "
      sSQLTraAlm += "         WHERE PG.Prov_ID = "+iProvID+" AND PG.ProG_NumeroGuia = '"+sProGNumeroGuia+"') " 
      sSQLTraAlm += " ORDER BY TA_FechaRegistro "
   
      if(bIQon4Web){ Response.Write("sSQLTraAlm: " + sSQLTraAlm + "<br>") }       
   
%>

  
<div class="table-responsive">
  <table class="table table-condensed table-hover" width="100%">
    <thead>
      <tr>
        <th width="2%" class="text-center">#</th>
        <th width="11%" class="text-left">Folio</th>
        <th width="19%" class="text-left">Direcci&oacute;n</th>
        <th width="19%" class="text-left">Recibe</th>
        <th width="17%" class="text-left">Tel&eacute;fono</th>
        <th width="16%" class="text-left">Recibi&oacute;</th>
        <th width="16%" class="text-left">Comentario</th>
      </tr>
      </thead>
      <tbody>
      <%
        var iRenglon = 0
        var rsTA = AbreTabla(sSQLTraAlm,1,0)

             while (!rsTA.EOF){
                 iRenglon++             
      %>
      <tr>
        <td class="text-center"><%=iRenglon%></td>
        <td class="text-left"><a href="#" class="text-navy"><%=rsTA.Fields.Item("TA_Folio").Value%></a></td>
        <td class="text-left"><div class="small m-t-xs"><%=rsTA.Fields.Item("DIRECC").Value%></div></td>
        <td class="text-left"><div class="small m-t-xs"><%=rsTA.Fields.Item("Alm_Responsable").Value%></div></td>
        <td class="text-left"><div class="small m-t-xs"><%=rsTA.Fields.Item("Alm_RespTelefono").Value%></div></td>
        <td class="text-left"><div class="small m-t-xs"><%=rsTA.Fields.Item("ProG_Recibio").Value%></div></td>        
        <td class="text-left"><div class="small m-t-xs"><%=rsTA.Fields.Item("ProG_Comentario").Value%></div></td>  
      </tr>
      <%
            rsTA.MoveNext() 
          }
        rsTA.Close()   
      %>        
      </tbody>
    
  </table>
</div>  
<%
// =============================================
// Author: JD
// Create date: 15/04/2021
// Description:	Caída de datos de la(s) Transferencia de la Guía seleccionada
// ----- Modify ------
// Author: 
// Modify date: dd/mm/aaaa
// Description:
// =============================================   
%>   