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
  
  var VisibleAdmin = ParametroDeVentana(SistemaActual, VentanaIndex, "Visible para Admin", 0)
  var VisibleCliente = ParametroDeVentana(SistemaActual, VentanaIndex, "Visible para Cliente", 0)
  var VisibleProveedor = ParametroDeVentana(SistemaActual, VentanaIndex, "Visible para Proveedor", 0)   
%>

    <div id="Ficha" name="Ficha"></div>
       <div id="Resultadoajax" name="Resultadoajax"></div>
         <div class="panel panel-default">
           <div class="panel-body">
              <div class="panel-group accordion-custom accordion-teal" id="accordion">
        
<%
    var Rep_GrupoCG7 = 0
	var sVisible = ""
	
	var sSQL = " SELECT Cat_ID, Cat_Nombre, Cat_Descripcion "
		sSQL += " FROM Cat_Catalogo "
		sSQL += " WHERE Cat_ID in (SELECT DISTINCT Rep_GrupoCG7 FROM Reportes "
		if (VisibleAdmin == 1) {
			sVisible = " Rep_AdminVisible = 1 "
		}
		if (VisibleCliente == 1) {
			if (sVisible != "") sVisible += " OR "
			sVisible += " Rep_ClienteVisible = 1 "
		}		
		if (VisibleProveedor == 1) {
			if (sVisible != "") sVisible += " OR "			
			sVisible += " Rep_ProvVisible = 1 "
		}	
		if (sVisible != "") sVisible = " WHERE " + sVisible
		
		sSQL += sVisible + " ) "
		sSQL += " AND Sec_ID = 7 "
		sSQL += " ORDER BY Cat_Orden "

	var rsTipoRep = AbreTabla(sSQL,1,0)

	while (!rsTipoRep.EOF){
		iRegistros++
	Rep_GrupoCG7 = rsTipoRep.Fields.Item("Cat_ID").Value
   
%> 
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
                            
  <ul>                       
 <%
	
	
	var sSQL = " SELECT Rep_ID, Rep_GrupoCG7, Rep_Nombre, Rep_Titulo1 "
		sSQL += " FROM Reportes "
		sSQL += " WHERE Rep_GrupoCG7 =  " + Rep_GrupoCG7
		if (VisibleAdmin == 1) {
			sSQL += " AND Rep_AdminVisible = 1 "
		}
		if (VisibleCliente == 1) {
			sSQL += " AND Rep_ClienteVisible = 1 "
		}		
		if (VisibleProveedor == 1) {
			sSQL += " AND Rep_ProvVisible = 1 "
		}				
			
		var rsRep = AbreTabla(sSQL,1,0)

	while (!rsRep.EOF){
		
		
 %> 	
 
        
    <li> <h4><a href="javascript:CargarReportes( <%=rsRep.Fields.Item("Rep_ID").Value%>)">
	<%=rsRep.Fields.Item("Rep_Nombre").Value%></a></h4>
    <%=rsRep.Fields.Item("Rep_Titulo1").Value%></li>  
        
 <%
	
		rsRep.MoveNext() 
	}
	rsRep.Close()   
 %>           
</ul>
            
         </div>
      </div>
   </div> 


   <%
        Clasein = ""
        Clase = "collapsed"
          rsTipoRep.MoveNext() 
	     }
	   rsTipoRep.Close() 
   %>  
   
 
        </div>
    </div>
</div> 


<div id="dvVentana" style="width: 70%; min-height: 325px; background-color: rgb(255, 255, 255); box-shadow: rgb(119, 119, 119) 0px 10px 6px -6px; position: fixed; top: 85px; left: 15%; z-index: 2200; display: none;">
 <div id="dvVentanaClose" style="float:left; display: block;">
    <a style="position: absolute;top:-15px;right:-17px;z-index:1501;
      background: url(/img/x.png) 0 0 no-repeat;width: 30px;
      height: 30px;display: block;" href="javascript:CierraVentanaAux()">
    </a>
  </div>
      <div id="dvVentanaContenido" style="overflow: auto; min-height: 462px; padding: 25px; box-shadow: black 0px 0px 5px; border-radius: 5px; display: block;">
      </div>
</div>


     
<script type="text/javascript">   
  
function CierraVentanaAux() {
	$("#dvVentana").hide("slow");
	$("#dvVentanaContenido").empty()	
}

function CargarReportes(Rep_ID){

	var sData = "Rep_ID=" + Rep_ID
		if($("#Cli_ID").length>0) sData += "&Cli_ID=" + $("#Cli_ID").val()
		if($("#Deu_ID").length>0) sData += "&Deu_ID=" + $("#Deu_ID").val()
		if($("#Fac_ID").length>0) sData += "&Fac_ID=" + $("#Fac_ID").val()				

		$("#dvVentana").show();
		$('#dvVentanaContenido').fadeOut(800, function() {
			$(this).empty()
				   .load("/pz/wms/Reportes/Dinamicos/Filtro.asp?" + sData)
				   .fadeIn(1500);
		    	$("#dvVentana").css('overflow','');
		});		


} 
</script>