<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

	

<script src="/Template/inspina/js/plugins/chartJs/Chart.min.js"></script>
   <script>
   <%
   		var tel_tip = ""
   		var Etiquetas = ""
    	var Barra1 = ""
    	var Barra2 = ""
    	var Barra3 = ""
		var dato = 0
		var sSQLEtq  = "select Pro_ClaveAlterna, count(*) as Cuenta "
    		sSQLEtq += " from Orden_Venta_Articulo v, Producto p "
    		sSQLEtq += " where v.Pro_ID = p.Pro_ID "
    		sSQLEtq += " and v.Pro_ID in (select Pro_ID from Producto where Pro_Modelo <> 'SIM') "
    		sSQLEtq += " group by Pro_ClaveAlterna "
		var rsEtq = AbreTabla(sSQLEtq,1,0)
		while (!rsEtq.EOF)
		{
			if(Etiquetas != "" ) {Etiquetas += ","}
		 	if(Barra1 != "" ) {Barra1 += ","}
		 	if(Barra2 != "" ) {Barra2 += ","}
		 	if(Barra3 != "" ) {Barra3 += ","}
//		 Etiquetas = recursos.humanos@refrimed.com
		 	Etiquetas = rsEtq.Fields.Item("Pro_ClaveAlterna").Value
		 	switch(Etiquetas)
		 	{
				case 28767: {tel_tip = "Samsung"} break;
				case 28771: {tel_tip = "Galaxi"} break;
				case 28772: {tel_tip = "Huawey"} break;
				case 28773: {tel_tip = "Iphone"} break;
				case 28802: {tel_tip = "Nokia"} break;
				case 28803: {tel_tip = "Motorola"} break;
				case 28926: {tel_tip = "P30"} break;
				default: {tel_tip = Etiquetas} break;
		 	}		 
		 	tel_tip += tel_tip
		 	dato = rsEtq.Fields.Item("Cuenta").Value
		 	Barra1 += dato
		 	if(dato==0) {dato=10}
		 	rsEtq.MoveNext()
	}
    rsEtq.Close() 
	Response.Write("hola")
	%>	
   </script>