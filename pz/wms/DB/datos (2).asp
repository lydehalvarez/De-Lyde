<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<script>
var foo = 1;
var tpo_graf = ""
<%
var Renglones = 3 
var Columnas = 0
var Grids = 0  
var i = 0
var Col = 0	  
 var sSQLRen  = " select Dsb_Renglones from Dashboard "
     sSQLRen += " where Sys_ID = " + SistemaActual
     sSQLRen += " and WgCfg_ID = " + VentanaIndex
 var rsRen = AbreTabla(sSQLRen,1,2) 
 	if (!rsRen.EOF){
	 	Renglones = rsRen.Fields.Item("Dsb_Renglones").Value
	}
	rsRen.Close()				 
   for (i=1;i<=Renglones;i++){   
   		Response.Write("<div class='row'>")
		var sSQLCol  = " select DsbC_ID, DsbC_TipoGrafico, DsbC_UnidadGrid from Dashboard_Columna "
			sSQLCol += " where Sys_ID = " + SistemaActual
			sSQLCol += " and WgCfg_ID = " + VentanaIndex
	        sSQLCol += " and DsbR_ID = " + i
		var rsCol = AbreTabla(sSQLCol,1,2)
        while (!rsCol.EOF){
			Col = rsCol.Fields.Item("DsbC_ID").Value
	    	Grids = rsCol.Fields.Item("DsbC_UnidadGrid").Value
			Response.Write("<div class='col-lg-" + Grids +"' id='r" + i + "c" + Col + "'>")
			Response.Write( "tipo = " + rsCol.Fields.Item("DsbC_TipoGrafico").Value)
			Response.Write("</div>")				  
			rsCol.MoveNext() 
		}
        rsCol.Close()
		Response.Write("</div>")
   }
%>  
switch (foo) 
{
  case 1: 
  {
	  tpo_graf = "grafica_ordenes.asp";
	  <%Response.Write("console.log('El valor de la variable tpo es igual a '+tpo_graf);")%>
  } break;
  case 2: 
  {
	  tpo_graf = "grafica_ventas.asp";
	  console.log('El valor de la variable tpo es igual a '+tpo_graf);
  } break;
  case 3: 
  {
	  tpo_graf = "tabla_lista.asp";
	  console.log('El valor de la variable tpo es igual a '+tpo_graf);
  } break;
  case 4: 
  {
	  tpo_graf = "caja_chica.asp";
	  console.log('El valor de la variable tpo es igual a '+tpo_graf);
  } break;
  case 5:
  {
	  tpo_graf = "caja_grande.asp";
	  console.log('El valor de la variable tpo es igual '+tpo_graf);
	  
  }
  case 6:
  {
	  tpo_graf = "caja_mediana"
	  console.log('El valor de la variable tpo es igual '+tpo_graf);
  }
  default: {console.log('default');} break;
}
</script>
<%
	var tpo_gra = "1"
	Response.Write(tpo_gra)
%>
