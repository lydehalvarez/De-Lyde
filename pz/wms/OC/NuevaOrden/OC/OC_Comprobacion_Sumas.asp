<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
	var OC_ID = Parametro("OC_ID",1)
	var Prov_ID = Parametro("Prov_ID",0)
	var Pro_ID = Parametro("Pro_ID",0)	
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Total general</h5>
        </div>
        <div class="ibox-content">
<% 
			                    
 var sSQL  = " select ISNULL(SUM(Prov_Fac_SubTotal),0) as SubTotal "
     sSQL += " , ISNULL((SUM(Prov_Fac_GranTotal) - SUM(Prov_Fac_DescuentoOtro) +  SUM(Prov_Fac_Aumento) ),0) as GranTotal "
     sSQL += " , ISNULL(SUM(Prov_Fac_IVARetenido),0) as IVARetenido "
     sSQL += " , ISNULL(SUM(Prov_Fac_ISRRetenido),0) as ISRRetenido "
     sSQL += " , ISNULL(SUM(Prov_Fac_IVATransladado),0) as IVATransladado "
     sSQL += " , ISNULL(SUM(Prov_Fac_IEPSTransladado),0) as IEPSTransladado "
     sSQL += " , ISNULL(SUM(Prov_Fac_DescuentoOtro),0) as OtrosDescuentos "	 
     sSQL += " , ISNULL(SUM(Prov_Fac_Aumento),0) as Aumentos "
     sSQL += " , ISNULL(SUM(Prov_Fac_totalImpuestosRetenidos),0) as totalImpuestosRetenidos "
     sSQL += " , ISNULL(SUM(Prov_Fac_totalImpuestosTrasladados),0) as totalImpuestosTrasladados "	 	 
	 sSQL += " FROM Proveedor_Recepcion_Factura " 
	 sSQL += " WHERE Prov_ID = " + Prov_ID
	 sSQL += " AND OC_ID = " + OC_ID
	 sSQL += " AND Prov_Fac_EstaLibre = 0 "
 
	 var rsSumas = AbreTabla(sSQL,1,0)

if (!rsSumas.EOF){                   
%>                        
      <span>Sub Total</span>
      <h2 class="font-bold">
          $<%=formato(rsSumas.Fields.Item("SubTotal").Value,2)%>
      </h2>
                            
<% if (rsSumas.Fields.Item("IVARetenido").Value != 0 ) { %>
        <span>
            IVA Retenido
        </span>
        <h2 class="font-bold">
           - $<%=formato(rsSumas.Fields.Item("IVARetenido").Value,2)%>
        </h2>                            
<% }
   if (rsSumas.Fields.Item("ISRRetenido").Value != 0 ) { %>  
        <span>
            ISR Retenido
        </span>
        <h2 class="font-bold">
           - $<%=formato(rsSumas.Fields.Item("ISRRetenido").Value,2)%>
        </h2>    
<% }
   if (rsSumas.Fields.Item("IVATransladado").Value != 0 ) { %>     
        <span>IVA</span>
        <h2 class="font-bold">
            $<%=formato(rsSumas.Fields.Item("IVATransladado").Value,2)%>
        </h2>                        
<% }
   if (rsSumas.Fields.Item("IEPSTransladado").Value != 0 ) { %>                             
        <span>
            IEPS Transladado
        </span>
        <h2 class="font-bold">
            $<%=formato(rsSumas.Fields.Item("IEPSTransladado").Value,2)%>
        </h2>  
<% }
   if (rsSumas.Fields.Item("OtrosDescuentos").Value != 0 ) { %>                             
        <span>
            Otros descuentos
        </span>
        <h2 class="font-bold">
           - $<%=formato(rsSumas.Fields.Item("OtrosDescuentos").Value,2)%>
        </h2>          
<% }
   if (rsSumas.Fields.Item("totalImpuestosRetenidos").Value != 0 ) { %>                             
        <span>
            Impuestos retenidos
        </span>
        <h2 class="font-bold">
            $<%=formato(rsSumas.Fields.Item("totalImpuestosRetenidos").Value,2)%>
        </h2>  
<% }
   if (rsSumas.Fields.Item("totalImpuestosTrasladados").Value != 0 ) { %>                             
        <span>
            Impuestos trasladados
        </span>
        <h2 class="font-bold">
            $<%=formato(rsSumas.Fields.Item("totalImpuestosTrasladados").Value,2)%>
        </h2>  
<% }   if (rsSumas.Fields.Item("Aumentos").Value != 0 ) { %>                             
        <span>
            Otros cargos
        </span>
        <h2 class="font-bold">
            $<%=formato(rsSumas.Fields.Item("Aumentos").Value,2)%>
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
		sSQLACT += " , OC_IVA = " + rsSumas.Fields.Item("IVATransladado").Value
		sSQLACT += " , OC_IVARetenido = " + rsSumas.Fields.Item("IVARetenido").Value
		sSQLACT += " , OC_Total = " + rsSumas.Fields.Item("GranTotal").Value
		sSQLACT += " WHERE Prov_ID = " + Prov_ID 
		sSQLACT += " AND OC_ID = " + OC_ID 
		 		
	Ejecuta(sSQLACT,0)


	}
 rsSumas.Close()

%>
                  
        </div>
    </div>

    <div class="ibox">
        <div class="ibox-title">
            <h5>Autorizaciones</h5>
        </div>
        <div class="ibox-content text-center">
                        
<% 
  //Prov_Fac_Moneda, Prov_Fac_TipoCambio                      
 var sSQL  = " select (SELECT Usu_Nombre FROM Usuario u WHERE u.Usu_ID = o.Usu_ID) as Usuario "
     sSQL += " , ISNULL(CONVERT(NVARCHAR(20), OCA_FechaAutorizo,103),'') as Fecha "
     sSQL += " , OCA_Autorizo, ComAU_Nivel "
     sSQL += " from OrdenCompra_Autorizacion o "
     sSQL += " WHERE Prov_ID = 277 AND OC_ID = 1  " 
     sSQL += " Order by ComAU_Nivel " 
 
	 var rsAutorizaciones = AbreTabla(sSQL,1,0)
   
	while (!rsAutorizaciones.EOF){                
%>                       
                        
            <span >
                <%=rsAutorizaciones.Fields.Item("Usuario").Value%> - <%=rsAutorizaciones.Fields.Item("OCA_Autorizo").Value%><br />
                <small><%=rsAutorizaciones.Fields.Item("Fecha").Value%>  -  <%=rsAutorizaciones.Fields.Item("ComAU_Nivel").Value%></small>
            </span> 
            
            <hr/> 
<%
		rsAutorizaciones.MoveNext() 
		}
	rsAutorizaciones.Close()   
%> 

          <hr/>
        </div>
    </div>
