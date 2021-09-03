<%
var rengl = 3 
var colum = 0
var espac = 0  
var i = 0
var col = 0	  
var sSQLRen  = " select Dsb_Renglones from Dashboard "
    sSQLRen += " where Sys_ID = " + SistemaActual
    sSQLRen += " and WgCfg_ID = " + VentanaIndex
var rsren = AbreTabla(sSQLRen,1,2) 
 	if (!rsRen.EOF){rengl = rsRen.Fields.Item("Dsb_Renglones").Value}
	rsren.Close()				 
   	for (i=1;i<=Renglones;i++)
   	{   
   		Response.Write("<div class='row'>")
		var sSQLCol  = " select DsbC_ID, DsbC_TipoGrafico, DsbC_UnidadGrid from Dashboard_Columna "
			sSQLCol += " where Sys_ID = " + SistemaActual
			sSQLCol += " and WgCfg_ID = " + VentanaIndex
	        sSQLCol += " and DsbR_ID = " + i
		var rscol = AbreTabla(sSQLCol,1,2)
        while (!rsCol.EOF)
		{
			col = rsCol.Fields.Item("DsbC_ID").Value
	    	espac = rscol.Fields.Item("DsbC_UnidadGrid").Value
			Response.Write("<div class='col-lg-"+espac+"'id='r"+i+"c"+col+"'>")
			Response.Write( "tipo="+rscol.Fields.Item("DsbC_TipoGrafico").Value)
			Response.Write("</div>")				  
			rscol.MoveNext() 
		}
        rscol.Close()
		Response.Write("</div>")
   }
%>          