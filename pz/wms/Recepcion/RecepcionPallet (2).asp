<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
var CliOC_ID = Parametro("CliOC_ID",-1)
var Cli_ID = Parametro("Cli_ID",-1)
var OC_ID = Parametro("OC_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var IR_ID = Parametro("IR_ID",-1)
var CliEnt_ID = Parametro("CliEnt_ID", -1)
var IDUsuario =  Parametro("IDUsuario",-1)	
var cliprov =""
var PalletsTotales = 0
var Cantidad_Art = 0
var Linea = 1
var UsuarioRol = -1
var TA_ID = -1

var sSQLRol = "select dbo.fn_BPM_DameRolUsuario(" + IDUsuario + ",3)"
var rsRol = AbreTabla(sSQLRol,1,0)
if(!rsRol.EOF){
    UsuarioRol = rsRol.Fields.Item(0).Value
}    
rsRol.CLose()

var sSQL = "SELECT Escan_Linea FROM Recepcion_UsuariosLinea WHERE Usu_ID ="+IDUsuario
   var rsLinea = AbreTabla(sSQL,1,0)
   if(!rsLinea.EOF){
       Linea =  rsLinea.Fields.Item("Escan_Linea").Value
    }
	
    if(CliOC_ID == -1){   
        var sSQLop = "select op.CliOC_ID "
                   + " from Cliente_OrdenCompra_Entrega e, Cliente_OrdenCompra op "
                   + " where IR_ID = " + IR_ID
                   + " and e.Cli_ID = op.Cli_ID " 
                   + " and e.CliOC_ID = op.CliOC_ID "
        
        var rsSQLop = AbreTabla(sSQLop,1,0)
        if(!rsSQLop.EOF){
           CliOC_ID =  rsSQLop.Fields.Item("CliOC_ID").Value
        }

    }
	if(CliOC_ID > -1){
        var sSQL = "SELECT c.Cli_ID, e.Pro_ID, c.CliOC_Folio, a.CliOCP_SKU, CliEnt_ArticulosRecibidos as articulos "
                 + ", Cli_Nombre FROM Cliente_OrdenCompra c "
                 + " INNER JOIN Cliente_OrdenCompra_Articulos a "
                 +    " ON c.CliOC_ID = a.CliOC_ID and c.Cli_ID=a.Cli_ID "
                 + " INNER JOIN cliente cl "
                 +    " ON  cl.Cli_ID=c.Cli_ID "
                 + " INNER JOIN Cliente_OrdenCompra_EntregaProducto e "
                 +    " ON a.CliOC_ID = e.CliOC_ID AND a.Cli_ID=e.Cli_ID and a.Pro_ID = e.Pro_ID INNER JOIN  Cliente_OrdenCompra_Entrega en ON  en.CliOC_ID = e.CliOC_ID AND en.Cli_ID=e.Cli_ID and en.CliEnt_ID = e.CliEnt_ID WHERE  en.IR_ID = "+ IR_ID
 //e.Cli_ID = "+Cli_ID   sSQL += " AND e.CliEnt_ID = "+CliEnt_ID+" AND e.CliOC_ID = "+CliOC_ID

   var rsArt = AbreTabla(sSQL,1,0)
if(!rsArt.EOF){
	var Folio =  rsArt.Fields.Item("CliOC_Folio").Value
	var cliprov = rsArt.Fields.Item("Cli_Nombre").Value 
	}if(OC_ID > -1){
var sSQL = "SELECT c.Prov_ID, a.Pro_ID, c.OC_Folio, a.OCP_SKU, OCP_Cantidad as articulos, Prov_Nombre FROM Proveedor_OrdenCompra c INNER"
	sSQL += " JOIN  Proveedor_OrdenCompra_Articulos  a ON c.OC_ID = a.OC_ID AND c.Prov_ID=a.Prov_ID  inner join proveedor p on  p.Prov_ID=c.Prov_ID"
  sSQL += " WHERE c.Prov_ID = "+Prov_ID+" AND c.OC_ID = "+OC_ID

   var rsArt = AbreTabla(sSQL,1,0)
	var Folio =  rsArt.Fields.Item("OC_Folio").Value
	 cliprov = rsArt.Fields.Item("Prov_Nombre").Value  
	}	
		var LPN_ID = BuscaSoloUnDato("ISNULL((MAX(Pt_ID)),0)+1","Recepcion_Pallet","",-1,0)
	
		if(!rsArt.EOF){

	    while (!rsArt.EOF){
			var Pro_ID = rsArt.Fields.Item("Pro_ID").Value
			
			if(Cli_ID > -1){
			sSQL = "SELECT  sum(Pt_Cantidad)  as Cantidad_Art FROM  Recepcion_Pallet p  WHERE p.IR_ID = "+IR_ID 

		//AND p.CliOC_ID= "+CliOC_ID+"  AND Pt_SKU = '"+ rsArt.Fields.Item("ClIOCP_SKU").Value + "'"
			}
				if(OC_ID > -1){
					sSQL = "SELECT  sum(Pt_Cantidad)  as Cantidad_Art FROM  Recepcion_Pallet p INNER JOIN Proveedor_OrdenCompra e ON  "				
					sSQL += "e.OC_ID=p.OC_ID AND e.Prov_ID=p.Prov_ID WHERE p.IR_ID = "+IR_ID+" AND p.OC_ID= "+OC_ID+" AND Pt_SKU = '"+ rsArt.Fields.Item("OCP_SKU").Value + "'"
			}
	
				  var rsArtRes = AbreTabla(sSQL,1,0)
							
				var restantes = rsArtRes.Fields.Item("Cantidad_Art").Value

				var Articulos_Rest = rsArt.Fields.Item("articulos").Value
						
				  if (rsArtRes.Fields.Count >0){
				//  Articulos_Rest= Articulos_Rest - rsArtRes.Fields.Item("Cantidad_Art").Value
				  }
		
				   if(OC_ID > -1){
						sSQL = "SELECT  r.OCP_Cantidad as articulos FROM  Producto_Proveedor c INNER JOIN Producto p ON p.Pro_ID = c.Pro_ID INNER JOIN Proveedor_OrdenCompra_Articulos r ON p.Pro_ID = r.Pro_ID   "
						sSQL += "WHERE  r.OC_ID = "+OC_ID+" AND r.Prov_ID = "+Prov_ID
								   }else{
						sSQL = "SELECT  r.CliEnt_CantidadArticulos as articulos, r.CliEnt_CantidadPallet FROM  Producto_Cliente c INNER JOIN Producto p ON p.Pro_ID = c.Pro_ID INNER JOIN Cliente_OrdenCompra_EntregaProducto r ON p.Pro_ID = r.Pro_ID INNER JOIN  Cliente_OrdenCompra_Entrega en ON  en.CliOC_ID = r.CliOC_ID AND en.Cli_ID=r.Cli_ID and en.CliEnt_ID = r.CliEnt_ID WHERE  en.IR_ID = "+ IR_ID
					
						//r.CliOC_ID = "+CliOC_ID+" AND r.Cli_ID = "+Cli_ID+"  AND r.CliEnt_ID = "+CliEnt_ID
				   }
		
				var rsActivos = AbreTabla(sSQL,1,0)
				var Cantidad_MB= 0
				//rsActivos.Fields.Item("articulos").Value
				while (!rsActivos.EOF){
                    if(OC_ID > -1){
                         var Cantidad_Pallet= 1
                    }else{
                     var Cantidad_Pallet= rsActivos.Fields.Item("CliEnt_CantidadPallet").Value
                    }
				    rsActivos.MoveNext() 
                }
                rsActivos.Close()   	
                var Cantidad_MBTotal = Math.round(Articulos_Rest/Cantidad_MB)


                var Cantidad_PalletTotal =  Cantidad_MBTotal/Cantidad_Pallet
                PalletsTotales += Cantidad_PalletTotal
                Cantidad_Art += Articulos_Rest

				rsArt.MoveNext() 
	    }
}
         rsArt.Close()   	
	}
	
         if(PalletsTotales > 1){
             if(PalletsTotales >Math.floor(PalletsTotales)){
                PalletsTotales = Math.floor(PalletsTotales) +1
             }else{
                 PalletsTotales =Math.floor(PalletsTotales)
             }
         }
         if(PalletsTotales < 1){
             PalletsTotales =1
         }
         if(PalletsTotales == 0 ){
             PalletsTotales =0
         }
         if(PalletsTotales == Cantidad_Art){
            PalletsTotales = "-" 
         }
         if(Cantidad_Art <0){
            Cantidad_Art =0 
         }
									 
        var sSQLTr  = "SELECT count(*) as pallet FROM Recepcion_Pallet "
            sSQLTr += " WHERE IR_ID = "+ IR_ID
     //   if(CliOC_ID > -1){
//             sSQLTr += "Cli_ID = "+Cli_ID+" AND CliOC_ID = "+CliOC_ID
//        }if(OC_ID > -1){
//                 sSQLTr += "Prov_ID = "+Prov_ID+" AND OC_ID = "+OC_ID
//        }
        if(Linea>0){
            sSQLTr += " AND Pt_Linea="+ Linea	
        }
	    var rsPallet = AbreTabla(sSQLTr,1,0)
	  
       Pallet = rsPallet.Fields.Item("pallet").Value 
	   PalletsTotales = rsPallet.Fields.Item("pallet").Value 
	   var Cons_Pallet = Pallet +1
	     var sSQL1 = "SELECT IR_Folio FROM Inventario_Recepcion WHERE IR_ID="+IR_ID
	    var rsPallets = AbreTabla(sSQL1, 1, 0)
		
		var Cita = rsPallets.Fields.Item("IR_Folio").Value

	   var LPN = cliprov.slice(0,3) + Cita + "LPN00" + Cons_Pallet
%>
<div class="form-horizontal" id="toPrint">
	<div class="row">
        
        
        <div class="ibox">
            <div class="ibox-content">
                <div class="form-group">
                    <div class="col-md-10">
                        <a data-taid="<%=TA_ID%>"  data-ocid= "<%=OC_ID%>"  
                           data-provid="<%=Prov_ID%>" data-cliocid="<%=CliOC_ID%>"
                           data-cliid="<%=Cli_ID%>" data-irid="<%=IR_ID%>" 
                           class="text-muted btnRegresar">
                        <i class="fa fa-inbox"></i>&nbsp;<strong>Regresar</strong></a>          
                    </div>
                    <div id = "dvCita"></div>
                </div>    
            </div> 
        </div>
        
        
		<div class="col-lg-9">
			<div class="ibox float-e-margins">
				<div class="ibox-content">
					<div class="form-group">
						<legend class="control-label col-md-12" style=
						"text-align: left;"></legend>
						<h1><legend class="control-label col-md-12" style=
						"text-align: left;"><%=Folio%></legend></h1>

						<!--    <div class="col-md-3">
                     <legend class="control-label col-md-12" style="text-align: left;"><h1>Fecha: </h1></legend> 
                    </div>-->
					</div>
					<div style="overflow-y: scroll; height:655px; width: auto;">
						<%
						                               
						                                            
						                            %>
						<div class="ibox-content" id="dvPallet">
							<div class="table-responsive">
								<input id="Limiteishon" type="hidden" value="">
								<table class="table shoping-cart-table">
									<tbody>
										<tr>
											<td class="desc">
												<p class="small" id="Mensaje"></p>
												<p class="small" id="SeriePickeada">
												</p><%if(Linea==0){%><input class="btn btn-info btnIngresar" id=
												"btnIngresar" type="button" value="Ingresar pallet"> <%}%>
											</td>
											<td class="desc"><%
											Cantidad_Art = Cantidad_Art - restantes
											%>
												<h3>Articulos por clasificar</h3><%=Cantidad_Art%>
											</td>
											<td class="desc">
												<h3>Pallets</h3>
												<h4><%=PalletsTotales%></h4>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
                        
						<table class="table">
							<thead>
								<tr>
									<th>Pallet</th>
									<th>SKU</th>
									<th>Modelo</th>
									<th>Color</th>
									<th>LPN</th>
									<th>LPN Cliente</th>
									<th>Cantidad</th>
								</tr>
							</thead>
							<tbody>
<%
	if (CliOC_ID > -1) {
	   sSQL ="SELECT a.Pro_ID, p.Pt_ID, p.CliOC_ID, p.TA_ID, p.Cli_ID, p.OC_ID, p.Prov_ID, p.Pt_SKU "
       sSQL += " , p.Pt_Modelo, p.Pt_Color, p.Pt_Cantidad, p.Pt_LPN, p.Pt_LPNCliente  "
       sSQL += " FROM  Recepcion_Pallet p  "
       sSQL += " INNER JOIN Producto a ON a.Pro_SKU=p.Pt_SKU "
	   sSQL += " WHERE IR_ID=" + IR_ID + " "
       sSQL += " AND p.Cli_ID = " + Cli_ID + " AND p.CliOC_ID= " + CliOC_ID
    }
if (OC_ID > -1) {
	sSQL ="SELECT a.Pro_ID, p.Pt_ID, p.CliOC_ID, p.TA_ID, p.Cli_ID, p.OC_ID, p.Prov_ID, p.Pt_SKU, p.Pt_Modelo,"
	sSQL +="p.Pt_Color, p.Pt_Cantidad, p.Pt_LPN, p.Pt_LPNCliente  FROM  Recepcion_Pallet p INNER JOIN Producto a ON a.Pro_SKU=p.Pt_SKU WHERE  "
	sSQL += "  IR_ID=" + IR_ID + "  AND p.Prov_ID=" +Prov_ID + " AND p.OC_ID= " + OC_ID
}

if (Linea > 0) {
	sSQL += " AND Pt_Linea=" + Linea
}
sSQL +=" GROUP BY  a.Pro_ID, p.Pt_ID, p.CliOC_ID, p.TA_ID, p.Cli_ID, p.OC_ID, p.Prov_ID, p.Pt_SKU, p.Pt_Modelo,"
sSQL += "p.Pt_Color, p.Pt_Cantidad, p.Pt_LPN, p.Pt_LPNCliente ORDER BY p.Pt_ID"
var rsPallets = AbreTabla(sSQL, 1, 0)

var Pallet = 0
            while(!rsPallets.EOF){ 
			Pro_ID = rsPallets.Fields.Item("Pro_ID").Value
			 var Pt_ID = rsPallets.Fields.Item("Pt_ID").Value 
			 var Pt_Color = rsPallets.Fields.Item("Pt_Color").Value 
             var Pt_Modelo = rsPallets.Fields.Item("Pt_Modelo").Value 
             var Pt_SKU = rsPallets.Fields.Item("Pt_SKU").Value 
             var Pt_LPN = rsPallets.Fields.Item("Pt_LPN").Value 
			  var Pt_LPNCliente = rsPallets.Fields.Item("Pt_LPNCliente").Value 
			  var Pt_Cantidad = rsPallets.Fields.Item("Pt_Cantidad").Value 
			  	Pallet =Pallet +1
			var Pt = Pt_LPN.charAt(Pt_LPN.length - 1);
		
        %>	
    
            <tr>
           		 <td><%=Pallet%></td>
                <td><%=Pt_SKU%></td>
                <td><%=Pt_Modelo%></td>
                <td><%=Pt_Color%></td>
                <td><%=Pt_LPN%></td>
                 <td><%=Pt_LPNCliente%></td>
                <td><%=Pt_Cantidad%></td>
                <td>
                
                     <span class="pull-right"> <a  data-irid="" data-folio="" class="text-muted btnEditar"><i class="fa fa-pencil fa-fw"></i>&nbsp;<strong></strong></a></span>
                   <span class="pull-right"> <a  data-ptid="<%=Pt_ID%>"  class="text-muted btnEliminar"><i class="fa fa-trash-o"></i>&nbsp;<strong>|</strong></a></span>
                   <span class="pull-right"> <a   data-lpn="<%=Pt_LPN%>" data-folio="<%=Folio%>" class="text-muted btnImprimeLPN"><i class="fa fa-print"></i>&nbsp;<strong>|&nbsp;</strong></a></span>
                <a data-taid="0" data-cliocid="<%=CliOC_ID%>" data-ocid="<%=OC_ID%>" data-provid="<%=Prov_ID%>" data-cliid="<%=Cli_ID%>" data-ptid="<%=Pt_ID%>" data-proid="<%=Pro_ID%>" data-pt="<%=Pt%>"  class="text-muted btnEscaneo"><i class="fa fa-inbox"></i>&nbsp;<strong>Escanear </strong></a>
                
                </td>
            </tr>
        <%	
            rsPallets.MoveNext() 
        }
        rsPallets.Close()
	
   		%>
           
    </tbody>
</table>

                </div>

            </div>
            
        </div>
        
    </div>    
           
                
           


  <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title">
               
         <table class="table">
    <thead>
        <tr>
            <th class="text-center">Pallets</th>
            <th>Escaneo</th>
           
            
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="text-center"><%=Pallet%></td>
            <td>Pendiente</td>
           
          </td>
        </tr>
		 </tbody>
</table>
                     </div>
                    </div>
                   </div>
                </div>
                </div>
</div>


<div class="modal inmodal" tabindex="-1" id="MyBatmanModal" role="dialog">
   <div class="modal-dialog">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header">
                     <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Cerrar</span>
                </button>

            <h5 class="modal-title">Nuevo Pallet</h5>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
             <div class="form-group">

               <label class="control-label col-md-3"><strong>Modelo</strong></label>
<!--                
                Arreglar cambiar por combo
-->                
                <div class="col-md-7">
                <select id="cboProducto" class="form-control agenda">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
            
			<%  
            if(CliOC_ID > -1){
            var sSQL = "SELECT * FROM Producto a "
				   sSQL+="INNER JOIN Cliente_OrdenCompra_EntregaProducto p ON p.Pro_ID=a.Pro_ID  INNER JOIN  Cliente_OrdenCompra_Entrega en ON  en.CliOC_ID = p.CliOC_ID AND en.Cli_ID=p.Cli_ID and en.CliEnt_ID = p.CliEnt_ID WHERE  en.IR_ID = "+ IR_ID
				// p.CliOC_ID = "+CliOC_ID+" AND p.CliEnt_ID = "+CliEnt_ID
            
            }
			if(OC_ID > -1){
				var sSQL = "SELECT * FROM Producto a "
					  sSQL+=	"INNER JOIN Proveedor_OrdenCompra_Articulos p ON p.Pro_ID=a.Pro_ID  WHERE  p.OC_ID = "+OC_ID+" AND p.Prov_ID = "+Prov_ID
            
			}	
			
			rsArt = AbreTabla(sSQL,1,0)
			while (!rsArt.EOF){
				var Pro_ID =  rsArt.Fields.Item("Pro_ID").Value 
				Pro_SKU =  rsArt.Fields.Item("Pro_SKU").Value 
				Pro_Nombre =  rsArt.Fields.Item("Pro_Nombre").Value 
			%>
                  <option data-proid = "<%=Pro_ID%>" value="<%=Pro_SKU%>" ><%=Pro_Nombre%></option>
		  <%	
			 rsArt.MoveNext() 
				}
			rsArt.Close()   	
			%>
                        	</select>
                    </div>
<!--                
                Arreglar
-->                
                    
            </div>
                      
            <div class="form-group">
                <label class="control-label col-md-3"><strong>SKU</strong></label>
                <div id="divSKU"></div>
            </div> 
             <div class="form-group">
                <label class="control-label col-md-3"><strong>Color</strong></label>
                <div class="col-md-3">
                    <input class="form-control agenda" id="Pt_Color" placeholder="" type="text" autocomplete="off" value=""/> 
                </div>
                <label class="control-label col-md-3"><strong>LPN cliente</strong></label>
                <div class="col-md-3">
                    <input class="form-control agenda" id="Pt_LPN" placeholder="" type="text" autocomplete="off" value=""/> 
                    <label  class="control-label col-md-3 agenda" id="Pt_LPN2" value="<%=LPN%>"><strong><%=LPN%></strong></label>
                </div>
            </div>
             <div class="form-group">
                <label class="control-label col-md-3"><strong>Cantidad producto</strong></label>
                <div class="col-md-3">
                    <input class="form-control agenda" id="Pt_Cantidad" placeholder="" type="number" min="1" autocomplete="off" value="1"/> 
                </div>
                
<!--                
                Arreglar
-->                
                    <label class="control-label col-md-3"><strong>Cantidad esperada</strong></label>
                <div class="col-md-3">
                    <input class="form-control agenda" id="Pt_CantidadEsperada" placeholder="" min="1" type="number" autocomplete="off" value="1"/> 
         
               </div>
<!--                
                Arreglar
-->                
               
            </div>
               <div class="form-group" id="divSims"></div>
        
             <div class="form-group">
              <label class="control-label col-md-3"><strong>Articulos Masterbox</strong></label>
                <div class="col-md-3">
                    <input class="form-control agenda" id="CliEnt_CantidadArticulos" placeholder="" min="1" type="number" autocomplete="off" value="1"/> 
                 

                   <!-- <select id="Pt_Linea" class="form-control agenda" style="display:none;">
                        <option value="0" >-</option>
                        <option value="1" >1</option>
                        <option value="2" >2</option>
                        <option value="3" >3</option>
                        <option value="4" >4</option>
                        <option value="5" >5</option>
                        <option value="6" >6</option>
                    </select>-->
                </div>
                  <label class="control-label col-md-3"><strong>Digitos serie</strong></label>
                <div class="col-md-3">
                    <input class="form-control agenda" id="Digitos" placeholder="" type="number" min="1" autocomplete="off" value="1" /> <br/>
                <div id="dvAlfanum"></div>
                </div>
                    </div>
                       <div class="form-group">
                  <label  class="control-label col-md-3"><strong>Ubicacion seleccionada</strong></label>
                <div class="col-md-3">
                            <label id= "lblUbiNombre" type="text" autocomplete="off" value="" />
<!--                <label class="control-label col-md-3" style="display:none;"><strong>Cama Pallet</strong></label>
                <div class="col-md-3">
                    <input class="form-control agenda" id="CamaPallet" placeholder="" type="number" min="1" autocomplete="off" value="1" style="display:none;"/> 
-->                </div>
        </div>
             <div class="form-group">
               <label class="control-label col-md-3" style="display:none;"><strong>Filas Pallet</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="FilasPallet" placeholder="" type="number" min="1" autocomplete="off" value="1" style="display:none;"/> 
               </div>
            </div>
          </div> 
      </div>
      <div class="modal-footer">
                  <input class="form-control inpUbiID" id="inpUbiID" style="display:none;width:55%" placeholder="" type="text" autocomplete="off" value="" />
                <button type="button" class="btn btn-danger" id="BtnCancelar">Cancelar entrega</button>
        	<button type="button" class="btn btn-primary BtnMuestraUbic"  id= "BtnMuestraUbic" data-toggle="modal" data-target="#myModal" onclick=		
         "Ubicacion.SeleccionAvanzadaAbrir({Selector: 'inpUbiID', Etiqueta: 'lblUbiNombre'});">Asignar ubicacion</button>
        <button type="button" class="btn btn-primary" id="BtnGuardar">Guardar</button>
        <button type="button" class="btn btn-danger" id="BtnQuitar">Cerrar</button>
       <!-- <button type="button" class="btn btn-secondary"  id="BtnImprimir" onclick="location.href='http://qawms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?Tipo=3&IR_ID=41';">Imprimir</button>-->
      </div>
    </div>
  </div>


</div>
</div>


<input type="hidden" value="<%=CliOC_ID%>" class="objAco"  id="CliOC_ID">
<input type="hidden" value="<%=Cli_ID%>" class="objAco"  id="Cli_ID">
<input type="hidden" value="<%=OC_ID%>"   class="objAco" id="OC_ID"/>
<input type="hidden" value="<%=Prov_ID%>"   class="objAco" id="Prov_ID"/>
<input type="hidden" value="<%=IR_ID%>"   class="objAco" id="IR_ID"/>
<input type="hidden" value="<%=CliEnt_ID%>"   class="objAco" id="CliEnt_ID"/>
<input type="hidden" value="<%=Folio%>"   class="objAco" id="Folio"/>
<input type="hidden" value="<%=LPN%>"   class="objAco" id="LPN"/>


<%
var urlBase = "/pz/wms/Almacen/"
%>

<script type="text/javascript" src="<%= urlBase %>Catalogo/js/Catalogo.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Area/js/Ubicacion_Area.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Rack/js/Ubicacion_Rack.js"></script>
<script type="application/javascript">


$(document).ready(function() {
	$("#Pt_LPN2").hide();

	$('.btnEscaneo').click(function(e) {
		e.preventDefault()
		var Params = "?CliOC_ID=" + $(this).data("cliocid")
			Params += "&TA_ID=" + $(this).data("taid")   
			Params += "&OC_ID=" + $(this).data("ocid")
			Params += "&Prov_ID=" + $(this).data("provid") 
			Params += "&Cli_ID=" + $(this).data("cliid") 
			Params += "&Pt_ID=" + $(this).data("ptid") 
			Params += "&Pro_ID=" + $(this).data("proid") 
			Params += "&IR_ID=" +  $('#IR_ID').val()
			Params += "&CliEnt_ID=" +  $('#CliEnt_ID').val()
			Params += "&IDUsuario="+$('#IDUsuario').val()
		Params += "&Pallet="+ $(this).data("pt") 
		$("#Contenido").load("/pz/wms/Recepcion/RecepcionRayosX.asp" + Params)
	});
	
	$('#BtnCancelar').click(function(e) {
		e.preventDefault()
		var Params = "?CliOC_ID=" +   $('#CliOC_ID').val()
			Params += "&OC_ID=" +  $('#OC_ID').val()
			Params += "&Prov_ID=" +  $('#Prov_ID').val()
			Params += "&Cli_ID=" +   $('#Cli_ID').val()
			Params += "&Pro_ID=" +  $('#Pro_ID').val()
			Params += "&CliEnt_ID=" +  $('#CliEnt_ID').val()
			Params += "&IDUsuario="+$('#IDUsuario').val()
			Params += "&Tarea=8" 
		$("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp" + Params)
					sTipo = "warning";
			sMensaje = "La entrega del producto ha sido cancelada correctamente ";
			
			Avisa(sTipo,"Aviso",sMensaje);

	});
	

	 function ActualizaProd(proid){
			   if($(".ChkAlf").is(':checked')){
	  var Alfnum =1
	  }else{
	  var Alfnum =0  
 }
	// var ckd = (Checado==true) ? 1 : 0;
	
	$.post("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp"
		  , { Tarea:4,Pro_ID:proid,Alfnum:Alfnum}
		  , function () {
			var sMensaje = "El registro fue actualizado"
		 	//$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,sticky: true,time: 1200});
			Avisa("success","Aviso",sMensaje)
		  }
	);
				
		}

        $('.btnRegresar').click(function(e) {
            e.preventDefault()

            var Params = "?TA_ID=" + $(this).data("taid")
                Params += "&IR_ID=" + $(this).data("irid")
                Params += "&CliOC_ID=" + $(this).data("cliocid")
                Params += "&Cli_ID=" + $(this).data("cliid") 
                Params += "&OC_ID=" + $(this).data("ocid")
                Params += "&Prov_ID=" + $(this).data("provid") 
                Params += "&Pro_ID=" + $(this).data("proid")
                Params += "&Usu_ID=" + $("#IDUsuario").val()
                Params += "&VI=" + $("#VentanaIndex").val()
            
        //    var UsuRol = 
            

            //if( UsuRol == 2 || UsuRol == 3){
			if( $("#IDUsuario").val()==97||$("#IDUsuario").val()==36||$("#IDUsuario").val()==37|| ($("#IDUsuario").val() == 35)){
                //$("#Contenido").load("/pz/wms/BPM/BPM_Recepciones.asp" + Params)
                $("#Contenido").load("/pz/wms/OC/ROC_Recepciones.asp" + Params)
            } else {
                $("#Contenido").load("/pz/wms/Recepcion/RecepcionEscaneo.asp" + Params)
            }
        });

		$('#BtnGuardar').click(function(e) {
        e.preventDefault()

		var datoAgenda = {}
		$('.agenda').each(function(index, element) {
            datoAgenda[$(this).attr('id')] = $(this).val()
        });
		var CliEnt_CantidadPallet =  $('#Pt_Cantidad').val() /  $('#CliEnt_CantidadArticulos').val()
		datoAgenda['Tarea'] = 1
		datoAgenda['CliOC_ID'] = $('#CliOC_ID').val()
		datoAgenda['OC_ID'] = $('#OC_ID').val()
		datoAgenda['Prov_ID'] = $('#Prov_ID').val()
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['CliEnt_ID'] = $('#CliEnt_ID').val()
		datoAgenda['IR_ID'] = $('#IR_ID').val()
		datoAgenda['Pro_ID'] = $('#Pro_ID').val()
		datoAgenda['ProM_ID'] = $('#ProM_ID').val()
		datoAgenda['Pro_ID_RFID'] = $('#cboEtiqueta').val()
		datoAgenda['Pt_Modelo'] = $('#Pt_Modelo').val()
	    datoAgenda['Pt_SKU'] = $('#cboProducto').val()
		datoAgenda['Pt_Cantidad'] = $('#Pt_Cantidad').val()
		datoAgenda['Pt_CantidadEsperada'] = $('#Pt_CantidadEsperada').val()
		datoAgenda['CliEnt_CantidadArticulos'] = $('#CliEnt_CantidadArticulos').val()
		datoAgenda['CliEnt_CantidadPallet'] = CliEnt_CantidadPallet
		datoAgenda['Pt_Color'] = $('#Pt_Color').val()
		datoAgenda['Pt_LPN'] = $('#Pt_LPN').val()	
		datoAgenda['Pt_LPN2'] = $('#Pt_LPN2').text()
		datoAgenda['Pt_Linea'] = $('#Pt_Linea').val()	
		datoAgenda['Pt_Ubicacion'] = $('#lblUbiNombre').text()			
		datoAgenda['Pt_Pallet'] = <%=Cons_Pallet%>	
		datoAgenda['Digitos'] = $('#Digitos').val()
		datoAgenda['DigitosRFID'] = $('#DigitosRFID').val()
		datoAgenda['Pro_Insumo'] = $('#cboEtiqueta').val()	
		datoAgenda['IDUsuario'] = $('#IDUsuario').val()	


		$('#MyBatmanModal').modal('hide')  
		GuardaLPN(datoAgenda)
			if($('#lblUbiNombre').text()	==""){
	//var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?Pt_LPN="+  $('#LPN').val()	+"&Folio="+ $('#Folio').val());
			}else{
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?Pt_LPN="+ $('#LPN').val()+"&FolioOC="+ $('#Folio').val()+"&Tarea=1");
				}
	
		//$('.agenda').val("")
    });
	
	$('#btnIngresar').click(function(e) {
		$('.Robin').attr('disabled',false)
		$('#MyBatmanModal').modal('show')  
	});
	$('.btnImprimeLPN').click(function(e) {
		e.preventDefault()
		RecepImprime($(this).data("lpn"), $(this).data("folio"))
	});

	$('#BtnQuitar').click(function(e) {
        e.preventDefault()
		$('#MyBatmanModal').modal('hide') 
		BorraEvento($('#Event_ID').val())
		$('#calendar').fullCalendar('removeEvents', $('#Event_ID').val());
    });
 			
});

function RecepImprime(lpn, folio){
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?Pt_LPN="+ lpn+"&Folio="+folio);
}

	$('.btnEliminar').click(function(e) {
     	e.preventDefault()
        var datoAgenda = {}
		datoAgenda['Pt_ID'] = $(this).data("ptid")
		datoAgenda['Tarea'] = 5
		$("#dvPallet").load("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp",datoAgenda)
			
	var params = "?CliOC_ID=" + $('#CliOC_ID').val()
		 params += "&OC_ID=" + $('#OC_ID').val()
		 params += "&TA_ID=" + $('#TA_ID').val()
		 params += "&Cli_ID=" + $('#Cli_ID').val()
		 params += "&Prov_ID=" + $('#Prov_ID').val()
		 params += "&CliEnt_ID=" + $('#CliEnt_ID').val()
		 params += "&IR_ID=" + $('#IR_ID').val()
		 params += "&IDUsuario=" + $('#IDUsuario').val()

		$("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet2.asp" + params)
			sTipo = "info";
			sMensaje = "El pallet se ha eliminado correctamente ";
			
			Avisa(sTipo,"Aviso",sMensaje);
	
	});
	
	
function GuardaLPN(Evento){
			$("#dvPallet").load("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp",Evento
		
		
    , function(data, Evento){
	
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
			
	var params = "?CliOC_ID=" + $('#CliOC_ID').val()
		 params += "&OC_ID=" + $('#OC_ID').val()
		 params += "&TA_ID=" + $('#TA_ID').val()
		  params += "&Cli_ID=" + $('#Cli_ID').val()
		 params += "&Prov_ID=" + $('#Prov_ID').val()
		 params += "&CliEnt_ID=" + $('#CliEnt_ID').val()
		 params += "&IR_ID=" + $('#IR_ID').val()
		 params += "&IDUsuario=" + $('#IDUsuario').val()
		 

		$("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet.asp" + params)

});
}
function CargarVentana(Params){
	$("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet.asp" + Params)
}

function UpdateCita(id){
	$.post("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp",{
		Tarea:3
		,IR_ID:id
		,IDUsuario:$("#IDUsuario").val()
	}
    , function(data){
		
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
	
		Avisa(sTipo,"Aviso",sMensaje);
	});
}
function BorraEvento(id){
	$.post("/pz/wms/Recepcion/Recepcion_Ajax.asp",{
		Tarea:4
		,IR_ID:id
		,IDUsuario:$("#IDUsuario").val()
	}
    , function(data){
		if (data == 1) {
			sTipo = "info";
			sMensaje = "El registro borrado exitosamente";
			$('#Event_ID').val("")
			
		} else {
			sTipo = "warning";
			sMensaje = "Ocurrio un error al realizar el guardado";
			
		}
		Avisa(sTipo,"Aviso",sMensaje);
	});
}
$('#cboProducto').change(function(e) {
        e.preventDefault()
		$.get("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp",{
			Tarea:2
			,Pro_SKU:$(this).val()
		}, function(data){
			if (data != "") {
				$('#divSKU').html(data)
				$("#Pt_Modelo").hide();
			} else {
				sTipo = "warning";
				sMensaje = "Ocurrio un error al realizar el guardado";
				Avisa(sTipo,"Aviso",sMensaje);
			}
		});
			var sDatos = "Pro_SKU=" + $(this).val();	 
				sDatos += "&Tarea="+3
		$("#dvAlfanum").load("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp?" + sDatos)
				sDatos = "Pro_SKU=" + $(this).val();	 
				//sDatos += "&Tarea="+7
//		$("#divSims").load("/pz/wms/Recepcion/RecepcionPallet_Ajax.asp?" + sDatos)

});

</script>