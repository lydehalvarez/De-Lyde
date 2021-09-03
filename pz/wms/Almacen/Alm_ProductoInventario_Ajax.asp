<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var Tarea = Parametro("Tarea",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)
	var Alm_ID = Parametro("Alm_ID",-1)
   
   
    var result = ""
    var message = ""
    var iTot = 0
   
	switch (parseInt(Tarea)) {
		case 1://total recibido
           
           var sSQLTot = "select COUNT(*) "
                       + " from Inventario " 
                       + " where Pro_ID = " + Pro_ID
                       + " and Inv_Dummy = 0 "
                       + " and Cli_ID = " + Cli_ID

            var rsTot = AbreTabla( sSQLTot, 1 , 0 )

            if(!rsTot.EOF){
                iTot = rsTot.Fields.Item(0).Value
            }
            rsTot.close() 
        
            result = formato(iTot,0)  
   
        break;
		case 2:  //Global Disponibles
   
           var sSQLTot = "select COUNT(*) "
                       + " from Inventario " 
                       + " where Pro_ID = " + Pro_ID
                       + " and Inv_Dummy = 0 "
                       + " and Inv_EstatusCG20 = 1 "
                       + " and Cli_ID = " + Cli_ID

            var rsTot = AbreTabla( sSQLTot, 1 , 0 )

            if(!rsTot.EOF){
                iTot = rsTot.Fields.Item(0).Value
            }
            rsTot.close() 
        
            result = formato(iTot,0)  
   
        break;
		case 3:  //total de SO  de ventas cliente
   
           var sSQLTot = "SELECT sum( OV_Cantidad ) "
                       + " FROM Orden_Venta o,Orden_Venta_Articulo a "
                       + " WHERE Pro_ID = " + Pro_ID
                       + " AND o.OV_ID = a.OV_ID "
                       + " AND o.Cli_ID = " + Cli_ID

            var rsTot = AbreTabla( sSQLTot, 1 , 0 )

            if(!rsTot.EOF){
                iTot = rsTot.Fields.Item(0).Value
            }
            rsTot.close() 
        
            result = formato(iTot,0)  
   
        break;
		case 4:  //total de articulos comprometidos (apartados)
   
           var sSQLTot = "SELECT count(*) "
                       + " FROM inventario "
                       + " WHERE Pro_ID = " + Pro_ID
                       + " AND Alm_ID = 3 "
                       + " AND Cli_ID = " + Cli_ID
                       + " AND Inv_EnAlmacen = 1 "
                       + " AND Inv_EsApartado = 1 "
   
            var rsTot = AbreTabla( sSQLTot, 1 , 0 )

            if(!rsTot.EOF){
                iTot = rsTot.Fields.Item(0).Value
            }
            rsTot.close() 
        
            result = formato(iTot,0)  
   
        break;
		case 5:  //total de articulos transferidos a tienda
   
           var sSQLTot = "select sum( TAA_Cantidad ) "
                       + " FROM TransferenciaAlmacen t,TransferenciaAlmacen_Articulos  p "
                       + " WHERE Pro_ID = " + Pro_ID
                       + " AND t.TA_ID = p.TA_ID "
                       + " AND t.Cli_ID = " + Cli_ID
                       + " AND TA_TipoTransferenciaCG65 = 2 "
   
            var rsTot = AbreTabla( sSQLTot, 1 , 0 )

            if(!rsTot.EOF){
                iTot = rsTot.Fields.Item(0).Value
            }
            rsTot.close() 
        
            result = formato(iTot,0)  
   
        break;
		case 6:  //total de articulos actualmente en un tra
   
           var sSQLTot = "select count(*) "
                       + " FROM Inventario "
                       + " WHERE Pro_ID = " + Pro_ID
                       + " AND Cli_ID = " + Cli_ID
                       + " AND Inv_EnTransferencia = 1 "
   
            var rsTot = AbreTabla( sSQLTot, 1 , 0 )

            if(!rsTot.EOF){
                iTot = rsTot.Fields.Item(0).Value
            }
            rsTot.close() 
        
            result = formato(iTot,0)  
   
        break;
		case 7:  //total de articulos surtidos por orden de venta o por transferencia
   
           var sSQLTot = "select count(*) "
                       + " FROM Inventario "
                       + " WHERE Pro_ID = " + Pro_ID
                       + " AND Cli_ID = " + Cli_ID
                       + " AND Inv_EnAlmacen = 0 "
                       + " AND Alm_ID <> 3 "
   
            var rsTot = AbreTabla( sSQLTot, 1 , 0 )

            if(!rsTot.EOF){
                iTot = rsTot.Fields.Item(0).Value
            }
            rsTot.close() 
        
            result = formato(iTot,0)  
   
        break;
		case 8:  //total de articulos surtidos por orden de venta o por transferencia
   
           var sSQLTot = "select count(*) "
                       + " FROM Inventario "
                       + " WHERE Pro_ID = " + Pro_ID
                       + " AND Cli_ID = " + Cli_ID
                       + " AND Inv_EnAlmacen = 1 "
                       + " AND Alm_ID = 3 "
                       + " AND Inv_EstatusCG20 = 2 "
   
            var rsTot = AbreTabla( sSQLTot, 1 , 0 )

            if(!rsTot.EOF){
                iTot = rsTot.Fields.Item(0).Value
            }
            rsTot.close() 
        
            result = formato(iTot,0)  
   
        break;
		case 9:  // carga de datos del almacen
   
           var sSQLTot = "SELECT  SUM( CASE WHEN Inv_EnAlmacen in (0,1) THEN 1 ELSE 0 END ) AS Recibido "
                       + " , SUM( CASE WHEN Inv_EstatusCG20 in (1,14) AND Inv_EnAlmacen = 1 THEN 1 ELSE 0 END ) AS Disponible "
                       + " , SUM( CASE WHEN Inv_EstatusCG20 = 5 THEN 1 ELSE 0 END ) AS Vendidos "	
                       + " , SUM( CASE WHEN Inv_EsApartado = 1 THEN 1 ELSE 0 END ) AS ComprometidoApartado "
                       + " , SUM( CASE WHEN Inv_EnTransferencia = 1 THEN 1 ELSE 0 END ) AS ComprometidoTransf "
                       + " FROM Inventario "
                       + " WHERE Pro_ID = " + Pro_ID 
                       + " AND Cli_ID = " + Cli_ID
                       + " AND Inv_Dummy = 0 "
                       + " AND Alm_ID = " + Alm_ID
                       + " GROUP BY Pro_ID "

            try {
                var rsTot = AbreTabla( sSQLTot, 1 , 0 )

                if(!rsTot.EOF){

                     result = '{' 
                            + '  "result": 1' 
                            + ', "AlmID":' + Alm_ID
                            + ', "Recibido": "' + formato(rsTot.Fields.Item("Recibido").Value,0) + '" '
                            + ', "Disponible": "' + formato(rsTot.Fields.Item("Disponible").Value,0) + '" '
                            + ', "Vendidos": "' + formato(rsTot.Fields.Item("Vendidos").Value,0) + '" '
                            + ', "Comprometido": "' + formato((rsTot.Fields.Item("ComprometidoApartado").Value + rsTot.Fields.Item("ComprometidoTransf").Value),0) + '" '
                            + ', "mensaje": "Carga correcta" '
                            + '}'

                }
                rsTot.close() 			


            } catch(err){
                result = '{' 
                       + '  "result": 0'
                       + ', "query": "' + sSQLTot + '" '
                       + ', "mensaje": "Error al cargar el registro" '
                       + '}'
            }

        break;

    }
 
Response.Write(result)
   
   
%>
