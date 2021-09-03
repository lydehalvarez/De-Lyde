<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var Aud_ID = Parametro("Aud_ID",-1)
	var AudC_ID = Parametro("AudC_ID",-1)
	
	var Tipo = BuscaSoloUnDato("Aud_TipoCG140","Auditorias_Ciclicas","Aud_ID = "+Aud_ID,-1,0);
	if(Tipo == 4){ // Tipo RFID
		
		var sSQLIn = "SELECT a.Pro_ID,Pro_Nombre,Pro_SKU, AudR_IN_Present,AudR_IN_Missing,AudR_OUT_Present"
				+ " FROM Auditorias_Resumen_RFID a, Producto p "
				+ " WHERE a.Pro_ID = p.Pro_ID "
				+ " AND a.Aud_ID = " + Aud_ID
				+ " AND a.AudC_ID = " + AudC_ID
				
				
				
%>				
<div class="row">
    <div class="col-md-12 text-right">
    	 <a class="btn btn-white SyncDCats" onclick='AuditoriaSeleccionLPN.SyncDcats()'><i class="fa fa-refresh"></i>&nbsp;Sincronizar con DCats conteo <%=AudC_ID%></a>
    </div>
</div>
<div class="row">
    <div class="col-md-12">
    <br>
        <table class="table table-hover issue-tracker">
            <tbody>
            <%
            var rsInv = AbreTabla(sSQLIn,1,0)
            if(!rsInv.EOF){
				var Pro_ID = ""
				var Pro_SKU = ""
				var AudR_IN_Present = 0
				var AudR_IN_Missing = 0
				var AudR_OUT_Present = 0
                while(!rsInv.EOF){ 
					Pro_ID = rsInv.Fields.Item("Pro_ID").Value
					Pro_SKU = rsInv.Fields.Item("Pro_SKU").Value
					AudR_IN_Present = rsInv.Fields.Item("AudR_IN_Present").Value
					AudR_IN_Missing = rsInv.Fields.Item("AudR_IN_Missing").Value
					AudR_OUT_Present = rsInv.Fields.Item("AudR_OUT_Present").Value
                %>
                <tr class="articulos" id="<%=SKU%>">
                    <td class="project-title" width="35%">
                        <a class="Move" data-sku="<%=SKU%>">
                        <%=rsInv.Fields.Item("Pro_SKU").Value%>
                        </a>
                        <br  />
                        <small>
                            <%=rsInv.Fields.Item("Pro_Nombre").Value%>
                        </small>
                    </td>
                   <td class="project-title">
                        <a class="Move" data-proid="<%=Pro_ID%>">
                        <%=formato(AudR_IN_Present,0)%>
                        </a>
                        <br  />
                        <small>
                          Encontrados <strong>(in)</strong>
                        </small>
                    </td>
                   <td class="project-title">
                        <a class="Move" data-proid="<%=Pro_ID%>">
                        <%=formato(AudR_IN_Missing,0)%>
                        </a>
                        <br  />
                        <small>
                          Faltantes <strong>(in)</strong>
                        </small>
                    </td>
                   <td class="project-title">
                        <a class="Move" data-proid="<%=Pro_ID%>">
                        <%=formato(AudR_OUT_Present,0)%>
                        </a>
                        <br  />
                        <small>
                          Encontrados <strong>(out)</strong>
                        </small>
                    </td>
             
                </tr>
        <%
                rsInv.MoveNext()
            }
        rsInv.Close()
        %>
        <%
        } else {
        %>
                <tr>
                    <td align="center" class="project-title"><h3>No hay informaci&oacute;n</h3></td>
                </tr>
        <%}%>
            
            
            
            </tbody>
        </table>
	</div>
</div>
				
<%				
	}else{
		var sCondicion = ""
		
		var sSQLIn = "SELECT p.Pro_ID "
				+ " , p.Pro_Nombre as Nombre "
				+ " , p.Pro_Descripcion as Descripcion  " 
				+ " , p.Pro_SKU as SKU  "
				+ " , Aud_ExistenciaCongelada, Aud_ExistenciaCliente, Aud_CuarentenaCongelada, Aud_EnProcesoCongelado  "
				+ ", 0 as Conteo "
				+ " FROM Auditorias_ExistenciasCongeladas a, Producto p "
				+ " WHERE a.Pro_ID = p.Pro_ID "
				+ " AND a.Aud_ID = " + Aud_ID

 //Response.Write(sSQLIn)
         
        
//0	Recibido
//1	Disponible
//2	Cuarentena
//3	Dañado
//4	Descompuesto
//5	Vendido
//10	Devuelto a proveedor
//11	Robado paquetería
//12	Transfiriendose
//13	En tienda
//14	Asignados
//15	Devolucion por falla de entrega
//16	Cancelado
        
%>
<div class="row">
    <div class="col-md-12">
    <br>
        <table class="table table-hover issue-tracker">
            <tbody>
            <%
            var SKU = ""
            var Pro_ID = -1
        
            var Procesandose = 0
            var Inicial = 0
            var Cuarentena = 0
            var Entradas = 0
            var Salidas = 0
            var Conteo = 0
        
            var rsInv = AbreTabla(sSQLIn,1,0)
            if(!rsInv.EOF){
                
                while(!rsInv.EOF){ 
                    SKU = rsInv.Fields.Item("SKU").Value
                    Pro_ID = rsInv.Fields.Item("Pro_ID").Value
        
                    Inicial = rsInv.Fields.Item("Aud_ExistenciaCongelada").Value
                    Procesandose = rsInv.Fields.Item("Aud_EnProcesoCongelado").Value
                    Cuarentena = rsInv.Fields.Item("Aud_CuarentenaCongelada").Value
                %>
                <tr class="articulos" id="<%=SKU%>">
                    <td class="project-title" width="35%">
                        <a class="Move" data-sku="<%=SKU%>">
                        <%=rsInv.Fields.Item("Nombre").Value%>
                        </a>
                        <br  />
                        <small>
                            <%=rsInv.Fields.Item("Descripcion").Value%>
                        </small>
                    </td>
                     <td class="project-title">
                        <a class="actualiza" data-sku="<%=SKU%>" data-skuid="<%=Pro_ID%>"  >
                        <%=SKU%>
                        </a>
                        <br  />
                        <small title="<%=Pro_ID%>">
                         SKU
                        </small>
                    </td>
                   <td class="project-title">
                        <a class="Move" data-sku="<%=SKU%>">
                        <%=formato(Inicial,0)%>
                        </a>
                        <br  />
                        <small>
                          Disponibles
                        </small>
                    </td>
                 
                    <td class="project-title">
        
                        <a class="Move" data-sku="<%=SKU%>">
                           <%=formato(Cuarentena,0)%>
                        </a>
                        <br/>
                        <small>
                            Cuarentena
                        </small>
                    </td>
                   
                   <td class="project-title">
                        <%
                        var color = ""
                        if(Salidas < 0){
                            color = "#F00"
                        } else {
                            color = "#3C6"
                        }
                        %>
                        <a class="Move" data-sku="<%=SKU%>">
                            <span style="color:<%=color%>"><%=formato(Salidas,0)%></span>
                        </a>
                        <br/>
                        <small>
                            Conteo Lyde
                        </small>
                    </td>
                   <td class="project-title">
                        <%
                        var color = ""
                        if(Conteo < 0){
                            color = "#F00"
                        } else {
                            color = "#3C6"
                        }
                        %>
                        <a class="Move" data-sku="<%=SKU%>">
                            <span style="color:<%=color%>"><%=formato(Conteo,0)%></span>
                        </a>
                        <br/>
                        <small>
                            Conteo Cliente
                        </small>
                    </td>
                   <td class="project-title">
                        <a class="Move">
                            <span id="<%=SKU%>_actual">0</span>
                        </a>
                        <br/>
                        <small>
                           Conteo DCats
                        </small>
                    </td>
             
                </tr>
        <%
                rsInv.MoveNext()
            }
        rsInv.Close()
        %>
        <%
        } else {
        %>
                <tr>
                    <td align="center" class="project-title"><h3>No hay informaci&oacute;n</h3></td>
                </tr>
        <%}%>
            
            
            
            </tbody>
        </table>
	</div>
</div>
 
<%
	}
