<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
	var OC_ID = Parametro("OC_ID",1)
 
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Total general</h5>
        </div>
        <div class="ibox-content">
<% 
			                    
 var sSQL  = " select ISNULL(SUM(OCD_TotalImpPartida),0) as SubTotal "
     sSQL += " , ISNULL((SUM(OCD_TotalImpPartida) - SUM(OCD_Descuento)  ),0) as GranTotal "	 
     sSQL += " , ISNULL(SUM(OCD_Descuento),0) as Descuentos "	 
	 sSQL += " FROM OrdenCompra_Detalle " 
	 sSQL += " WHERE OC_ID = " + OC_ID

 
	 var rsSumas = AbreTabla(sSQL,1,0)

if (!rsSumas.EOF){                   
%>                        
      <span>Sub Total</span>
      <h2 class="font-bold">
          $<%=formato(rsSumas.Fields.Item("SubTotal").Value,2)%>
      </h2>                 

   
<% }
   if (rsSumas.Fields.Item("Descuentos").Value != 0 ) { %>                             
        <span>
            Descuentos
        </span>
        <h2 class="font-bold">
           - $<%=formato(rsSumas.Fields.Item("Descuentos").Value,2)%>
        </h2>                                                             
<% }  %>                                
        <hr/>     
         <span>
            Total
        </span>
        <h2 class="font-bold">
            $<%=formato(rsSumas.Fields.Item("GranTotal").Value,2)%>
        </h2>
<%

	var sSQLACT = "UPDATE OrdenCompra "
		sSQLACT += " SET OC_Subtotal = " + rsSumas.Fields.Item("SubTotal").Value
		sSQLACT += " , OC_Total = " + rsSumas.Fields.Item("GranTotal").Value
		sSQLACT += " WHERE OC_ID = " + OC_ID 
		 		
	Ejecuta(sSQLACT,0)



 rsSumas.Close()

%>
                  
        </div>
    </div>

    <div class="ibox">
        <div class="ibox-title">
            <h5>Autorizaciones</h5>
        </div>
        <div class="ibox-content text-center">
                        

          <hr/>
        </div>
    </div>
