<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%	
	
var Prov_ID = Parametro("Prov_ID",-1)
var Pag_ID = Parametro("Pag_ID",-1)
var CFDI_ID = Parametro("CFDI_ID",-1)
var fl = Parametro("fl","")
var Cancelado = Parametro("cld",0)

var Con_ID = -1
var Cob_ID = -1
var Prov_RFC = ""
 
var NombreProveedor = ""
var EsXML = false
  
var sSQL  = " SELECT Prov_ID, Prov_Siglas,Prov_RazonSocial,Prov_Nombre, Prov_RFC " 
    sSQL += " FROM Proveedor " 
    sSQL += " WHERE Prov_ID = " + Prov_ID

var rsProveedor = AbreTabla(sSQL,1,0)

if (!rsProveedor.EOF){
	NombreProveedor = rsProveedor.Fields.Item("Prov_Siglas").Value
	Prov_RFC = rsProveedor.Fields.Item("Prov_RFC").Value
	if (rsProveedor.Fields.Item("Prov_RazonSocial").Value != "") {
		NombreProveedor += " - " + rsProveedor.Fields.Item("Prov_RazonSocial").Value
	}
	if (rsProveedor.Fields.Item("Prov_Nombre").Value != "") {
		NombreProveedor += " - " + rsProveedor.Fields.Item("Prov_Nombre").Value
	}	
}
rsProveedor.Close() 

var sSQL  = " select Con_ID, Cob_ID "
	sSQL += " from Fn_Pago_Contrato "
	sSQL += " where Prov_ID = " + Prov_ID
	sSQL += " and Pag_ID = " + Pag_ID

var rsContrato = AbreTabla(sSQL,1,0)
  if (!rsContrato.EOF){
	  Con_ID = rsContrato.Fields.Item("Con_ID").Value
      Cob_ID = rsContrato.Fields.Item("Cob_ID").Value
  }
 rsContrato.Close() 

var EstatusCSS = "" 
var Con_EstatusCG86 = 0
var Con_Folio = ""
 
var sSQL  = " SELECT dbo.fn_CatGral_DameDato(86,Con_EstatusCG86) as Estatus "
    sSQL += " , Con_Folio, Con_EstatusCG86 "
	sSQL += " FROM Fn_Contrato " 
	sSQL += " WHERE Prov_ID = " + Prov_ID
	sSQL += " AND Con_ID = " + Con_ID 
 
var rsContrato = AbreTabla(sSQL,1,0)
  if (!rsContrato.EOF){
	  Estatus = rsContrato.Fields.Item("Estatus").Value
	  Con_EstatusCG86 = rsContrato.Fields.Item("Con_EstatusCG86").Value	  
	  Con_Folio = rsContrato.Fields.Item("Con_Folio").Value
	  if(Con_EstatusCG86 == 1 ) {
	  	EstatusCSS = " label-primary "
      }
	  if(Con_EstatusCG86 == 2 ) {
	  	EstatusCSS = " label-success "
      } 	
	  if(Con_EstatusCG86 == 3 ) {
	  	EstatusCSS = " label-plain "
      }	  
  }
 rsContrato.Close() 
 
var Cob_Folio = ""
var Cob_Fecha = ""

var sSQL  = " SELECT Cob_Folio, Cob_Concepto, Cob_Observaciones "
	sSQL += " , Cob_Capital, Cob_Interes, Cob_IVA, Cob_RetencionISR "
	sSQL += " , Cob_Amortizacion, Cob_Pago, Cob_Aplicado, Cob_Referencia, Cob_FechaPago "
	sSQL += " , CONVERT(NVARCHAR(20),Cob_Fecha,103) as Fecha "
	sSQL += " FROM Fn_Contrato_Cobranza " 
	sSQL += " WHERE Prov_ID = " + Prov_ID
	sSQL += " AND Con_ID = " + Con_ID
	sSQL += " AND Cob_ID = " + Cob_ID		  
  
var rsPago = AbreTabla(sSQL,1,0)
if (!rsPago.EOF){
   Cob_Folio = rsPago.Fields.Item("Cob_Folio").Value  
   Cob_Fecha = rsPago.Fields.Item("Fecha").Value
}
rsPago.Close()  
%>
<style type="text/css">
	.espaciobtn{
		margin:0px 15px;
	}

	.textarea {
		width: 100%;
		height: auto;
		overflow-x: scroll;
		overflow-y: scroll;
		display: block;
		border: 1px solid black;
		padding: 5px;
		margin: 5px;
	}
	.formatted {
		width: 100%;
		height: auto;
		overflow-x: scroll;
		overflow-y: scroll;
		display: block;
		border: 1px solid black;
		padding: 5px;
		margin: 5px;
	}
	