%>
<script type="application/javascript">
    
    $(document).ready(function(){
    
        $('.btnCierra').hide()
        $('.Move').click(function(e) {
            e.preventDefault();
            var SKU = $(this).data('sku')
            $('.articulos').removeClass('bg-primary')
            $('#'+SKU).addClass('bg-primary')
            $('html, body').animate({ scrollTop: $('#'+SKU).offset().top }, 'slow');
        });
        $('.btnDespliega').click(function(e) {
            e.preventDefault();
            $(this).hide('slow')
            var SKU = $(this).data('sku')
            var PROID = $(this).data('proid')
            $('#btnC'+SKU).show('slow')

            $('<tr id="tr_'+SKU+'"><td colspan="6" id="td_'+SKU+'">'+loading+'</td></tr>').insertAfter($(this).closest('tr'));
            var dato = {
                SKU:SKU,
                Pro_ID:PROID,
                Cli_ID:$('#Cli_ID').val() 
            }
            $("#td_"+SKU).load("/pz/wms/Almacen/Inventario/Inventario_Ubicacion.asp", dato);  
        });
        $('.btnCierra').click(function(e) {
            e.preventDefault();
            $(this).hide('slow')
            var SKU = $(this).data('sku')
            $('#btnV'+SKU).show('slow')
            $('#tr_'+SKU).hide('slow')
            setTimeout(function(){
                $('#tr_'+SKU).remove()
            },800)
        });
        
    
        $('.actualiza').dblclick(function(e) {
            e.preventDefault();
            
            var SKU = $(this).data('sku')
            var SKUid = $(this).data('skuid')
            
            $('#btnV'+SKU).show('slow')
            $('#tr_'+SKU).hide('slow').remove()
            $('#btnC'+SKU).hide('slow')
            
            $.post("/pz/wms/Almacen/Inventario/inventario_ajax.asp",{Tarea:3,SKU_ID:SKUid});
            
        });
       
        
        
        
        
    });


</script>

