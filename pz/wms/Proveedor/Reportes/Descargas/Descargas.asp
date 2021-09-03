<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../../Includes/iqon.asp" -->
<%

  var Cli_ID = Parametro("Cli_ID",1)
  var Deu_ID = Parametro("Deu_ID",-1)
  var Fac_ID = Parametro("Fac_ID",-1)
  var RepD_ID = Parametro ("RepD_ID",-1)
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
		sSQL += " WHERE Cat_ID in (SELECT DISTINCT RepD_GrupoCG7 FROM ReportesDescarga "
		if (VisibleAdmin == 1) {
			sVisible = " RepD_AdminVisible = 1 "
		}
		if (VisibleCliente == 1) {
			if (sVisible != "") sVisible += " OR "
			sVisible += " RepD_ClienteVisible = 1 "
		}		
		if (VisibleProveedor == 1) {
			if (sVisible != "") sVisible += " OR "			
			sVisible += " RepD_ProvVisible = 1 "
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
	
	
	var sSQL = " SELECT RepD_ID, RepD_GrupoCG7, RepD_Nombre, RepD_Descripcion "
		sSQL += " FROM ReportesDescarga "
		sSQL += " WHERE RepD_GrupoCG7 =  " + Rep_GrupoCG7
		if (VisibleAdmin == 1) {
			sSQL += " AND RepD_AdminVisible = 1 "
		}
		if (VisibleCliente == 1) {
			sSQL += " AND RepD_ClienteVisible = 1 "
		}		
		if (VisibleProveedor == 1) {
			sSQL += " AND RepD_ProvVisible = 1 "
		}				
			
		var rsRep = AbreTabla(sSQL,1,0)

	while (!rsRep.EOF){

 %> 	
 
    <li> <h4><a href="javascript:CargarReportes(<%=rsRep.Fields.Item('RepD_ID').Value%>)">
	<%=rsRep.Fields.Item("RepD_Nombre").Value%></a></h4>
    <%=rsRep.Fields.Item("RepD_Descripcion").Value%></li>  
        
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


 
<script type="text/javascript">   
  
 
    function CargarReportes(r){

        var sData = "RepD_ID=" + r

        $('#Contenido').load("/pz/wms/Proveedor/Reportes/Descargas/Archivos.asp?" + sData)	

    } 
    
</script>