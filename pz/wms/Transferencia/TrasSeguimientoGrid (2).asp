<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

   var bDebug = false
   var Usu_ID = Parametro("IDUsuario",-1)   
   var TipoBusqueda = Parametro("TB",1)  // 1 por estatus   2 por filtros 
   var TipoEstatus = Parametro("TE",1)  //1 Por autorizar  2 Autorizadas para pago 3 abiertas
   
   var TituloGrid = "Resultado de la b&uacute;squeda por filtro"  
   
   var BusProv_Nombre = Parametro("BusProv_Nombre","")
   var BusOC_Folio = Parametro("BusOC_Folio","")
   var BusProv_RFC = Parametro("BusProv_RFC","")
   var BusOC_EstatusCG51 = Parametro("BusOC_EstatusCG51",-1)
		
   var sCondOC = ""
   
    var sSQLOC = "SELECT Prov_ID, OC_ID, OC_Folio, OC.OC_UsuIDOriginador "
        sSQLOC += ", dbo.fn_Proveedor_DameNombre(OC.Prov_ID) AS NOMPROV, OC.OC_Descripcion "
        sSQLOC += ", OC.OC_Total, CONVERT(NVARCHAR(20),OC.OC_FechaElaboracion,103) AS FechaElaboracion "
        sSQLOC += ", (SELECT U.Usu_Nombre FROM Usuario U WHERE U.Usu_ID = OC.OC_UsuIDOriginador) AS Elaboro "
        sSQLOC += ", CONVERT(NVARCHAR(20),OC.OC_FechaAutorizada,103) AS FechaAutorizada "
        sSQLOC += ", CONVERT(NVARCHAR(20),OC.OC_FechaRequerida,103) AS FechaRequerida "
        sSQLOC += ", CONVERT(NVARCHAR(20),OC.OC_FechaRevision1,103) AS FechaRevision1 "
        sSQLOC += ", (SELECT U.Usu_Nombre FROM Usuario U WHERE U.Usu_ID = OC.OC_UsuIDAutorizador1) AS Autorizo "
        sSQLOC += " FROM OrdenCompra OC " 
		
if(TipoBusqueda == 1 ) {
	   	if(TipoEstatus == 1) { 
		   TituloGrid = "Ordenes de compra por autorizar"
		   sSQLOC += " WHERE OC_EstaPagado = 0 "
	       sSQLOC += " AND OC_Autorizada = 0 "
		   sSQLOC += " AND OC_PorAutorizar1 = 1 "
		}
	   	if(TipoEstatus == 2) { 
		   TituloGrid = "Ordenes de compra autorizadas para pago"
		   sSQLOC += " WHERE OC_EstaPagado = 0 "
		   sSQLOC += " AND OC_Autorizada = 1 "
		   sSQLOC += " AND OC_PorAutorizar2 = 1 "
		}
	   	if(TipoEstatus == 3) { 
		   TituloGrid = "Ordenes de compra abiertas, en proceso de entregas y pagos concurrentes"
		   sSQLOC += " WHERE OC_EstaPagado = 2 "
		   sSQLOC += " AND OC_Autorizada = 1 "
		}
} 	
if(TipoBusqueda == 2 ) {
		sSQLOC += " WHERE OC_EstaPagado = 0 " 

        if (BusProv_Nombre != "") {
            sSQLOC += " AND ( OC.Prov_ID IN (SELECT PROVI.Prov_ID "
			sSQLOC +=                        " FROM Proveedor PROVI "
			sSQLOC += 					    " WHERE PROVI.Prov_Nombre LIKE '%"+ BusProv_Nombre +"%' "
			sSQLOC +=                          " OR PROVI.Prov_RazonSocial LIKE '%"+ BusProv_Nombre +"%'))"
        }   

        if (BusOC_Folio != "") {
            sSQLOC += " AND OC.OC_Folio LIKE '%"+ BusOC_Folio +"%'" 
        } 
   
        if (BusProv_RFC != "") {
            sSQLOC += " AND OC.Prov_ID IN (SELECT PROVI.Prov_ID FROM Proveedor PROVI WHERE PROVI.Prov_RFC LIKE '%"+ BusProv_RFC +"%')"
        }    

        if (BusOC_EstatusCG51 > -1) {
            sSQLOC += " AND OC.OC_EstatusCG51 = "+ BusOC_EstatusCG51
        }     
		
}

        if(bDebug){ Response.Write(sSQLOC) }
%>

