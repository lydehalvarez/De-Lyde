<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252" %>
<!--#include file="../../../Includes/iqon.asp" -->
<%

var Aud_ID = Parametro("Aud_ID",-1);
   
var AnchoCol = 3

var SKUPorcentaje = 0
var Aud_TotalSKU  = 0
var Aud_SKU_Visitados    = 0
var Aud_SKU_Terminados   = 0
var Aud_HayConteoExterno = 0
   
var LPNPorcentaje = 0
var Aud_TotalLPN = 0
var Aud_LPNTerminados  = 0
   
var PapeletaPorcentaje = 0
var Aud_TPapeletasINT  = 0
var Aud_PINTTerminadas = 0
   
var PapeletaExtPorcentaje = 0
var Aud_TPapeletasEXT = 0
var Aud_PEXTTerminadas = 0
   
var sSQL = "select Aud_HayConteoExterno "
         + " , Aud_TotalSKU, Aud_SKU_Visitados, Aud_SKU_Terminados "
         + " , CASE WHEN ISNULL(Aud_SKU_Visitados,0) = 0 "
         +       " THEN 0 "
         +       " ELSE (ISNULL(Aud_SKU_Visitados,0) * 100 /NULLIF(Aud_TotalSKU, 0))  END as SKUVisitados "
         + " , Aud_TotalLPN, Aud_LPNTerminados "
         + " , CASE WHEN ISNULL(Aud_LPNTerminados,0) = 0  "
         + "      THEN 0  "
         + "	   ELSE (ISNULL(Aud_LPNTerminados,0) * 100 /NULLIF(Aud_TotalLPN, 0))  END as LPNVisitados "
         + " , Aud_TotalPapeletasINT, Aud_PapeletasINTTerminadas "
         + " , CASE WHEN ISNULL(Aud_PapeletasINTTerminadas,0) = 0  "
         + "       THEN 0  "
         + "	   ELSE (ISNULL(Aud_PapeletasINTTerminadas,0) * 100 /NULLIF(Aud_TotalPapeletasINT, 0))  END as PPLTIntVisitadas "
         + " , Aud_TotalPapeletasEXT,Aud_PapeletasEXTTerminadas "
         + " , CASE WHEN ISNULL(Aud_PapeletasEXTTerminadas,0) = 0  "
         + "      THEN 0  "
         + "   ELSE (ISNULL(Aud_PapeletasEXTTerminadas,0) * 100 /NULLIF(Aud_TotalPapeletasEXT, 0))  END as PPLTExtVisitadas "
         + " FROM Auditorias_Ciclicas ac "
         + " WHERE Aud_ID = " + Aud_ID
   
var rsPorc = AbreTabla(sSQL, 1, 0);

if( !(rsPorc.EOF) ){
    Aud_HayConteoExterno  = rsPorc("Aud_HayConteoExterno").Value
    if(Aud_HayConteoExterno == 0){
       AnchoCol = 4
    }    
   
    SKUPorcentaje         = formato_numero(rsPorc("SKUVisitados").Value,2)
    Aud_TotalSKU          = formato_numero(rsPorc("Aud_TotalSKU").Value,2)
    Aud_SKU_Visitados     = formato_numero(rsPorc("Aud_SKU_Visitados").Value,2)
    Aud_SKU_Terminados    = formato_numero(rsPorc("Aud_SKU_Terminados").Value,2)
   
    LPNPorcentaje         = formato_numero(rsPorc("LPNVisitados").Value,2)
    Aud_TotalLPN          = formato_numero(rsPorc("Aud_TotalLPN").Value,2)
    Aud_LPNTerminados     = formato_numero(rsPorc("Aud_LPNTerminados").Value,2)
   
    PapeletaPorcentaje    = formato_numero(rsPorc("PPLTIntVisitadas").Value,2)
    Aud_TPapeletasINT     = formato_numero(rsPorc("Aud_TotalPapeletasINT").Value,2)  
    Aud_PINTTerminadas    = formato_numero(rsPorc("Aud_PapeletasINTTerminadas").Value,2)
   
    PapeletaExtPorcentaje = formato_numero(rsPorc("PPLTExtVisitadas").Value,2)
    Aud_TPapeletasEXT     = formato_numero(rsPorc("Aud_TotalPapeletasEXT").Value,2)
    Aud_PEXTTerminadas    = formato_numero(rsPorc("Aud_PapeletasEXTTerminadas").Value,2)

}

