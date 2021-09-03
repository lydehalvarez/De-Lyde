<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

  var bIQ4Web = false 

  var iUbi_ID = Parametro("DestUbi_ID",-1)
  var sDestUbi_Nombre = Parametro("DestUbi_Nombre","")
  var bLeyVacio = false
   
  if(bIQ4Web){ 
    Response.Write("Ubicacion: " + iUbi_ID+"<br>")
  }
    
  var sNOMUBICA = BuscaSoloUnDato("Ubi_Nombre","Ubicacion","Ubi_ID="+iUbi_ID,"",0)
   
  var sSQL = "SELECT P.Pt_ID, P.Pt_LPN, P.Pt_Cantidad_Actual "
      sSQL += ",P.Pro_ID "
      sSQL += ",(SELECT PRO.Pro_Nombre FROM Producto PRO WHERE PRO.Pro_ID = P.Pro_ID) AS PRODUCTO "
      sSQL += ",P.Pt_SKU "
      sSQL += ",P.Ubi_ID,(SELECT UBI.Ubi_Nombre FROM Ubicacion UBI WHERE UBI.Ubi_ID = P.Ubi_ID) AS UBICACION "
      sSQL += "FROM Pallet P WHERE P.Ubi_id = " + iUbi_ID
      sSQL += " AND P.Pt_Cantidad_Actual > 0 AND Pro_ID > 0"
      sSQL += " ORDER BY P.Pt_LPN ASC"   

    if(bIQ4Web){ Response.Write(sSQL) }

  if(iUbi_ID > -1){     
   
    var rsLPNs = AbreTabla(sSQL,1,0)
    bLeyVacio = !rsLPNs.EOF
%>
  
<ul class="sortable-list agile-list" id="ulListadoPallets">

<div class="ibox float-e-margins">
    <% if (bLeyVacio){ %>
    <div class="ibox-title">
      <h4 class="text-navy">Pallets encontrados en la Ubicaci&oacute;n:&nbsp;<i class="fa fa-map-marker"></i>&nbsp;<a title="<%=iUbi_ID%>" data-clipboard-text="<%=sNOMUBICA%>" class="textCopy tooltip-demo"><%=sNOMUBICA%></a></h4>
      <div class="ibox-tools">
        <a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
      </div>
    </div>
    <% } %>  
    <div class="ibox-content">
      <div class="feed-activity-list">  
  <%
    rsLPNs = AbreTabla(sSQL,1,0)
		while(!rsLPNs.EOF){
  %>
  <div class="feed-element" data-ptid="<%=rsLPNs.Fields.Item("Pt_ID").Value%>">
      <div class="media-body">
        <small class="pull-right"><h5><i class="text-navy">CANTIDAD:</i><abbr> <%=rsLPNs.Fields.Item("Pt_Cantidad_Actual").Value%></abbr></h5></small>
        <strong><h5 class="text-success"><i class="fa fa-codepen"></i> LPN:&nbsp;&nbsp;<a title="<%=rsLPNs.Fields.Item("Pt_ID").Value%>" data-clipboard-text="<%=rsLPNs.Fields.Item("Pt_LPN").Value%>" class="textCopy"><%=rsLPNs.Fields.Item("Pt_LPN").Value%></a></h5></strong><h5><i class="fa fa-dropbox text-navy"> PRODUCTO:</i><cite> <a title="<%=rsLPNs.Fields.Item("Pro_ID").Value%>" data-clipboard-text="<%=rsLPNs.Fields.Item("Pt_SKU").Value%>" class="textCopy"><%=rsLPNs.Fields.Item("Pt_SKU").Value%></a> <%=rsLPNs.Fields.Item("PRODUCTO").Value%></cite></h5>
      </div>
  </div>    
<% 
      rsLPNs.MoveNext()
      } 
 
%>
    </div>      
  </div>
</div>
<%
if (!bLeyVacio){
%>        
<div class="row">
  <div class="col-lg-12">
    <div class="panel-collapse" id="faqextra">
      <div class="faq-answer">
        <p class="text-center">
          <a class="faq-question" href="#">No se encontraron pallets en la ubicaci&oacute;n&nbsp;seleccionada.</a>
        </p>
      </div>
    </div>
  </div>
</div>  
<%
}
rsLPNs.Close()   
%>   
</ul>
<script src="/Template/inspina/js/inspinia.js"></script>   
<% } %>  
  
  