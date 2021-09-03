<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

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
				<a class="btn btn-primary" href="javascript:Imprime(1,0);"><i class="fa fa-eye"></i>
                &nbsp;Ver Reporte</a>
            </div>

            <div class="col-sm-offset-1 col-sm-2" id="ExportarAExcel" style="display:none">
				<a class="btn btn-primary" title="Exportar a excel." href="javascript:Imprime(1,1);"><i class="clip-download-3"></i>
                &nbsp;Exportar</a>
            </div>
            <!--div id="VerReporte" class="col-sm-3" align="right" style="display:none">
            	<a class="btn btn-primary" href="javascript:Imprime(1,0);"><i class="glyphicon glyphicon-log-in"></i>&nbsp;Ver Reporte</a>
            </div-->
            <!--div id="ExportarAExcel" class="col-sm-3" align="center" style="display:none">
            	<a href="javascript:Imprime(1,1);" title="Exportar a excel."><i class="fa fa-file-excel-o fa-4x"></i></a>
            </div-->
        
    	</div>	
	</div>
</div>

<div id="Ficha" name="Ficha"></div>
<div id="Resultadoajax" name="Resultadoajax"></div>
<div class="panel panel-default">
    <div class="panel-body">
        <div class="panel-group accordion-custom accordion-teal" id="accordion">
<%

	var iRegistros = 0
	var Clase = ""
	var Clasein = "in"
	var sSQL = "SELECT Cat_ID, Cat_Nombre, Cat_Descripcion "
		sSQL += " FROM Cat_Catalogo "
		sSQL += " WHERE Cat_ID in (SELECT DISTINCT Rep_GrupoCG7 FROM Reportes) "
		sSQL += " AND Sec_ID = 7 "
		sSQL += " ORDER BY Cat_Orden "
		
	var rsTipoRep = AbreTabla(sSQL,1,0)

	while (!rsTipoRep.EOF){
		iRegistros++
	//	var sData  = " data-cliid='" + rsTipoRep.Fields.Item("Cli_ID").Value + "' "
//		    sData += " data-deuid='" + rsTipoRep.Fields.Item("Deu_ID").Value + "' "
//		    sData += " data-facid='" + rsTipoRep.Fields.Item("Fac_ID").Value + "' "
//		var llavecf = rsTipoRep.Fields.Item("Cli_ID").Value + ","
//		    llavecf += rsTipoRep.Fields.Item("Deu_ID").Value + ","
//			llavecf += rsTipoRep.Fields.Item("Fac_ID").Value + "," + col1 + "," + Cli_TasaColumna1
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
                        Anim pariatur cliche reprehenderit, enim eiusmod high life accusamus terry richardson ad squid. 3 wolf moon officia aute, non cupidatat skateboard dolor brunch. Food truck quinoa nesciunt laborum eiusmod. Brunch 3 wolf moon tempor, sunt aliqua put a bird on it squid single-origin coffee nulla assumenda shoreditch et. Nihil anim keffiyeh helvetica, craft beer labore wes anderson cred nesciunt sapiente ea proident. Ad vegan excepteur butcher vice lomo. Leggings occaecat craft beer farm-to-table, raw denim aesthetic synth nesciunt you probably haven't heard of them accusamus labore sustainable VHS.
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
