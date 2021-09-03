<%
    var meses = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
    var Cli_ID = Parametro("Cli_ID",-1)
    var AuditType = Parametro("AuditType",-1)
    var FechaInicio = Parametro("FechaInicio","")
    var FechaFin = Parametro("FechaFin","")
    var AuditEstatus = Parametro("AuditEstatus",-1)
    var Auditor = Parametro("Auditor",-1)
    var sSQLFiltersToWhere = concatenateFiltersToQuery();
    
    var sSQL = "select " 
             + "  c.Cli_Id"
             + ", Cli_Nombre"
             + ", dbo.fn_CatGral_DameDato(140,Aud_TipoCG140) as tipo"
             + ", dbo.fn_CatGral_DameDato(141,Aud_EstatusCG141) as estatus"
             + ", dbo.fn_Usuario_DameIDUsuario(Aud_UsuarioResponsable_UID) as auditorResponsable"
             + ", (select count(Aud_ID) from Auditorias_Ubicacion au where au.Aud_ID = ac.Aud_ID) as totalUbicaciones"
             + ", ac.* "
             + " from Auditorias_Ciclicas ac "
             + " join Cliente c on ac.Cli_ID = c.Cli_ID"
   
    sSQL += sSQLFiltersToWhere;
    
    function concatenateFiltersToQuery() {
        if (Cli_ID > -1 
        || AuditType > -1
        || FechaInicio != ""
        || FechaFin != ""
        || AuditEstatus > -1
        || Auditor > -1) {
            var sSQLi = " WHERE 1=1";
            if (Cli_ID > -1) {
                sSQLi += " AND ac.Cli_Id = " + Cli_ID;
            }

            if (AuditType > -1) {
                sSQLi += " AND ac.Aud_TipoCG140 = " + AuditType;
            }

            if (FechaInicio == "" && FechaFin == "") {    
                FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR);
                sSQLi += " AND CAST(ac.Aud_FechaRegistro as date)  >= DATEADD(month,-1,getdate()) ";
            } else {   
                if(FechaInicio == "" ) {
                    if(FechaFin != "" ) {
                        FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR);
                        sSQLi += " AND CAST(ac.Aud_FechaRegistro as date)  <= '" + FechaFin + "'";
                    }
                } else {
                    FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR);
                    if(FechaFin == "" ) {
                        sSQLi += " AND CAST(ac.Aud_FechaRegistro as date)  >= '" + FechaFin + "'";
                    } else {
                        FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR);
                        sSQLi += " AND CAST(ac.Aud_FechaRegistro as date) between  '" + FechaInicio + "' and '" + FechaFin + "' ";
                    }
                }
            }

            if (AuditEstatus > -1) {
                sSQLi += " AND ac.Aud_EstatusCG141 = " + AuditEstatus;
            }

            if (Auditor > -1) {
                sSQLi += " AND dbo.fn_Usuario_DameIDUsuario(Aud_UsuarioResponsable_UID) = " + Auditor;
            }
            return sSQLi;
        }
        return "";
    }

    function shrunkDate(value) {
        var date = new Date(value);

        return meses[date.getMonth()] + " " + date.getFullYear();
    }

    function getUbicationsInfo(AuditId) {
        var ubications=[];
        var sSQLUbications = "SELECT COUNT(*) AS AudU_total";
        sSQLUbications += ", (SELECT COUNT (*) FROM Auditorias_Ubicacion";
        sSQLUbications += " WHERE Aud_ID = " + AuditId + " AND AudU_Terminado = 1) AS AudU_Visited";
        sSQLUbications += " FROM Auditorias_Ubicacion WHERE Aud_ID = " + AuditId;
        var rsUbications = AbreTabla(sSQLUbications,1,0);
        var count=0;
        while (!rsUbications.EOF) {
            var total = rsUbications.Fields.Item("AudU_total").Value;
            var visited = rsUbications.Fields.Item("AudU_Visited").Value;
            ubications[count] = {total: total, visited: visited, notVisited: total-visited};
            rsUbications.MoveNext();
            count++;
        }

         rsUbications.Close();

        return ubications.length !== 0 ? ubications[0] : {total: 0, visited: 0, notVisited: 0};
    }
%>