<div class="wrapper wrapper-content animated fadeInRight">
  <div class="row">
    <div class="col-lg-12">
      <div class="ibox">
        <div class="ibox-title">
          <h5><%=TituloGrid%></h5>
          <!--div class="ibox-tools">
            <a class="btn btn-primary btn-xs" href="">Add new issue</a>
          </div-->
        </div>
        <div class="ibox-content">
          <!--div class="m-b-lg">
            <div class="input-group">
              <input class=" form-control" placeholder="Search issue by name..." type="text"> <span class="input-group-btn"><button class="btn btn-white" type="button"><span class="input-group-btn">Search</span></button></span>
            </div>
            <div class="m-t-md">
              <div class="pull-right">
                <button class="btn btn-sm btn-white" type="button"><i class="fa fa-comments"></i></button> <button class="btn btn-sm btn-white" type="button"><i class="fa fa-user"></i></button> <button class="btn btn-sm btn-white" type="button"><i class="fa fa-list"></i></button> <button class="btn btn-sm btn-white" type="button"><i class="fa fa-pencil"></i></button> <button class="btn btn-sm btn-white" type="button"><i class="fa fa-print"></i></button> <button class="btn btn-sm btn-white" type="button"><i class="fa fa-cogs"></i></button>
              </div><strong>Found 61 issues.</strong>
            </div>
          </div-->
          <div class="table-responsive">
            <table class="table table-hover issue-tracker">
              <tbody>
                 <%  
                    //var sSQL = "SELECT * FROM dbo.ufn_OC_PorPagar(" + Usu_ID + ")"
                    var Llaves = ""
                    
                    var OC_Folio = ""
                    var Proveedor = ""
                    var FechaElaboracion = ""
                    var Elaboro = ""
                    var OC_Descripcion = ""
                    var FechaAutorizada = ""
                    var FechaRequerida = ""
                    var FechaRevision1 = ""
                    var Autorizo = ""
                    var OC_Total = 0
                    
                    var iRenglon = " fist-item"
                    var iReg = 0

                    var rsOC = AbreTabla(sSQLOC,1,0)
                    
                    while (!rsOC.EOF){ 
                        iReg++	 
                        Llaves = "" + rsOC.Fields.Item("Prov_ID").Value
                        Llaves += "," + rsOC.Fields.Item("OC_ID").Value

                        OC_Folio  = rsOC.Fields.Item("OC_Folio").Value
                        Proveedor = rsOC.Fields.Item("NOMPROV").Value
                        FechaElaboracion = rsOC.Fields.Item("FechaElaboracion").Value
                        Elaboro = rsOC.Fields.Item("Elaboro").Value
                        OC_Descripcion = rsOC.Fields.Item("OC_Descripcion").Value
                        FechaAutorizada = rsOC.Fields.Item("FechaAutorizada").Value
                        FechaRequerida = rsOC.Fields.Item("FechaRequerida").Value
                        FechaRevision1 = rsOC.Fields.Item("FechaRevision1").Value
                        Autorizo = rsOC.Fields.Item("Autorizo").Value
                        OC_Total = formato(rsOC.Fields.Item("OC_Total").Value,2)
                    	
                        	

                %>                  
                <tr>
                	<td class="text-left"><div style="font-size: xx-large;text-align:center">
                        	<span class="text-navy"><%=iReg%></span>
                        </div>
                   	
                   </td>
                   <td style="width:80%">
                   <div class="row">
                   		<div class="col-md-9">
                        	<span class="text-navy"><h3>Folio: <%=OC_Folio%> - <%=Proveedor%></h3></span>
                            <h3><%=OC_Descripcion%></h3>
                        </div>
                        <div class="col-md-3" 
                             style="font-size: xx-large;padding-right: 35px;text-align:right">
                        	<span class="text-navy">$<%=OC_Total%></span>
                        </div>
                   </div>
                   <div class="row">
<small>     <i class="fa fa-lightbulb-o"> </i>&nbsp;<strong>Elaboraci&oacute;n:</strong> <%=FechaElaboracion%>
&nbsp;&nbsp;<i class="fa fa-user-o"> </i>&nbsp;<strong>Elabor&oacute;:</strong> <%=Elaboro%>              
&nbsp;&nbsp;<i class="fa fa-calendar"> </i>&nbsp;<strong>Requerida para:</strong> <%=FechaRequerida%>
&nbsp;&nbsp;<i class="fa fa-eye"> </i>&nbsp;<strong>Revisada:</strong> <%=FechaRevision1%>
&nbsp;&nbsp;<i class="fa fa-calendar-check-o"> </i>&nbsp;<strong>Autorizada:</strong> <%=FechaAutorizada%>&nbsp;&nbsp;<i class="fa fa-black-tie"> </i>&nbsp;<strong>Autorizo:</strong> <%=Autorizo%></small> 
                    </div>
                   </td>
                   
                   <td >
                   	<button class="btn btn-white btn-xs btnVerOC" data-llaves="<%=Llaves%>">
                        <i class="fa fa-external-link"></i> Ver Orden de compra</button>
                   </td>
                </tr>
                <%
                        iRenglon = ""
                        rsOC.MoveNext() 
                    }
                    rsOC.Close()   

                    //if(iReg == 0) {
                %>                     
                     
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
 
<input type="hidden" id="Prov_ID" name="Prov_ID" value="" />
<input type="hidden" id="OC_ID" name="OC_ID" value="" />
                       
<script language="JavaScript">
<!--


$(document).ready(function() { 

	$(".btnVerOC").click(function(e) {
        e.preventDefault()
		var llaves = $(this).data("llaves")
		var arr = llaves.split(",");
		$("#Prov_ID").val(arr[0])
		$("#OC_ID").val(arr[1])
		CambiaSiguienteVentana(430);
    });


});	
-->
</script>