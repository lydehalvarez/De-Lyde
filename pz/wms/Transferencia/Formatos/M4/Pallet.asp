 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var Mov_ID = Parametro("Mov_ID",-1)
	var Renglon = Parametro("Renglon",-1)
	
	var sSQLO = "  SELECT MovP_ID,MovM_ID,"
		sSQLO += "(SELECT MovP_LPN FROM Movimiento_Pallet WHERE Mov_ID = a.Mov_ID AND MovP_ID = a.MovP_ID) Pallet "
		sSQLO += " ,(SELECT MovM_FolioCaja FROM Movimiento_Pallet_Master WHERE Mov_ID = a.Mov_ID  AND MovP_ID = a.MovP_ID AND MovM_ID = a.MovM_ID) CajaMaster"
		sSQLO += " FROM Movimiento_Pallet_Master a "
		sSQLO += " WHERE Mov_ID = "+Mov_ID

%>

<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
      <h4 class="panel-title">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse<%=Renglon%>" aria-expanded="true" aria-controls="collapseOne">
         	Pallet
        </a>
      </h4>
    </div>
    <div id="collapse<%=Renglon%>" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading<%=Renglon%>">
      <div class="panel-body">
        <table class="table">
            <thead>
                <th>Pallet</th>
                <th>Caja</th>
                <th>Cantidad</th>
                <th align="center">Acciones</th>
            </thead>
            <tbody>
        <%    
        var rsJson = AbreTabla(sSQLO,1,0)
        
        while (!rsJson.EOF){ 
            var MovP_ID =  rsJson.Fields.Item("MovP_ID").Value
            var MovM_ID =  rsJson.Fields.Item("MovM_ID").Value
            var Pallet =  rsJson.Fields.Item("Pallet").Value
            var CajaMaster =  rsJson.Fields.Item("CajaMaster").Value
        %>
            <tr>
                <td><%=Pallet%></td>
                <td><%=CajaMaster%></td>  
                <td width="20%"><input type="number" style="width:50%" value="1" min="1" id="Mov_<%=Mov_ID%>_<%=MovP_ID%>_<%=MovM_ID%>" data-movmid="<%=MovM_ID%>" data-movpid="<%=MovP_ID%>" data-movid="<%=Mov_ID%>" class="form-control Limite"/></td>
                <td>
                <div class="row">
                    <div class="col-md-6"><input type="text" value=""  placeholder="Ingresa serie" data-movmid="<%=MovM_ID%>" onkeypress='FunctionPallet.PutSerie($(this).data("movid"),$(this).data("movpid"),$(this).data("movmid"),$(this).val(),$(this),event)' data-movpid="<%=MovP_ID%>" data-movid="<%=Mov_ID%>" class="form-control InputPicking"/></div>
                    <div class="col-md-2"><input type="button" class="btn btn-success" value="Ver series"/></div>
                    <div class="col-md-3"><input type="button" class="btn btn-info" data-movmid="<%=MovM_ID%>" data-movpid="<%=MovP_ID%>" data-movid="<%=Mov_ID%>" onclick='FunctionPallet.PrintLabel($(this).data("movid"),$(this).data("movpid"),$(this).data("movmid"))' value="Imprimir etiqueta"/></div>
            	</div></td>
            </tr>
        <%
        
           rsJson.MoveNext()
         }
         rsJson.Close() 
        %>    
            
            </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
