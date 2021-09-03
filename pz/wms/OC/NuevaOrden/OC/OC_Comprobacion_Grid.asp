<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
     
	var OC_ID = Parametro("OC_ID",1)
	var OCPar_ID = Parametro("OCPar_ID",-1)  
	var OCParD_ID = -1 

	var sSQLEmp = " SELECT OCPar_EstatusCG97 "
		sSQLEmp += " FROM OrdenCompra_Partida "
		sSQLEmp += " WHERE OC_ID = " + OC_ID
		sSQLEmp += " AND OCPar_ID = " + OCPar_ID
        
	ParametroCargaDeSQL(sSQLEmp,0)

	var OCPar_EstatusCG97 = Parametro("OCPar_EstatusCG97",0) 
	var OCParD_Autorizado = 0

%>
<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th class="text-center">Partida</th>
                <th class="text-center">Fecha</th>
                <th class="text-center">Folio</th>
                <th class="text-center">Importe</th>
                <th class="text-center">Impuestos</th>
                <th class="text-center">Total</th>  
                <th class="text-center">Autorizado</th>         
                <th class="text-center">Saldo</th>
                <th class="text-center">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
            <%
                var iRenglon = 0	
                var Saldo = 0    
                var TImporte = 0          
                var TImpuestos = 0               

                var sSQL = " SELECT OCPar_ID, OCParD_ID, OCParD_Fecha, OCParD_Folio, OCParD_Descripcion, OCParD_Autorizado "
                    sSQL += ", OCParD_Sucursal, OCParD_Importe, OCParD_Impuestos, OCParD_Total"
                    sSQL += ", CONVERT(NVARCHAR(20),OCParD_Fecha,103) AS Fecha "
                    sSQL += " FROM OrdenCompra_Partida_Detalle "
                    sSQL += " WHERE OC_ID = " + OC_ID
                    //sSQL += " AND OCPar_ID = " + OCPar_ID

                var rsRDet = AbreTabla(sSQL,1,0)

                while (!rsRDet.EOF){
                   iRenglon++
                   OCPar_ID = rsRDet.Fields.Item("OCPar_ID").Value
                   OCParD_ID = rsRDet.Fields.Item("OCParD_ID").Value              
                   Saldo += rsRDet.Fields.Item("OCParD_Total").Value
                   TImporte += rsRDet.Fields.Item("OCParD_Importe").Value
                   TImpuestos += rsRDet.Fields.Item("OCParD_Impuestos").Value
                   OCParD_Autorizado = rsRDet.Fields.Item("OCParD_Autorizado").Value
                   if (OCParD_Autorizado==1) {
                       OCParD_Autorizado = "Si"
                   } else {
                       OCParD_Autorizado = "No"
                   }

            %>
            <tr onDblClick="javascript:EditaDocumento(<%=OCParD_ID%>)">
				<td align="center" valign="middle" class="text-center"><h1><%Response.Write(iRenglon)%></h1></td>
                <td colspan="7">
<table width="100%" border="0">
  <tbody>
     
            <tr onDblClick="javascript:EditaDocumento(<%=OCParD_ID%>)">
                
                <td width="80" class="text-left"><%Response.Write(rsRDet.Fields.Item("Fecha").Value)%></td>
                <td width="75" class="text-center"><%Response.Write(rsRDet.Fields.Item("OCParD_Folio").Value)%></td>
                
                 
                <td width="76" class="text-right">
				<%Response.Write(FM + "&nbsp;" + formato(rsRDet.Fields.Item("OCParD_Importe").Value,2))%></td>
                <td width="101" class="text-right">
				<%Response.Write(FM + "&nbsp;" + formato(rsRDet.Fields.Item("OCParD_Impuestos").Value,2))%></td>
               
                <td width="100" class="text-right">
				<%Response.Write(FM + "&nbsp;" + formato(rsRDet.Fields.Item("OCParD_Total").Value,2))%></td>
                 <td width="80" class="text-center"><%=OCParD_Autorizado%>
                 </td>
                  <td width="79" class="text-right">
				<%Response.Write(FM + "&nbsp;" + formato(Saldo,2))%></td>
                
            </tr>
     
    <tr>
      <td colspan="2"><strong>Concepto / Descripci&oacute;n</strong></td>
       <td colspan="8"><%Response.Write(rsRDet.Fields.Item("OCParD_Descripcion").Value)%></td>
     
      </tr>
    <tr>
      <td colspan="2" nowrap><strong>Sucursal / Departamento&nbsp;&nbsp;</strong></td>
      <td colspan="8"><%Response.Write(rsRDet.Fields.Item("OCParD_Sucursal").Value)%></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
      <td colspan="8">&nbsp;</td>
    </tr>
  </tbody>
</table>
				</td>
                <td width="85" align="center" valign="middle" class="text-right footable-visible footable-last-column"><a href="javascript:EditaDocumento(<%=OCPar_ID%>,<%=OCParD_ID%>)">Seleccionar</a></td>
            </tr>
            <%
            	rsRDet.MoveNext() 
            	}
            rsRDet.Close()   
            %>
            <br><div class="hr-line-dashed"></div>   
             <tr>
                <td class="text-center" style="border:none">&nbsp;</td>
                <td class="text-center" style="border:none">&nbsp;</td>
                <td class="text-center" style="border:none">&nbsp;</td>
                <td colspan="2" class="text-center" style="border:none"><strong>TOTAL :</strong></td>
                <td class="text-center" style="border:none"><%Response.Write(FM + "&nbsp;" + formato(TImporte,2))%></td>
                <td class="text-center" style="border:none"><%Response.Write(FM + "&nbsp;" + formato(TImpuestos,2))%></td>
                <td class="text-center" style="border:none"><strong><%Response.Write(FM + "&nbsp;" + formato(Saldo,2))%></strong></td>
                <td class="text-center" style="border:none">&nbsp;</td> 
                    
            </tr>                 
        </tbody>
    </table>
    <div class="hr-line-dashed"></div>
