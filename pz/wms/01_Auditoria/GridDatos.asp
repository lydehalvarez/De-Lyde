<%
    var gridDataInfo = {};
    
    function getTotalAuditoriasData() {
        if(gridDataInfo.AuditoriasCompletePorcent !== undefined) {
            return;
        }

        gridDataInfo.AuditoriasCompletePorcent = {};
        var sqlTotalAudit = "SELECT COUNT(*) AS Aud_Totals, ({{ubiTotal}}) AS Ubi_Totals, ({{ubiCompleted}}) AS Ubi_Completed  FROM Auditorias_Ciclicas ac";
        sqlTotalAudit += sSQLFiltersToWhere;
        var sqlTotalUbications = "SELECT COUNT(*) FROM Auditorias_Ubicacion au WHERE au.Aud_ID";
        sqlTotalUbications += " IN (SELECT Aud_ID FROM Auditorias_Ciclicas ac" + sSQLFiltersToWhere + ")";
        var sqlCompletedUbications = sqlTotalUbications + " AND  au.AudU_EnProceso =1";
        sqlTotalAudit = sqlTotalAudit.replace("{{ubiTotal}}", sqlTotalUbications).replace("{{ubiCompleted}}", sqlCompletedUbications);
        var rsAudTotales = AbreTabla(sqlTotalAudit,1,0);
        if(!rsAudTotales.EOF) {
            var porcent = rsAudTotales.Fields.Item("Ubi_Totals").Value !== 0 ? ((rsAudTotales.Fields.Item("Ubi_Completed").Value/(rsAudTotales.Fields.Item("Ubi_Totals").Value))*100).toFixed(1):0;
            gridDataInfo.AuditoriasCompletePorcent.data = rsAudTotales.Fields.Item("Aud_Totals").Value;
            gridDataInfo.AuditoriasCompletePorcent.porcent = porcent;
            gridDataInfo.AuditoriasCompletePorcent.text = "Completado";
        }

        rsAudTotales.Close();
    }
    
    function initGridDatos(){
        getTotalAuditoriasData();
    }

    function init(){
    initGridDatos();
};
%>
