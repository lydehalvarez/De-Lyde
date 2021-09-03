<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

	var Renglon = Parametro("Renglon",-1)
	
%>
  <div class="panel panel-default" id="Prov<%=Renglon%>">
      <div class="panel-heading" role="tab">
          <div class="row">  
            <div class="col-lg-7">
                <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse_Prov_<%=Renglon%>" aria-expanded="false" aria-controls="collapse_Prov_<%=Renglon%>">
                  <h4 class="panel-title">
                      Proveedor <%=Renglon%> 
                  </h4>  
                 </a>
            </div>
            <div class="col-lg-5 text-right">
                <div class="btn-group" role="group" aria-label="Basic example">
                  <button type="button" value="<%=Renglon%>" class="btn btn-md btn-danger btnDeleteProv">Borrar</button>
                  <button type="button" value="<%=Renglon%>" class="btn btn-md btn-success btnSaveProv"><i class="fa fa-save"></i>&nbsp;&nbsp;Guardar proveedor <%=Renglon%></button>
                </div>
            </div>
            
        </div>
      </div>  
    <div id="collapse_Prov_<%=Renglon%>" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading_Prov_<%=Renglon%>">
      <div class="panel-body">
            <div class="form-group">
                <label class="control-label col-md-3 required">Proveedor</label>
                <div class="col-lg-8">
                        <%CargaCombo("Prov_ID"+Renglon,"class='form-control Prov"+Renglon+"'","Prov_ID","Prov_Nombre",
                        "Proveedor","","Prov_Nombre",-1,0,"Selecciona","Editar")					   
                        %>
                </div>
            </div>
                <div class="form-group">
                    <label class="control-label col-md-3 required">SKU Proveedor</label>
                    <div class="col-lg-8">
                        <input placeholder="SKU Proveedor"  value="" autocomplete="off" class="form-control Prov<%=Renglon%> sku_prov<%=Renglon%>" type="text">
                    </div>
                </div>
            <div class="form-group">
                <label class="control-label col-md-3 required">Nombre art&iacute;culo</label>
                <div class="col-lg-8">
                    <input placeholder="Nombre del articulo del proveedor"  value="" autocomplete="off" class="form-control Prov<%=Renglon%> name_prov<%=Renglon%>" type="text">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3 required">Descripcion</label>
                <div class="col-lg-8">
                    <textarea placeholder="Descripcion"  value="" autocomplete="off" class="form-control Prov<%=Renglon%> description_prov<%=Renglon%>"></textarea>
                </div>
            </div>
      </div>
    </div>
</div>
