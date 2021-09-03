<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

var Pro_ID = Parametro("Pro_ID",-1)

var sSQL  = " SELECT * "
	  sSQL  += " FROM Producto WHERE Pro_ID = " + Pro_ID
 
	bHayParametros = false
	ParametroCargaDeSQL(sSQL,0) 

//var FrPr_Check = Parametro("Ope_Habilitado","")
//var arrChk = new Array(0)
//    arrChk = FrPr_Check.split(",")

var Pro_Nombre = Parametro("Pro_Nombre","")


%>
	<div class="row">
		<div class="col-md-9">
			<div class="ibox">
				<div class="ibox-title">
					<span class="pull-right"></span>
					<h5>Producto - <small><%=Pro_Nombre%></small>
                    </h5>
				</div>
				<div class="ibox-content">
					<div class="table-responsive">
						<table width="100%" class="table shoping-cart-table">
							<tbody>
								<tr>
								  <td class="desc">
				<h3><a class="text-navy" href="#">Asignaci&oacute;n de articulos</a></h3>
				<p>Seleccione los articulos con los que desea relacionar el producto</p>
									  
                                      
<div class="row">
	<div class="col-md-12">
	<table class="table table-striped table-bordered table-hover table-full-width dataTable">
      <tr role="row">
        <th width="5%" >Relacionar con</th>      
    <th width="5%" >Cantidad</th>      
      </tr>
<%                    
 var Producto = "" 
 var ID = ""

 
 var sSQL  = "SELECT * "
     sSQL += " FROM Producto  "
     sSQL += " WHERE TPro_ID = 3 "
     sSQL += " Order by Pro_ID "
	 
 var rsProducto = AbreTabla(sSQL,1,0)
  
	while (!rsProducto.EOF){
		ID = rsProducto.Fields.Item("Pro_ID").Value
	    Producto = rsProducto.Fields.Item("Pro_Nombre").Value
		 var check = ""
  var sChecked = ""
  var cantidad = ""
		 var sSQL  = "SELECT * "
     sSQL += " FROM Producto_Relacion  "
     sSQL += " WHERE Pro_ID =" + Pro_ID
    sSQL += " and Pro_ProdRelacionado =" + rsProducto.Fields.Item("Pro_ID").Value
	 
 var rsPRelacion = AbreTabla(sSQL,1,0)
  while (!rsPRelacion.EOF){
	  	ID = rsPRelacion.Fields.Item("Pro_ID").Value
		cantidad = rsPRelacion.Fields.Item("Pro_Cantidad").Value
		check = "checked"
		sChecked = "checked='checked'"
	  	  rsPRelacion.MoveNext() 
	}
	rsPRelacion.Close()   
%>  
      <tr role="row"  >
      <td style="text-align: center !important;"><input type="checkbox" value="<%=ID%>" class="i-checks ChkRel"<%=sChecked%> onclick="javascript:CargaRelaciones(<%=ID%>)" data-checked="<%=check%>"><%=Producto%></td>
        <td style="text-align: left !important;"><input type="text" value="<%=cantidad%>" class="objAco"  id="InputCantidad<%=ID%>"></td>
      </tr>
<%                   
		rsProducto.MoveNext() 
	}
	rsProducto.Close()   
%>  
    </table>


    </div>    
</div>                                      
                                      
                                      
                                      
									</td>
									</tr>
						
							</tbody>
						</table>
					</div>
				</div> 

	</div>
		</div>
		<div class="col-md-3" id="dvRelacionados" ></div>
	</div>
    
<script type="text/javascript">

	$(document).ready(function(){
	  

	});
	 function CargaRelaciones(proid){
	
		var sDatos = "Pro_ID=" + $("#Pro_ID").val();	 
        sDatos += "&Pro_ProdRelacionado=" + 	proid
		sDatos += "&Pro_Cantidad=" + $("#InputCantidad"+proid).val();	
	
		$("#dvRelacionados").load("/pz/wms/Articulos/Productos/Relacionados_Ajax.asp?" + sDatos)
	
	}	
	
	
	
	

	
	
	
</script>
