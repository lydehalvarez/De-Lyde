<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

  var Cli_ID = Parametro("Cli_ID",1)
  var Deu_ID = Parametro("Deu_ID",-1)
  var Fac_ID = Parametro("Fac_ID",-1)
  var Rep_ID = Parametro ("Rep_ID",-1)
  var iRegistros = 0
  var Clase = ""
  var Clasein = "in"
  
  
	var sSQL = "SELECT Rep_GrupoCG7,Rep_Nombre, Cat_ID, Cat_Nombre, Cat_Descripcion  "
		sSQL += " FROM Reportes, Cat_Catalogo  "
		sSQL += " WHERE Rep_ID = Rep_ID  " 
		sSQL += " AND Cat_ID in (SELECT DISTINCT Rep_GrupoCG7 FROM Reportes) "
		sSQL += " AND Sec_ID = 7 "
		sSQL += " ORDER BY Cat_Orden "
		
	bHayParametros = false
	ParametroCargaDeSQL(sSQL,0)	
	
	var Rep_GrupoCG7 = Parametro("Rep_GrupoCG7","")
	var Rep_Nombre = Parametro("Rep_Nombre","")
	
	
	var rsTipoRep = AbreTabla(sSQL,1,0)
	var iRegistros = 0
	
	if (!rsTipoRep.EOF){
		iRegistros++
		var Rep_GrupoCG7 = rsTipoRep.Fields.Item("Rep_GrupoCG7").Value
		var Rep_Nombre = rsTipoRep.Fields.Item("Rep_Nombre").Value
		
		
		
 
		
%>
      <div id="Ficha" name="Ficha"></div>
      <div id="Resultadoajax" name="Resultadoajax"></div>
      <div class="panel panel-default">
      <div class="panel-body">
      <div class="panel-group accordion-custom accordion-teal" id="accordion">
       	</div>	
	</div>
</div>   
      
      
       <div class="panel panel-default">
       <div class="panel-heading">
       <h4 class="panel-title">
        <a class="accordion-toggle <%=Clase%>" data-toggle="collapse" data-parent="#accordion" href="#collapse<%=iRegistros%>" title="<%=rsTipoRep.Fields.Item("Cat_Descripcion").Value%>">
       <i class="icon-arrow"></i>
       <%=rsTipoRep.Fields.Item("Cat_Nombre").Value%>
       </a></h4>
       </div>
       <div id="collapse<%=iRegistros%>" class="panel-collapse collapse <%=Clasein%>">
        <div class="panel-body">  
        
  

<div id="ContenidoList">
 <div id="DatosList">
    <List  class=" List List-striped List-bordered List-hover List-full-width dataList">
      <datalist id= "lista">
        <ul>
          <li class="center" width="20">Num</li>
          <li class="center" width="350">Tipo de reporte</li>
          <li class="center" width="120">Nombre del reporte</li>      
        </ul>
      </datalist>
      
      
        <div class="col-sm-offset-1 col-sm-2" id="VerReporte" style="display:none">
	   <a class="btn btn-primary" href="javascript:Imprime(1,0);"><i class="fa fa-eye"></i>
          &nbsp;Ver Reporte</a>
     </div>

     <div class="col-sm-offset-1 col-sm-2" id="ExportarAExcel" style="display:none">
       <a class="btn btn-primary" title="Exportar a excel." href="javascript:Imprime(1,1);"><i class="clip-download-3"></i>&nbsp;Exportar</a>
     </div>

   
     	     
<%

	rsTipoRep.MoveNext() 
	}
	rsTipoRep.Close() 
	 
%> 

<script>
 var selector = $('.panel-heading a[data-toggle="collapse"]');
selector.on('click',function() {
  var self = this;
  if ($(this).hasClass('collapsed')) {
    $.each(selector, function(key, value) {
      if (!$(value).hasClass('collapsed') && value != self) {
        $(value).trigger('click');
      }
    });
  }
});
</script>




  

<%

  var Cli_ID = Parametro("Cli_ID",1)
  var Deu_ID = Parametro("Deu_ID",-1)
  var Fac_ID = Parametro("Fac_ID",-1)
  var Rep_ID = Parametro ("Rep_ID",-1)
  var iRegistros = 0
  var Clase = ""
  var Clasein = "in"



  var sSQL = "SELECT 	Rep_ID, Rep_GrupoCG7, Rep_Nombre "
       sSQL += " From Reportes "
       sSQL += " Rep_GrupoCG7 = 4 "	

%>
        

