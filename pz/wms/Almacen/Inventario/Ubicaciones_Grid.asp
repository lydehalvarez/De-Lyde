<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->


<div class="ibox">
    <div class="ibox-title">
        <h5>Inventario Pallets</h5>
          <div class="ibox-tools">
         <a href="#" class="btn btn-primary btnExcel">Exportar inventario a excel</a>
         </div>
    </div>
    <div class="ibox-content">
        <div class="project-list">
            <table class="table table-hover">
                <tbody>
                   <tr>
              		   <td class="project-title">
                       <strong> <spa>Ubicacion</spa></strong>
                       </td>
              		   <td class="project-title">
                       <strong> <spa>LPN</spa></strong>
                       </td>

              		   <td class="project-title">
                       <strong> <spa>SKU</spa></strong>
                       </td>
                        <td class="project-title">
                       <strong> <spa>Producto</spa></strong>
                       </td>
                         <td class="project-title">
                       <strong> <spa>Cantidad</spa></strong>
                       </td>
                       
                       </tr>
                    <%
			  var Pt_LPN =	 Parametro("Pt_LPN","")
			   var Ubi_ID = Parametro("Ubi_ID",-1)
			   var Are_ID = Parametro("Are_ID",-1)
			   var Rac_ID = Parametro("Rac_ID",-1)
			   var Cli_ID = Parametro("Cli_ID",-1)
			   var Pro_SKU = Parametro("Pro_SKU","")

				Pt_LPN = Pt_LPN.replace("'", "-")

				if (Pro_SKU != ""){
						
					var sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU='"+Pro_SKU+"'"
					 var rsProducto = AbreTabla(sSQL,1,0);

					var Pro_ID = rsProducto.Fields.Item("Pro_ID").Value
				}
				
					if (Pt_LPN != ""){
						
					var sSQL = "SELECT Pt_ID FROM Pallet WHERE Pt_LPN='" + Pt_LPN + "'"
					 var rsPallet = AbreTabla(sSQL,1,0);

					var Pt_ID = rsPallet.Fields.Item("Pt_ID").Value
				}
				
					
var sSQL  = "	SELECT  PT.PT_ID, PT.PT_LPN, Pro.Pro_SKU, Pro.Pro_Nombre"
				+	", Ubi.Ubi_Nombre, PT.PT_Cantidad_Actual"
				+	",ISNULL([Ubi_Etiqueta],'') as etiqueta"
				+	" FROM Pallet PT "
				+	" LEFT JOIN Producto Pro ON PT.Pro_ID = Pro.Pro_ID"
				+	" LEFT JOIN Ubicacion Ubi ON PT.Ubi_ID = Ubi.Ubi_ID"
				+ " LEFT JOIN Ubicacion_Area Are "
				+ " ON Ubi.Are_ID = Are.Are_ID "
				+ " LEFT JOIN Inventario_Lote Lot "
				+ " ON PT.Lot_ID = Lot.Lot_ID "
				+	" WHERE  PT.PT_Cantidad_Actual > 0 " 
         		+ " AND Are.Are_AmbientePallet in (0,1,5, 7) "
					 if(Pro_ID > -1){
						sSQL +=  " and PT.Pro_ID = "  + Pro_ID
					  }
					  if(Cli_ID > -1){
						sSQL +=  " AND PT.Cli_ID =" + Cli_ID  
					  }
					 if(Pt_ID > -1){
						sSQL +=  " and PT.Pt_ID = "  + Pt_ID
					 }
					 if(Ubi_ID > -1){
						sSQL +=  " and PT.Ubi_ID = "  + Ubi_ID
					 }
					  if(Are_ID > -1){
						sSQL +=  " and Ubi.Are_ID = "  + Are_ID
					 }
					  if(Rac_ID > -1){
						sSQL +=  " AND Ubi.Rac_ID =" + Rac_ID  
					  }	  
			
	 		  
					
			
//					+ " from Ubicacion u, Pallet pt, Producto p"
//					+ " where pt.Ubi_ID = u.Ubi_ID and p.Pro_ID = pt.Pro_ID"
//					+ " and pt.Ubi_ID > -1"
//					+ " and pt.[PT_Cantidad_Actual] > 0"
//					+ " and u.Ubi_Viva = 1"
//					+ " and pt.[Pt_FechaVacio] is null"
//					+ " AND pt.Ubi_ID in ( SELECT u.Ubi_ID FROM Ubicacion u, Ubicacion_Area a, Ubicacion_Configuracion uc "
//					+ " WHERE u.Are_ID = a.Are_ID and uc.Ubi_ID = u.Ubi_ID "
//					+ " AND uc.Ubi_EsCuarentena = 0 "
//					+ " AND a.Are_AmbientePallet in ( 1, 5))"
				
					//	Response.Write(sSQL)
                        
						var rsRe = AbreTabla(sSQL,1,0)
                        while (!rsRe.EOF){
								
								var Pt_Object = '{PT_ID: '+rsRe.Fields.Item("PT_ID").Value +'}'
                    %>
                <tr>
                    <td class="project-title">
                        <small><%=rsRe.Fields.Item("Ubi_Nombre").Value%></small>
                    </td>
                                    
                    <td class="project-title">
                        <small><%=rsRe.Fields.Item("Pt_LPN").Value%></small>
                    </td>

                    <td class="project-title">
                        <%=rsRe.Fields.Item("Pro_SKU").Value%>
                     </td>
                         <td class="project-title">
                        <%=rsRe.Fields.Item("Pro_Nombre").Value%>
                      
                    </td>

                   <td class="project-title">
                        <%=rsRe.Fields.Item("PT_Cantidad_Actual").Value%>
                      
                    </td>
                    <td>
                    	<a class="btn btn-white btn-sm" title="LPN"
                                 onclick='ImprimirLPN(<%=Pt_Object%>);'>
                                    <i class="fa fa-print"></i> LPN
                                </a>
    						<a class="btn btn-white btn-sm" title="Auditoria"
                                 onclick='ImprimirAuditoria(<%=Pt_Object%>);'>
                                    <i class="fa fa-print"></i> Aud
                                </a>
                </td>
                </tr>
                <%
                        rsRe.MoveNext();
                    }
                    rsRe.Close();
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">
    
    $(document).ready(function(){

   	$('.btnExcel').click(function(e) { 
		var ip = Date()
		$.post("/pz/wms/Almacen/Inventario/ExcelInventario.asp"
               , {  }
               , function(data){
                  
                    var response = JSON.parse(data)
                    var ws = XLSX.utils.json_to_sheet(response);
					var wb = XLSX.utils.book_new(); 
                    XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
                    XLSX.writeFile(wb, ip +"Inventario.xlsx");
                });
	});

          $('.btnVer').click(function(e) {
            e.preventDefault();
             
         //   $("#Aud_ID").val( $(this).data('audid') )
           
            CambiaSiguienteVentana()
 
        });
        
          $("#Rac_ID").change(function(){
            CargaComboUbicacion()
            
        })
        
        
    });

	function ImprimirLPN(){
	
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intPT_ID = ( !(jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;
            var url = "/pz/wms/Almacen/ImpresionLPN.asp?PT_ID="+intPT_ID+"";
        
            window.open(url, "Impresion Papeleta" );
        }

function ImprimirAuditoria(){
	
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intPT_ID = ( !(jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;
            var url = "/pz/wms/Auditoria/Impresion_Papeleta4.asp?PT_ID="+intPT_ID+"";
        
            window.open(url, "Impresion Papeleta" );
        }

</script>



