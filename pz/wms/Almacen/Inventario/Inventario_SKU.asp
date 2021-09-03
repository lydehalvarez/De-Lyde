<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%

	var Cli_ID = Parametro("Cli_ID",-1)
	var Alm_ID = Parametro("Alm_ID",-1)
	var Pro_SKU = Parametro("Pro_SKU","")
    var Serie = Parametro("Serie","")
    var Nombre = Parametro("Nombre","")
    var Estatus = Parametro("Estatus",-1)
	var sCondicion = ""

//    if((Alm_ID == -1) && (Cli_ID > 0) ) {
//        var sCond = "Alm_TipoCG84 = 1 and Inm_ID = 1 and Cli_ID = " + Cli_ID
//        Alm_ID = BuscaSoloUnDato("Alm_ID","Almacen",sCond,0,0) 
//    }
	if(Alm_ID > -1){ 
		sCondicion = " AND a.Alm_ID = "+Alm_ID
	}
//	if(Cli_ID > -1){
//		sCondicion = " AND a.Cli_ID = "+Cli_ID
//	}
	if(Serie != ""){
		sCondicion += " AND ( a.Inv_Serie = '" + Serie + "' OR Inv_IMEI2 = '" + Serie + "' ) "
	}    
	if(Nombre != ""){
		sCondicion += " AND a.Pro_ID in ( select Pro_ID from Producto p where p.Pro_Nombre like '%" + Nombre + "%' ) "
	}     
	if(Pro_SKU != ""){
		sCondicion += " AND a.Pro_ID in ( select Pro_ID from Producto p where p.Pro_SKU like '" + Pro_SKU + "%' ) "
	}   
	if(Estatus > -1 ){
		sCondicion += " AND a.Inv_EstatusCG20 = " + Estatus
	}     
 
    var sSQLIn = "SELECT b.Pro_ID "
		        + " , b.Pro_Nombre as Nombre "
		        + " , b.Pro_Descripcion as Descripcion  " 
		        + " , b.Pro_SKU as SKU  "
		        + " , COUNT(*) AS Inicial  "
                + " , SUM( CASE WHEN a.Inv_EstatusCG20 in (1,14) AND a.Inv_EnAlmacen = 1 THEN 1 ELSE 0 END )  AS Disponible "
				+ " , SUM( CASE WHEN a.Inv_EstatusCG20 = 1 AND a.Inv_EnAlmacen = 1 AND (a.Inv_EsApartado = 1 or a.Inv_EnTransferencia = 1) THEN 1 ELSE 0 END ) AS Comprometido "
				+ " , SUM( CASE WHEN a.Inv_EstatusCG20 = 1 AND a.Inv_EnAlmacen = 1 AND a.Inv_EsApartado = 0 THEN 1 ELSE 0 END ) AS NoComprometido "
        
//		        + " , CASE WHEN a.Cli_ID = 2 " 
//                      +  " THEN SUM( CASE WHEN a.Inv_EstatusCG20 = 1 AND a.Inv_EnAlmacen = 1 AND a.Alm_ID = 3 " 
//                                 + " THEN 1 ELSE 0 END ) "
//                      +  " ELSE SUM( CASE WHEN a.Inv_EstatusCG20 = 1 AND a.Inv_EnAlmacen = 1 "
//                                                                                //  ROG  8/3/21  los limbos son disponibles
//                                                                               //   AND a.Pt_ID not in (2006,2002) 
//                                 + " THEN 1 ELSE 0 END ) "
//                 + " END AS Disponible "
		        + " , SUM( CASE WHEN a.Inv_EstatusCG20 = 2 THEN 1 ELSE 0 END ) AS Cuarentena "
		     // + " , SUM( CASE WHEN a.Inv_EnAlmacen = 0 THEN 1 ELSE 0 END ) AS Surtido  "
		        + " FROM Inventario a, Producto b "
		        + " WHERE a.Pro_ID = b.Pro_ID "
		        + " AND a.Cli_ID = " + Cli_ID        
		        + " AND a.Inv_EnAlmacen in (0,1) "
		     // + " AND a.Inv_EnAlmacen > 0 "
            //  + " AND a.Inv_EstatusCG20 in (0, 1, 2)"
		        +  sCondicion
		        +  " GROUP BY a.Cli_ID,b.Pro_ID, b.Pro_Nombre, b.Pro_Descripcion, b.Pro_SKU  "
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


