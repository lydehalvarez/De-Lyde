<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

var Tarea = Parametro("Tarea",0)
var IDUsuario = Parametro("IDUsuario",-1)
var Cantidad_MB =  parseInt(Parametro("Cantidad_MB",-1))
var Cantidad_Pallet =  parseInt(Parametro("Cantidad_Pallet",-1))
var Pro_ID = Parametro("Pro_ID",-1)
var PalID = Parametro("PalID",-1)
var MBID = Parametro("MBID",-1)
var sResultado = 0

 var sSQL = "SELECT Pro_Cantidad FROM Producto_Relacion WHERE Pro_ProdRelacionado = "+MBID+" AND  Pro_ID =" +Pro_ID
	var rsMB = AbreTabla(sSQL,1,0)
	if((!rsMB.EOF)){
	Cantidad_MB = rsMB.Fields.Item("Pro_Cantidad").Value
	}
	var sSQL = "SELECT Pro_Cantidad FROM Producto_Relacion WHERE Pro_ProdRelacionado = "+PalID+" AND  Pro_ID =" +Pro_ID
	var rsPallet = AbreTabla(sSQL,1,0)
	if((!rsPallet.EOF)){
	Cantidad_Pallet = rsPallet.Fields.Item("Pro_Cantidad").Value
	}
switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
			bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
		break; 
		case 1:	//Guarda carga de producto
        
            var Cli_ID = Parametro("Cli_ID",-1)
            var CliOC_ID = Parametro("CliOC_ID",-1)
            var CliEnt_ID = Parametro("CliEnt_ID",-1)
            var PalID = Parametro("PalID",-1)
            var MBID = Parametro("MBID",-1)

			try {  
   
             
   
				var sSQL = "IF NOT EXISTS(SELECT 1 FROM Cliente_OrdenCompra_EntregaProducto "
                         + " WHERE Cli_ID = " + Cli_ID + " AND CliOC_ID = " + CliOC_ID
                         + "  AND CliEnt_ID = " + CliEnt_ID + " AND Pro_ID = " + Pro_ID + ")"
                         + "INSERT INTO Cliente_OrdenCompra_EntregaProducto(Cli_ID, CliOC_ID"
                         + ", CliEnt_ID, Pro_ID, CliEnt_TipoPalet, CliEnt_TipoMasterBox, CliEnt_CantidadArticulos, CliEnt_CantidadPallet) "
                         + " VALUES (" + Cli_ID + "," + CliOC_ID 
                         + "," + CliEnt_ID + "," + Pro_ID + "," + PalID + "," + MBID + ", "+Cantidad_MB+", "+Cantidad_Pallet+")"

				 Ejecuta(sSQL,0)
				  sSQL = "IF  EXISTS(SELECT 1 FROM Cliente_OrdenCompra_EntregaProducto "
                         + " WHERE Cli_ID = " + Cli_ID + " AND CliOC_ID = " + CliOC_ID
                         + "  AND CliEnt_ID = " + CliEnt_ID + " AND Pro_ID = " + Pro_ID + ")"
                         + "UPDATE  Cliente_OrdenCompra_EntregaProducto SET CliEnt_TipoPalet="+PalID+", CliEnt_TipoMasterBox=" + MBID + ", 	"									
						 + "CliEnt_CantidadArticulos="+Cantidad_MB+", CliEnt_CantidadPallet="+Cantidad_Pallet+"  WHERE Cli_ID = " + Cli_ID + " AND CliOC_ID = "                         + CliOC_ID+"  AND CliEnt_ID = " + CliEnt_ID + " AND Pro_ID = " + Pro_ID 
						  Ejecuta(sSQL,0)
				 sResultado = 1
				
			} catch(err) {
			}
			break; 
		case 2:	//Carga datos basicos en carga de series		
					if(Cantidad_MB !=-1 && Cantidad_Pallet != -1){
	%>
     <table class="table">
    <thead>
        <tr>
            <th class="text-center"> Articulos por Masterbox</th>
          <th class="text-center">Masterbox por Pallet</th>
        </tr>
    </thead>
    <tbody>
     <tr>
       <td class="text-center"><%=Cantidad_MB%> </td>
       <td class="text-center"><%=Cantidad_Pallet%></td>
</tr>
		 </tbody>
</table>   
                        <input type="text" value="<%=Cantidad_MB%>" style="display:none;width:150%"  class="objAco agenda"  id="Cantidad_MB">
                        <input type="text" value="<%=Cantidad_Pallet%>" style="display:none;width:150%"  class="objAco agenda"  id="Cantidad_Pallet">

			<%
					}
			break; 
			case 3: //Recepcion_CargaSeries.asp
			
			
			%>
               <div class="form-group">
               <label class="control-label col-md-2" id = "lblMB">Masterbox</label>
                <div class="col-md-7" >
			 <select id="cboMB" class="form-control agenda">
                        <option value="-1" >--Seleccionar--</option>