rsPorc.Close();
%>
<div class="row" >
    <div class="col-lg-<%=AnchoCol%>">
        <div class="col" id="divGrfSKU"> 

        </div>
        <div class="col text-center" title="Total: <%= Aud_TotalSKU %> - Terminados: <%= Aud_SKU_Terminados %>  - Visitados: <%= Aud_SKU_Visitados %>">
            <i class="fa fa-tag"></i> SKU Visitados
        </div>
    </div>
    <div class="col-lg-<%=AnchoCol%>">
        <div class="col" id="divGrfLPN">

        </div>
        <div class="col text-center" title="Total: <%= Aud_TotalLPN %> - Terminados: <%= Aud_LPNTerminados %>">
            <i class="fa fa-inbox"></i> LPN
        </div>
    </div>
    <div class="col-lg-<%=AnchoCol%>">
        <div class="col" id="divGrfPapeleta">

        </div>
        <div class="col text-center" title="Total: <%= Aud_TPapeletasINT %> - Terminados: <%= Aud_PINTTerminadas %>">
            <i class="fa fa-file-text-o"></i> Papeleta Int
        </div>
    </div>
<% if (Aud_HayConteoExterno == 1){ %>   
    <div class="col-lg-3">
        <div class="col" id="divGrfPapeletaExt">
        </div>
        <div class="col text-center" title="Total: <%= Aud_TPapeletasEXT %> - Terminados: <%= Aud_PEXTTerminadas %>">
            <i class="fa fa-file-text-o"></i> Papeleta Ext
        </div>
    </div>
<% } %> 
</div>

<script type="text/javascript">
    $(document).ready(function(){

        c3.generate({
            bindto: '#divGrfSKU',
            data:{
                columns: [
                    ['SKU Visitados', <%= SKUPorcentaje %>]
                ],
                type: 'gauge'
            },
            color:{
                pattern: ['#ed5565', '#f8ac59', '#1c84c6', '#1ab394'] ,
                threshold: {
                    values: [30, 60, 95, 100]
                }
            },
            size: {
                height: 90,
                 width: 150
            }
        });

        c3.generate({
            bindto: '#divGrfLPN',
            data:{
                columns: [
                    ['LPN Terminadas', <%= LPNPorcentaje %>]
                ],
                type: 'gauge'
            },
            color:{
                pattern: ['#ed5565', '#f8ac59', '#1c84c6', '#1ab394'], 
                threshold: {
                    values: [30, 60, 95, 100]
                }
            },
            size: {
                 height: 90,
                 width: 150
            }
        });

        c3.generate({
            bindto: '#divGrfPapeleta',
            data:{
                columns: [
                    ['Papeletas Terminadas', <%= PapeletaPorcentaje %>]
                ],
                type: 'gauge'
            },
            color:{
                pattern: ['#ed5565', '#f8ac59', '#1c84c6', '#1ab394'], 
                threshold: {
                    values: [30, 60, 95, 100]
                }
            },
            size: {
                height: 90,
                 width: 150
            }
        });
        
<% if (Aud_HayConteoExterno == 1){ %>      
        
        c3.generate({
            bindto: '#divGrfPapeletaExt',
            data:{
                columns: [
                    ['Papeletas Terminadas', <%= PapeletaExtPorcentaje %>]
                ],
                type: 'gauge'
            },
            color:{
                pattern: ['#ed5565', '#f8ac59', '#1c84c6', '#1ab394'], 
                threshold: {
                    values: [30, 60, 95, 100]
                }
            },
            size: {
                height: 90,
                 width: 150
            }
        });
                                  
<% } %>                      

    })
</script>