<table class="table table-hover issue-tracker">
    <tbody>
    <%
    var TotalInv = 0
    var TotalDisponible = 0
    var TotalActual = 0
    var TotalEnAlmacen = 0
    var TotalSurtida = 0
    var TotalCuarentena = 0
	var TotalComprometido = 0
	var TotalNoComprometido = 0
    var SKU = ""
    var Pro_ID = -1
    var Inicial = 0
    var Disponible = 0
    var Surtido = 0
    var Cuarentena = 0
	var Comprometido = 0
	var NoComprometido = 0

	var rsInv = AbreTabla(sSQLIn,1,0)
	if(!rsInv.EOF){
		
		while(!rsInv.EOF){ 
            SKU = rsInv.Fields.Item("SKU").Value
            Pro_ID = rsInv.Fields.Item("Pro_ID").Value

            Inicial = rsInv.Fields.Item("Inicial").Value
            Disponible = rsInv.Fields.Item("Disponible").Value
            Cuarentena = rsInv.Fields.Item("Cuarentena").Value
            Surtido =  Inicial - Disponible - Cuarentena
			Comprometido = rsInv.Fields.Item("Comprometido").Value
			NoComprometido = rsInv.Fields.Item("NoComprometido").Value
            
            TotalInv += Inicial
            TotalDisponible += Disponible
            TotalSurtida += Surtido
            TotalCuarentena += Cuarentena
			TotalComprometido += Comprometido
			TotalNoComprometido += NoComprometido
		
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
				<small title="Total de piezas recibidas">
				  Cantidad Total
				</small>
			</td>
          <td class="project-title">
				<a class="Move" data-sku="<%=SKU%>">
				<%=formato(Disponible,0)%>
				</a>
				<br  />
				<small title="Cantidad de piezas que pueden ser asignadas a una venta o transferencia">
					Diponible
				</small>
			</td>
            <td>
				<a class="Move" data-sku="<%=SKU%>">
				<%=formato(Comprometido,0)%>
				</a>
				<br  />
				<small title="Cantidad de piezas que estan disponibles pero seran usadas en una orden de venta o una transferencia por surtir">
					Comprometido
				</small>
			</td>
            <td class="project-title">
				<%
				var color = ""
				if(Surtido < 0){
					color = "#F00"
				} else {
					color = "#3C6"
				}
				%>
				<a class="Move" data-sku="<%=SKU%>">
                    <span style="color:<%=color%>"><%=formato(Surtido,0)%></span>
				</a>
                <br/>
				<small title="Cantidad de piezas surtidas a una orden de venta o transferencia y ya no estan disponibles">
					Surtido
				</small>
			</td>
            <td class="project-title">
				<%
				var color = ""
				if(Cuarentena < 0){
					color = "#F00"
				} else {
					color = "#3C6"
				}
				%>
				<a class="Move" data-sku="<%=SKU%>">
                    <span style="color:<%=color%>"><%=formato(Cuarentena,0)%></span>
				</a>
                <br/>
				<small  title="Cantidad de piezas en almacen pero estan separadas de lo disponible por tener un detalle a revisar">
					Cuarentena
				</small>
			</td>
			<td class="text-right">
				<button class="btn btn-danger btnCierra btn-xs" id="btnC<%=SKU%>" 
                        data-sku="<%=SKU%>" 
                        data-proid="<%=Pro_ID%>">Cierra</button>
				<button class="btn btn-info btnDespliega btn-xs" id="btnV<%=SKU%>" 
                        data-proid="<%=Pro_ID%>"
                        data-sku="<%=SKU%>">Ver</button>
			</td>
	 
		</tr>
<%
		rsInv.MoveNext()
	}
rsInv.Close()
%>
		<tr class="articulos" id="<%=SKU%>">
			<td class="project-title">&nbsp;
                
			</td>
			 <td class="project-title">
                Total
			</td>
		   <td class="project-title">
				<a class="Move">
				<%=formato(TotalInv,0)%>
				</a>
				<br  />
				<small>
				  Total ingresado
				</small>
			</td>
			  <td class="project-title">
				<a class="Move">
				<%=formato(TotalDisponible,0)%>
				</a>
				<br  />
				<small>
				 Total Disponible
				</small>
			</td>
            <td class="project-title">
				<a class="Move">
				<%=formato(TotalComprometido,0)%>
				</a>
				<br  />
				<small>
				 Total Comprometido
				</small>
			</td>
            <td class="project-title">
				<a class="Move">
				<%=formato(TotalSurtida,0)%>
				</a>
				<br  />
				<small>
				 Total surtido
				</small>
			</td>
		  <td class="project-title">
				<a class="Move">
				<%=formato(TotalCuarentena,0)%>
				</a>
				<br  />
				<small>
				 Total cuarentena
				</small>
			</td>
	 
		</tr>
<%
} else {
%>
		<tr>
			<td align="center" class="project-title"><h3>Sin inventario, revise sus filtros de b&uacute;squeda</h3></td>
		</tr>
<%}%>
    
    
    
    </tbody>
</table>
 

<script type="application/javascript">
    
    
var loading = '<div class="spiner-example">'
					+'<div class="sk-spinner sk-spinner-three-bounce">'
						+'<div class="sk-bounce1"></div>'
						+'<div class="sk-bounce2"></div>'
						+'<div class="sk-bounce3"></div>'
					+'</div>'
				+'</div>'
    
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

    });


</script>