<%
var ProR_ID = Parametro("Pro_ID",-1)
var sSQL1  = "SELECT p.Pro_ID, r.Pro_Cantidad, Pro_Nombre, Pro_DimAlto, Pro_DimLargo, Pro_DimAncho, "
	    sSQL1 += "Pro_PesoBruto,Pro_PesoNeto FROM Producto p INNER JOIN Producto_Relacion r ON r.Pro_ProdRelacionado = p.Pro_ID "
		 sSQL1 += "WHERE TPro_ID = 4 AND r.Pro_ID = "+  ProR_ID
	 var rsMB = AbreTabla(sSQL1,1,0)
if(!rsMB.EOF){
   while (!rsMB.EOF){
	      var Pro_ID =  rsMB.Fields.Item("Pro_ID").Value 
		  Pro_Cantidad =  rsMB.Fields.Item("Pro_Cantidad").Value 
	      Pro_Nombre =  rsMB.Fields.Item("Pro_Nombre").Value 
		  Pro_DimAlto =  rsMB.Fields.Item("Pro_DimAlto").Value
		  Pro_DimLargo =  rsMB.Fields.Item("Pro_DimLargo").Value
		  Pro_DimAncho =  rsMB.Fields.Item("Pro_DimAncho").Value
		  Pro_PesoNeto =  rsMB.Fields.Item("Pro_PesoNeto").Value
 
%>
            <option  value="<%=Pro_ID%>"><%=Pro_Nombre%> (cantidad cajas: <%=Pro_Cantidad%>, alto: <%=Pro_DimAlto%> cm, largo:<%=Pro_DimLargo%> cm, ancho:<%=Pro_DimAncho%> cm, peso: <%=Pro_PesoNeto%> kg)</option>
<%	
          rsMB.MoveNext() 
	}
    rsMB.Close()  
		   }
%>
                    </select>
                      </div>
                <div class="col-md-3">
                   <div class='external-event navy-bg' id="NvoMB"  style="width:65%;display:none">+ Nuevo</div>
                </div>
                </div>
                 <div class="form-group">
              
                     <label class="control-label col-md-2" id="lblPallet" >Pallet</label>
                  <div class="col-md-7">
                    <select id="cboPallet" class="form-control agenda" >
                        <option value="-1"  >--Seleccionar--</option>
<%
	var sSQL1  = "SELECT p.Pro_ID, r.Pro_Cantidad, Pro_Nombre, Pro_DimAlto, Pro_DimLargo, Pro_DimAncho, "
	    sSQL1 += "Pro_PesoBruto,Pro_PesoNeto FROM Producto p INNER JOIN Producto_Relacion r ON r.Pro_ProdRelacionado = p.Pro_ID " 
		 sSQL1 += "WHERE TPro_ID = 5  AND r.Pro_ID = "+ProR_ID
	 var rsPt = AbreTabla(sSQL1,1,0)
	 if(!rsPt.EOF){
     while (!rsPt.EOF){
          var Pro_ID =  rsPt.Fields.Item("Pro_ID").Value 
    	  Pro_Cantidad =  rsPt.Fields.Item("Pro_Cantidad").Value 
	      Pro_Nombre =  rsPt.Fields.Item("Pro_Nombre").Value 
		  Pro_DimAlto =  rsPt.Fields.Item("Pro_DimAlto").Value
		  Pro_DimLargo =  rsPt.Fields.Item("Pro_DimLargo").Value
		  Pro_DimAncho =  rsPt.Fields.Item("Pro_DimAncho").Value
		  Pro_PesoNeto =  rsPt.Fields.Item("Pro_PesoNeto").Value
	
%>

          <option value="<%=Pro_ID%>"><%=Pro_Nombre%> (cantidad cajas: <%=Pro_Cantidad%>, alto: <%=Pro_DimAlto%> cm, largo:<%=Pro_DimLargo%> cm, ancho:<%=Pro_DimAncho%> cm, peso: <%=Pro_PesoNeto%> kg)</option>
<%	
                rsPt.MoveNext() 
            }
        rsPt.Close()  
		  }
%>
                    </select> 
                    </div>
                    <div class="col-md-3">
                    <div class='external-event navy-bg' id="NvoPallet" style="width:65%;display:none">+ Nuevo</div>
                    </div>
            </div>
		<%
		break;
		case 4:  //Recepcion_Supervisor.asp

		break;
		case 6:
		
		break;
        }


%>

<script type="application/javascript">


$(document).ready(function() {

  $('#cboPallet').on('change',function(e) {
		  	 var dato = {}
		  	dato['Tarea'] = 4
			dato['Pro_ID'] =$('#cboPro_ID').val()
            dato['MBID'] = $('#cboMB').val()
		  	dato['PalID'] = $('#cboPallet').val()
		  	$("#divCantidades").load("/pz/wms/Recepcion/Ajax.asp",dato);

	});
	});
	$('.BtnMB').click(function(e) {
		e.preventDefault()
		
		var Params = "?Tarea=" + 6
		Params += "&MB=" +$(this).data("mb") 
		Params += "&Pt_ID=" + $(this).data("ptid") 

		$("#divSeries").load("/pz/wms/Recepcion/Ajax.asp" + Params)
	});



</script>            