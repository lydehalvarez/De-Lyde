<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
	var Man_ID = Parametro("Man_ID",-1)
    var sSQL  = "SELECT *, getdate() as Fecha FROM TransferenciaAlmacen t INNER JOIN cliente c ON t.Cli_ID=c.Cli_ID "
+"INNER JOIN Almacen a on t.TA_End_Warehouse_ID = a.Alm_ID INNER JOIN Manifiesto_Salida m ON m.Man_ID=t.Man_ID "
+"INNER JOIN Proveedor p ON m.Prov_ID=p.Prov_ID LEFT OUTER JOIN Cat_Catalogo ct ON (ct.Cat_ID=Man_TipoDeRutaCG94  and ct.Sec_ID =94)" 
+" LEFT OUTER JOIN Cat_Estado e ON e.Edo_ID=m.Edo_ID LEFT OUTER JOIN Cat_Aeropuerto ae ON ae.Aer_ID=m.Aer_ID "
+"WHERE  m.Man_ID="+Man_ID+" ORDER BY m.Edo_ID desc"
	var rsRe = AbreTabla(sSQL,1,0)

		    while (!rsRe.EOF){
  	     var TA_ID = rsRe.Fields.Item("TA_ID").Value   
   	     var Guia  = rsRe.Fields.Item("TA_Guia").Value 
		 var Pedido = rsRe.Fields.Item("TA_Folio").Value   
	     var Ruta  = "R"+ rsRe.Fields.Item("Alm_Ruta").Value 
		 var Cajas  = "1"
		 var Num_Tienda = rsRe.Fields.Item("Alm_Numero").Value   
	     var Tienda = rsRe.Fields.Item("Alm_Nombre").Value 
		 var Dir_Tienda = rsRe.Fields.Item("Alm_Calle").Value +", No. Ext. " +  rsRe.Fields.Item("Alm_NumExt").Value
		 						   + ", No. Int. " + rsRe.Fields.Item("Alm_NumInt").Value + ", " +  rsRe.Fields.Item("Alm_Colonia").Value + ", " 
								   +rsRe.Fields.Item("Alm_Delegacion").Value + ", " +rsRe.Fields.Item("Alm_Ciudad").Value + ", " 
								   + rsRe.Fields.Item("Alm_Estado").Value
		  var Estado = rsRe.Fields.Item("Alm_Estado").Value
	      var Contacto = rsRe.Fields.Item("Alm_Responsable").Value 
		  var Tel = rsRe.Fields.Item("Alm_RespTelefono").Value 
		  var Observaciones = ""
	if(Estado == "ESTADO DE MEXICO"){
	Estado = "EDO. MEX."	
	}
		if(Estado == "CIUDAD DE MEXICO"){
	Estado = "CDMX"	
	}
	
	%>{
    "Guia":"<%=Guia%>",
    "Pedido":"<%=Pedido%>",
    "Ruta":"<%=Ruta%>",
    "Cajas":"<%=Cajas%>",
    "Num_Tienda":"<%=Num_Tienda%>",
    "Tienda":"<%=Tienda%>",
    "Dir_Tienda":"<%=Dir_Tienda%>",
    "Estado":"<%=Estado%>",
    "Contacto":"<%=Contacto%>",
    "Tel":"<%=Tel%>",
    "Observaciones":"<%=Observaciones%>"
    
}<%=(i < rsRe.RecordCount - 1 ) ? "," : ""  %>
<%
i++;
            rsRe.MoveNext() 
        }
         rsRe.Close()   
       
%>]

