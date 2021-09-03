<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   var bIQOn4WEB = false
   var iOC_ID = Parametro("OC_ID",-1)

   
   var sSQLOrdComCot = "SELECT OC_ID, OCCot_ID, Prov_ID, dbo.fn_CatGral_DameDato(18,OCCot_CondicionPagoCG18) AS CONDPAGO "
       sSQLOrdComCot += ", OCCot_Total "
       sSQLOrdComCot += " FROM OrdenCompra_Cotizacion "
       sSQLOrdComCot += " WHERE OC_ID = " + iOC_ID
       sSQLOrdComCot += " AND OCCot_Borrado = 0"
   
       if(bIQOn4WEB){ Response.Write("Sentencia de OrdenCompra_Cotizacion <br>"+ sSQLOrdComCot + "<br>") } 
   
   var rsProvCot = AbreTabla(sSQLOrdComCot,1,0)
   var iOCCot_ID = -1
   var iProv_ID = -1    
   //=========== Contacto
   var Prov_ContactoVenta = ""
   var Prov_TelefonoVentas = ""   
   var Prov_EmailVentas = ""
   //=========== Informaci&oacute;n Bancaria
   var Banco = ""
   var Prov_Sucursal = ""   
   var Prov_Cuenta = "" 
   var Prov_CLABE = ""    
   

   
   
   
%>
<div class="ibox">
    <div class="ibox-content">
            <%
               var iContReg = 0
               while (!rsProvCot.EOF){
                   iContReg++ 
                   iOCCot_ID = rsProvCot.Fields.Item("OCCot_ID").Value
                   iProv_ID = rsProvCot.Fields.Item("Prov_ID").Value               
               
               
            %>        
        <div class="tab-content">
            <%
               var sLeySub = "Otras cotizaciones."
               if(iContReg == 1){
                   sLeySub = "Mejor opci&oacute;n."
               }  
               if(iContReg <= 2){
            %>
            <span class="views-number">
                <a href="#" class="forum-item-title" style="pointer-events: none;"><%Response.Write(sLeySub)%></a>
            </span>
            <hr/>
            <% } %>
                <a href="#" class="product-name">
                    Opci&oacute;n <%Response.Write(iContReg)%>
                </a>
                <h3 class="font-bold">
                    <%Response.Write(FM + " " + formato(rsProvCot.Fields.Item("OCCot_Total").Value,2))%>
                </h3>
                <%
                   var sSQLProv = "SELECT Prov_ContactoVenta, Prov_TelefonoVentas, Prov_EmailVentas "
                       sSQLProv += ", Ban_ID, dbo.fn_Proveedor_DameNombre(Prov_ID) AS NOMPROV, Prov_Sucursal "
                       sSQLProv += ", (SELECT Ban_Nombre FROM Cat_Banco B WHERE B.Ban_ID = Proveedor.Ban_ID) AS BANCO "
                       sSQLProv += ", Prov_Cuenta, Prov_CLABE FROM Proveedor "
                       sSQLProv += " WHERE Prov_ID = " + iProv_ID    
                       if(bIQOn4WEB){ Response.Write("Sentencia de Proveedor <br>"+ sSQLProv + "<br>") }
                       
                       var rsProv = AbreTabla(sSQLProv,1,0)
                   
                       if(!rsProv.EOF){
                %>    
                <hr/>
                <address>
                    <h4><%Response.Write(rsProv.Fields.Item("NOMPROV").Value)%></h4>
                    <strong class="text-navy">Datos de contacto.</strong><br>
                    Nombre: <%Response.Write(rsProv.Fields.Item("Prov_ContactoVenta").Value)%>.<br>
                    Tel&eacute;fono: <abbr title="Tel&eacute;fono"><i class="fa fa-phone"></i></abbr> <%Response.Write(rsProv.Fields.Item("Prov_TelefonoVentas").Value)%>.<br>
                    Email: <abbr title="email"><i class="fa fa-envelope"></i></abbr> <%Response.Write(rsProv.Fields.Item("Prov_EmailVentas").Value)%>.
                </address>
                <address>
                    <strong class="text-navy">Informaci&oacute;n Bancaria</strong><br>
                    Banco: <abbr title="Banco"><i class="fa fa-bank"></i></abbr> <%Response.Write(rsProv.Fields.Item("BANCO").Value)%>.<br>
                    Sucursal: <%Response.Write(rsProv.Fields.Item("Prov_Sucursal").Value)%>.<br>
                    Cuenta: <abbr title="Cuenta"><i class="fa fa-credit-card"></i></abbr> <%Response.Write(rsProv.Fields.Item("Prov_Cuenta").Value)%>.<br>
                    CLABE: <abbr title="CLABE">C:</abbr> <%Response.Write(rsProv.Fields.Item("Prov_CLABE").Value)%>.
                </address> 
                <%
                    }
                %>    
                <div class="m-t-sm">
                    <div class="m-t text-righ">
                        <!--a href="#" class="btn btn-xs btn-outline btn-primary">Ver cotizaci&oacute;n <i class="fa fa-long-arrow-right"></i> </a-->
                        <a class="btn btn-xs btn-outline btn-primary" id="btnVerCot" href="javascript:VerCotizacion(<%=iOC_ID%>,<%=iOCCot_ID%>,<%=iProv_ID%>);">Ver cotizaci&oacute;n <i class="fa fa-long-arrow-right"></i></a>                        
                    </div>
                </div>                            
   
        </div>
        <hr/>
        <%
               rsProvCot.MoveNext() 
            }
           rsProvCot.Close()
        %>         
                
    </div>
</div>
    

    
    
    
    
    