<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var Rep_ID = Parametro("Rep_ID",-1)
   
	var QueryCondiciones = ""
	
   var sSQLReporte = "SELECT ISNULL(Rep_SQLOrden,'') as Rep_SQLOrden "
                   + ",ISNULL(Rep_SQLCondicion,'') as Rep_SQLCondicion "
                   + ",ISNULL(Rep_SQLTabla,'') as Rep_SQLTabla "
                   + ",ISNULL(Rep_SQLGroup,'') as Rep_SQLGroup "
                   + " FROM Reportes "
                   + " WHERE Rep_ID = " + Rep_ID

	var rsRep = AbreTabla(sSQLReporte,1,0)

	if(!rsRep.EOF){
		
		QueryCondiciones = "" + rsRep.Fields.Item("Rep_SQLTabla").Value
		if (FiltraVacios(rsRep.Fields.Item("Rep_SQLCondicion").Value) != ""){
			QueryCondiciones += " WHERE " + rsRep.Fields.Item("Rep_SQLCondicion").Value
		}
		if (FiltraVacios(rsRep.Fields.Item("Rep_SQLGroup").Value) != ""){
			QueryCondiciones += " GROUP BY " + rsRep.Fields.Item("Rep_SQLGroup").Value
		}		
		if (FiltraVacios(rsRep.Fields.Item("Rep_SQLOrden").Value) != ""){
			QueryCondiciones += " ORDER BY " + rsRep.Fields.Item("Rep_SQLOrden").Value
		}		
		
		var QueryCampos = ""
		var Campos = new Array(0) 
		var cCampos = 0
   
		var Titulo = new Array(0) 
 		var Formato = new Array(0)            
   
        var Rep_TituloCampo = ""
        var Rep_SubConsulta = ""
        var Rep_Formato = ""
        var Campo = ""

		var sCamposSQL = "SELECT ISNULL(Rep_SubConsulta,'') as Rep_SubConsulta "
			           + ",ISNULL(Rep_Campo,'') as Rep_Campo "
			           + ",ISNULL(Rep_Titulo,'') as Rep_Titulo "
                       + ",Rep_Formato "
			           + " FROM ReportesCampos "
                       + " WHERE Rep_ID = " + Rep_ID
                       + " ORDER BY Rep_Orden ASC"
		
		var rsRepCamp = AbreTabla(sCamposSQL,1,0)
		while (!rsRepCamp.EOF){
			
			Rep_TituloCampo = rsRepCamp.Fields.Item("Rep_Titulo").Value 
			Rep_SubConsulta = rsRepCamp.Fields.Item("Rep_SubConsulta").Value
			Campo           = rsRepCamp.Fields.Item("Rep_Campo").Value
            Rep_Formato     = rsRepCamp.Fields.Item("Rep_Formato").Value
			
			Campos[cCampos]  = Campo
			Formato[cCampos] = Rep_Formato
            Titulo[cCampos] = Rep_TituloCampo
            cCampos ++
   
			if(QueryCampos != "") {QueryCampos += ", "}						
			if(Rep_SubConsulta == ""){
				QueryCampos += Campo  
			} else {
				QueryCampos += "(" + Rep_SubConsulta +") as " + Campo
			}
            //QueryCampos +=  " as [" + Rep_TituloCampo + "]"
   
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
				sJsonUnidad += '"' + Titulo[i] + '":'
                sDato = FiltraVacios(rsDatos.Fields.Item(i).Value)
                //sDato = sDato.replace(/^\s+|\s+$/g,"");	 
    
                switch (Formato[i]) {
				  case 1:   // Texto
                      //  sDato = sDato.replace(/[^ -~]+/g, ""); 
                        sJsonUnidad += '"' + sDato + '"'                   
                      break; 
				  case 2:  //Fecha Jul
                        sJsonUnidad += '"' + sDato + '"'   
                      break;
				  case 3:  //Fecha Gre
                        sJsonUnidad += '"' + sDato + '"'
                      break;
				  case 4:  //Numérico
                        sJsonUnidad += sDato
                      break; 
				}
      
			}
			
			sJSONReporte += sJsonUnidad + '}'
			rsDatos.MoveNext() 
		}
		rsDatos.Close() 
		
	Response.Write('[' + sJSONReporte + ']')

}  		


%>