</div>
  
<script language="jscript" type="application/javascript">

	$(document).ready(function() { 
		
		//$("#OCParD_ID").val(-1)
		
	 
//	 	$(".btnVer").click(function(e){
//			e.preventDefault();
//			
//			$("#EVtcD_ID").val($(this).data("evtcdid"))
//			var url = "/pz/mms/Empleado/ViaticosDetFicha.asp"
//			    url += "?OC_ID=0&EVtc_ID=0&EVtcD_ID=" + $(this).data("evtcdid")
//		    $('.modal-content').load(url,function(result){
//				  	$('#ModalConcepto').modal("show")
//			});
//		})
		
	 //	$(".btnBorrar").click(function(e){
//			e.preventDefault();	
//			BorrarGasto($(this).data("evtcdid"))
//		})
//
//		CargaLateral()

    });
	
	function EditaDocumento(p,d){
		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
			sDatos += "&OCPar_ID=" + p;
			sDatos += "&OCParD_ID=" + d; 
			sDatos += "&IDUnica=" + $("#IDUsuario").val()
	 
			var url = "/pz/fnd/OC/OrdenCompra_Documento.asp" + sDatos
			    
		    $('.modal-content').load(url,function(result){
				  	$('#ModalConcepto').modal("show")
			});

	}
	
	
	//function BorrarGasto(ijEVtcDID) {
//
//		$.post("/pz/mms/Empleado/Viaticos_Ajax.asp"
//			   ,{Tarea:5,OC_ID:0,EVtc_ID:0,EVtcD_ID:ijEVtcDID}
//			   ,function(data){
//				  if (data == 1) {
//
//					sTipo = "info";  
//					sMensaje = "El registro fue eliminado correctamente";
//					Avisa("info","Aviso",sMensaje);
//
//					var sDatos = "OC_ID=0";
//						sDatos += "&EVtc_ID=0";  
//					$("#divFicha").load("/pz/mms/Empleado/DatGralesViaticosConsul.asp?" + sDatos);  			
//					$("#divViaticosDet").load("/pz/mms/Empleado/ViaticosDetGrid.asp?" + sDatos);  
//					$("#dvLateral").load("/pz/mms/Empleado/Viatico_Lateral.asp?" + sDatos);	
//
//				  } else {
//					sTipo = "error";   
//					sMensaje = "Ocurrio un error al eliminar el registro";
//					Avisa("warning","Aviso",sMensaje);
//				  }
//
//				});
//	}

</script>