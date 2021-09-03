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
  
%>

<div class="panel-body">
  <div class="form-horizontal" id="frmFiltroRep">
    <div class="form-group">
      <label class="col-sm-offset-1 col-xs-1 control-label"><h3>Reportes</h3></label>
    </div>
      <div class="form-group">
        <div class="col-sm-offset-1 col-sm-3">
                <!--label for="form-field-select-1"><h3>Reportes</h3></label--> 
            <%
             var sDamePermisos = "-1"
             var sCondSQLReporte = " Rep_BasadoArchivo = 0  "
                //Response.Write(sCondSQLReporte) 
                //CargaCombo(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo)
                CargaCombo("CboReporte"," class='form-control' id='form-field-select-1' onChange='javascript:BuscarOpcion();'","Rep_ID","Rep_Nombre","Reportes",sCondSQLReporte,"Rep_Nombre",Parametro("CboReporte",-1),0,"Seleccione un reporte",0)
                %>
        </div>
               
        <div class="col-sm-offset-1 col-sm-2" id="VerReporte" style="display:none">
		 <a class="btn btn-primary" href="javascript:Imprime(1,0);"><i class="fa fa-eye"></i>&nbsp;Ver Reporte</a>
        </div>

        <div class="col-sm-offset-1 col-sm-2" id="ExportarAExcel" style="display:none">
		 <a class="btn btn-primary" title="Exportar a excel." href="javascript:Imprime(1,1);"><i class="clip-download-3"></i>
         &nbsp;Exportar</a>
         </div>
       </div>	
    </div>
 </div>


    <div id="Ficha" name="Ficha"></div>
       <div id="Resultadoajax" name="Resultadoajax"></div>
         <div class="panel panel-default">
           <div class="panel-body">
              <div class="panel-group accordion-custom accordion-teal" id="accordion">
        
<%
    var Rep_GrupoCG7 = 0
	
	var sSQL = " SELECT Cat_ID, Cat_Nombre, Cat_Descripcion "
		sSQL += " FROM Cat_Catalogo "
		sSQL += " WHERE Cat_ID in (SELECT DISTINCT Rep_GrupoCG7 FROM Reportes) "
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
		sSQL += " WHERE Rep_GrupoCG7 =  "+ Rep_GrupoCG7
			
		
		var rsRep = AbreTabla(sSQL,1,0)

	while (!rsRep.EOF){
		
		
 %> 	
 
        
          <li> <h4><%=rsRep.Fields.Item("Rep_Nombre").Value%></h4>
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


<div id="dvVentana" style="width: 90%; min-height: 325px; background-color: rgb(255, 255, 255); box-shadow: rgb(119, 119, 119) 0px 10px 6px -6px; position: absolute; top: 85px; left: 5%; z-index: 400; display: none;">
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

	var sData = "&Rep_ID=" + Rep_ID
		/*sData += "&Com_ID=" + comid 	
		sData += "&Con_ID=" + conid 
		sData += "&Emp_ID=" + empid	
*/	
	
		$("#dvVentana").show();
		$('#dvVentanaContenido').fadeOut(800, function() {
			$(this).empty()
				   .load("/pz/mh/DinamicosJS?" + sData)
				   .fadeIn(1500);
		    	$("#dvVentana").css('overflow','');
	
		});		

} 
</script>