</style>
<%
var sRuta = "/Media/fnd/Pagos/CFDI/" + Prov_RFC + "/"
var Doc_Nombre = "" + fl
var Cargado = 0
var sObs = ""
var sTitulo = ""

%>
 <div class="row">             
	<div class="ibox">
		<div class="ibox-content">
	    	<div class="row">
                <div class="col-lg-12">
                    <div class="m-b-md">
                         <h2><%=NombreProveedor%></h2>
                    </div>
                    <dl class="dl-horizontal">
                        <dt>Estatus:</dt> <dd><span class="label <%=EstatusCSS%>"><%=Estatus%></span></dd>
                    </dl>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <dl class="dl-horizontal">
                        <dt>Folio:</dt> <dd><%=Con_Folio%></dd>                      
                        <dt>Pago No:</dt> <dd><%=Cob_Folio%></dd>
                        <dt>Fecha de vencimiento:</dt> <dd><%=Cob_Fecha%></dd>
                        <dt>Nombre del archivo:</dt> <dd><%=Doc_Nombre%></dd>
                          <% if(Cancelado == 1) {  %>
                             <dt>Estatus:</dt> <dd style="color:red;font-weight:bolder;">Cancelado</dd>
                          <% }  %>
                    </dl>
                </div>              
            </div>
            <div class="row">
				<div class="col-lg-12" style="text-align:center">
                   
<%   
    
   var aPosition = Doc_Nombre.indexOf(".pdf");
	if(aPosition > -1) {
		Response.Write("<embed src='"+sRuta+Doc_Nombre+"#toolbar=0' width='100%' height='1000' >")
	} else if (Doc_Nombre.indexOf(".xml") > -1) {
		EsXML = true
		 %>
		<div class="form-group">       
        <div class="col-sm-12">	
            <div align="center">
                <h1>Archivo XML <%=Doc_Nombre%></h1>
            </div>
        </div> 
        <div class="col-sm-12">	
        	<pre class="info"></pre>
            <div id="xmlfile" align="left">
				<pre class="formatted"></pre>
            </div>
        </div>          
               
    </div>

<script type="text/javascript" src="/js/vkbeautify.0.99.00.beta.js"></script>

<%	} else {	
		Response.Write("<img src='"+sRuta+Doc_Nombre+"' border='0'>")  
	}	
%>  
           </div></div>
    </div>
   </div>
  </div>
     
<script type="text/javascript">

$(document).ready(function() {
	
						 
});


<% if (EsXML) { %>

 $(function(){
	
	var url = "<%=sRuta%><%=Doc_Nombre%>";

	$.ajax({
		url: url,
		dataType:"text",
	   // beforeSend:function(){
	   //     $('.info').append($('<p>requesting '+url+'</p>'));
	   //     $('.info').append($('<p>and formatting the response!'));
	   // },
		error:function(){$('.info').append($('<p>error! '+url+'</p>'));},
		success: function(data) {
			xml_neat = formatXml(data);
			$('.formatted').text(xml_neat);
		}
	});
});
			
			
function formatXml(xml) {
	var formatted = '';
	var reg = /(>)(<)(\/*)/g;
	xml = xml.replace(reg, '$1\r\n$2$3');
	var pad = 0;
	jQuery.each(xml.split('\r\n'), function(index, node)
	{
		var indent = 0;
		if (node.match( /.+<\/\w[^>]*>$/ ))
		{
			indent = 0;
		}
		else if (node.match( /^<\/\w/ ))
		{
			if (pad != 0)
			{
				pad -= 1;
			}
		}
		else if (node.match( /^<\w[^>]*[^\/]>.*$/ ))
		{
			indent = 1;
		}
		else
		{
			indent = 0;
		}
		var padding = '';
		for (var i = 0; i < pad; i++)
		{
			padding += '  ';
			
		}
		var nodo = node
		var T1 = ""
		var T2 = ""
		
		while (nodo.length > 135) {
			T1 += nodo.substring(0, 135);
			T1 += '\r\n';
			nodo = nodo.substring(135, nodo.length);			
		}
		nodo = T1 + nodo

		formatted += padding + nodo + '\r\n';
		pad += indent;
	});
	return formatted;
}

<% } %>

</script>


