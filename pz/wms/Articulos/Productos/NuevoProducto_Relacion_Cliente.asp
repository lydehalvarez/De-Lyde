<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

	var Renglon = Parametro("Renglon",-1)
	
%>
  <div class="panel panel-default" id="Cli<%=Renglon%>">
      <div class="panel-heading" role="tab">
          <div class="row">  
            <div class="col-lg-7">
                <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_Cli_<%=Renglon%>" aria-expanded="false" aria-controls="collapse_Cli_<%=Renglon%>">
                  <h4 class="panel-title">
                      Cliente <%=Renglon%> 
                  </h4>
                 </a>
            </div>
            <div class="col-lg-5 text-right">
                <div class="btn-group" role="group" aria-label="Basic example">
                  <button type="button" value="<%=Renglon%>" class="btn btn-md btn-danger btnDeleteCli">Borrar</button>
                  <button type="button" value="<%=Renglon%>" class="btn btn-md btn-success btnSaveCli"><i class="fa fa-save"></i>&nbsp;&nbsp;Guardar cliente <%=Renglon%></button>
                </div>
            </div>
        </div>
      </div>  
    <div id="collapse_Cli_<%=Renglon%>" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading_Cli_<%=Renglon%>">
      <div class="panel-body">
            <div class="form-group">
                <label class="control-label col-md-3 required">Cliente</label>
                <div class="col-lg-8">
                        <%CargaCombo("Cli_ID"+Renglon,"class='form-control datosCliente Cli"+Renglon+"'","Cli_ID","Cli_Nombre",
                        "Cliente","","Cli_Nombre",-1,0,"Selecciona","Editar")					   
                        %>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 required">SKU Cliente</label>
                <div class="col-lg-8">
                    <input placeholder="SKU Cliente"  value="" autocomplete="off" class="form-control Cli<%=Renglon%> sku_client<%=Renglon%>" type="text">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 required">Nombre art&iacute;culo</label>
                <div class="col-lg-8">
                    <input placeholder="Nombre del articulo del cliente"  value="" autocomplete="off" class="form-control Cli<%=Renglon%> name_client<%=Renglon%>" type="text">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 required">Descripcion</label>
                <div class="col-lg-8">
                    <textarea placeholder="Descripcion"  value="" autocomplete="off" class="form-control Cli<%=Renglon%> description_client<%=Renglon%>"></textarea>
                </div>
            </div>
      </div>
    </div>
</div>
