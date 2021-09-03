
var sImg = ""

var sSQL  = "select Img_Imagen,Img_Area "
	sSQL += " from iqClienteImagenes "
	sSQL += " where iqCli_ID = " + iqCli_ID
	sSQL += " and Img_Habilitado = 1 "
	sSQL += " order by Img_Orden "


	sDivision = "<ul id=\"homeDivisions\">"
	sDivisionImagenes = "<ul id=\"homeDivisionImages\">"
	
var rsAreas = AbreTabla(sSQL,1,2) 
while (!rsAreas.EOF){
	
	sImg = "" + rsAreas.Fields.Item("Img_Imagen").Value 
	if (!EsVacio(sImg)) {
		sDivisionImagenes += "<li>"
		sDivisionImagenes += "<img src=\"" + sImg + "\" width=\"1223\" height=\"552px\" class=\"headerImage\">"
		sDivisionImagenes += "</li>"
		
		sDivision += "<li style=\"height:0;margin:0;\">"
		sDivision +=  rsAreas.Fields.Item("Img_Area").Value 
		sDivision += "</li>"
		
	}
	
	rsAreas.MoveNext()
}
	rsAreas.Close()
	
sDivisionImagenes += "</ul>"   
sDivision += "</ul>"

