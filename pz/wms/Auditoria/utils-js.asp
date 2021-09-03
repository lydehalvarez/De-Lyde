<%
    function formatAMPM(value) {
        var date = new Date(value);
        var hours = date.getHours();
        var minutes = date.getMinutes();
        var ampm = hours >= 12 ? 'pm' : 'am';
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        minutes = minutes < 10 ? '0'+minutes : minutes;
        var strTime = hours + ':' + minutes + ' ' + ampm;
        return strTime;
    }

    function dateFormatter(value) {
        var date = new Date(value);

        return date.getDate() + "/" + ("0" + date.getMonth() + 1).slice(-2) + "/"+date.getFullYear();
    }
    function dateFormatter2(value) {
        var date = new Date(value);

        return date.getDate() + "/" + (date.getMonth()<9? "0"+(date.getMonth()+1):(date.getMonth()+1)) + "/"+date.getFullYear() + " "+ date.getTime();
    }

    function getAuditorsInfo(AuditId) {
        var images = [];
        var sSQLAuditores = "SELECT Usu_RutaImg+Usu_Imagen as url";
        sSQLAuditores += ", Usu_Nombre from Usuario WHERE Usu_ID IN";
        sSQLAuditores += " (SELECT Usu_ID ";
        sSQLAuditores += " FROM Auditorias_Auditores aa WHERE aa.Aud_ID = " + AuditId + ")";
        var rsAuditores = AbreTabla(sSQLAuditores,1,0);
        var count=0;
        while (!rsAuditores.EOF) {
            images[count] = {url : rsAuditores.Fields.Item("url").Value, name: rsAuditores.Fields.Item("Usu_Nombre").Value};
            rsAuditores.MoveNext();
            count++;
        }

        rsAuditores.Close();

        return images;
    }

    function getAuditorsInfoFormatted(auditId) {
        var auditors = getAuditorsInfo(auditId);
        var stringBuilder = "";

        if(auditors.length > 0) {
            stringBuilder += "<ul>";
            for(var i = 0; i < auditors.length; i++) {
                var auditor = auditors[i];
                stringBuilder += "<li>" + auditor.name + "</li>";
            }
            stringBuilder += "</ul>";
        }        

        return stringBuilder;
    }
%>
