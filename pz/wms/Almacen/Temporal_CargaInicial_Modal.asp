 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqIntPT_ID = Parametro("PT_ID", -1)
        var Pro_ID = Parametro("Pro_ID", -1)


		var PorCantidad = BuscaSoloUnDato("Pro_EsSerializado","Producto","Pro_ID = "+Pro_ID,-1,0) 
        
		var sqlSer = "EXEC SPR_Inventario_CargaInicial_Series "
              + "@Opcion = 1000 "
            + ", @Ubi_ID = " + rqIntUbi_ID
            + ", @PT_ID = " + rqIntPT_ID 

        var rsSer = AbreTabla(sqlSer, 1, 0)

		if(PorCantidad != 0){
%>
			<script type="application/javascript">$('#btnIntegraPallet').show('slow');$('#btnMdlGuardaCantidad').hide()</script>
            <div class="form-group row">
                    <label class="col-sm-1 control-label">Serie: </label>    
                    <div class="col-sm-4 m-b-xs">
                        <input type="text" id="inpMdlCISerie" placeholder="Serie" class="form-control"
                        onkeypress="TemporalCargaInicialCantidad.SeriesModalGuardarEscaner( event );"
                        maxlength="50" autocomplete="off">
                    </div>

                    <div class="col-sm-2 m-b-xs">
                        <small>Total Series:</small>
                        <br>
                        <h3 class="text-success" id="lblMdlCITotal"> </h3>
                    </div>

                    <div class="col-sm-2 m-b-xs">
                        <a id="btnMdlCISerieGuardar" class="btn btn-sm btn-success"
                        onclick="TemporalCargaInicialCantidad.SeriesModalGuardar();">
                            <i class="fa fa-floppy-o"></i> Buscar
                        </a>
                    </div>
                   
                
            </div>
           
            <div class="form-group row" id="divMdlCIListado" style="height: 250px; overflow: auto;">

            <table class="table" style="font-size:medium">
            	<thead>
                	<tr>
                    	<th>No.</th>
                    	<th>Serie</th>
                    	<th>Mensaje</th>
                    </tr>
                
                </thead>
                <tbody id="Encabezado">
                
<%      
        if( !(rsSer.EOF) ){
            var i = 0
			var Serie = ""
            while(!(rsSer.EOF) ){ 
				i++
				Serie = rsSer("INV_Serie").Value
%>
                    <tr id="<%= Serie %>">
                        <td><%=i%></td>
                        <td><%= Serie %></td>
                        <td>OK</td>
                    </tr>

<%
                rsSer.MoveNext()
            }
        } else {
			var i = 0
%>
                    <tr>
                        <td colspan="3">
                            <i class="fa fa-exclamation-circle-o"></i> No hay series escaneadas
                        </td>
                    </tr>
<%
        }
%>
                </tbody>
            </table>
            </div>
		<script type="application/javascript">$('#lblMdlCITotal').html(<%=i%>)</script>
<%
        rsSer.Close()
		}else{
%>			<script type="application/javascript">$('#btnMdlGuardaCantidad').show('slow');$('#btnIntegraPallet').hide()</script>
            <div class="row">
                    <label class="col-md-2 control-label">Cantidad: </label>    
                    <div class="col-md-5">
                        <input type="number" min="1" id="inpCantidad" placeholder="Escribe la cantidad" class="form-control" autocomplete="off">
                    </div>
<!--                    <div class="col-md-2">
                        <a id="btnMdlGuardaCantidad" class="btn btn-primary" 
                        onclick="TemporalCargaInicialCantidad.GuardaCantidad();">
                            <i class="fa fa-save"></i> Guarda cantidad
                        </a>
                    </div>
-->            </div>
			
<%
		}
%>

