<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var Rep_ID = Parametro("Rep_ID",-1)
	
	Rep_ID = 4
	
	var QueryCondiciones = ""
	var sSQLReporte = "SELECT ISNULL(Rep_SQLOrden,'') as Rep_SQLOrden "
	    sSQLReporte += ",ISNULL(Rep_SQLCondicion,'') as Rep_SQLCondicion "
	    sSQLReporte += ",ISNULL(Rep_SQLTabla,'') as Rep_SQLTabla "
	    sSQLReporte += " FROM Reportes WHERE Rep_ID = "+Rep_ID

	var rsRep = AbreTabla(sSQLReporte,1,0)
	
	if(!rsRep.EOF){
		
		QueryCondiciones = "" + rsRep.Fields.Item("Rep_SQLTabla").Value
		if (rsRep.Fields.Item("Rep_SQLCondicion").Value != ""){
			QueryCondiciones += " WHERE " + rsRep.Fields.Item("Rep_SQLCondicion").Value
		}
		if (rsRep.Fields.Item("Rep_SQLOrden").Value != ""){
			QueryCondiciones += " ORDER BY " + rsRep.Fields.Item("Rep_SQLOrden").Value
		}		
		
		var QueryCampos = ""
		var Campos = new Array(0) 
		var cCampos = 0

		var sCamposSQL = "SELECT ISNULL(Rep_SubConsulta,'') as Rep_SubConsulta "
			sCamposSQL += ",ISNULL(Rep_Campo,'') as Rep_Campo "
			sCamposSQL += ",ISNULL(Rep_Titulo,'') as Rep_Titulo "
			sCamposSQL += " FROM ReportesCampos WHERE Rep_ID = "+Rep_ID+" ORDER BY Rep_Orden ASC"
		
		var rsRepCamp = AbreTabla(sCamposSQL,1,0)
		while (!rsRepCamp.EOF){
			
			var Rep_TituloCampo = rsRepCamp.Fields.Item("Rep_Titulo").Value 
			var Rep_SubConsulta = rsRepCamp.Fields.Item("Rep_SubConsulta").Value
			var Campo = rsRepCamp.Fields.Item("Rep_Campo").Value
			
			Campos[cCampos] = Rep_TituloCampo
            cCampos ++
			if(QueryCampos != "") {QueryCampos += ", "}						
			if(Rep_SubConsulta == ""){
				QueryCampos += Campo
			} else {
				QueryCampos += "(" + Rep_SubConsulta +") as " + Campo
			}
		rsRepCamp.MoveNext() 
	}
	rsRepCamp.Close() 
	
	var sJSONReporte = ""
	var sJsonUnidad = ""
	var sDato = ""
	var sSQLFinal = "SELECT " + QueryCampos
	    sSQLFinal += " FROM " + QueryCondiciones
		
		var rsDatos = AbreTabla(sSQLFinal,1,0)
		while (!rsDatos.EOF){
			if(sJSONReporte != "") {sJSONReporte += ","}	
			sJSONReporte += '{'
			sJsonUnidad = ""
   			for (i=0;i<=Campos.length-1;i++) {
				if(sJsonUnidad !="") {sJsonUnidad+= ","}
				sJsonUnidad += '"' + Campos[i] + '":"'
				sDato = "" + rsDatos.Fields.Item(i).Value
				sDato = sDato.replace(/^\s+|\s+$/g,"");	
				sDato = sDato.replace(/[^ -~]+/g, "");
				sJsonUnidad += sDato + '"' 
			}
			
			sJSONReporte += sJsonUnidad + '}'
			rsDatos.MoveNext() 
		}
		rsDatos.Close() 
		
	Response.Write('[' + sJSONReporte + ']')

}  		


%>
