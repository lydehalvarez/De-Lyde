

 sTmpComodin04 = ""
 sTmpComodin05 = ""
 sTmpComodin06 = ""
 sTmpComodin07 = "" 
 
 if ( SistemaActual == 30 ) {
    var sSQLp  = "Select top 1 * "
        sSQLp += " from Compania "
        sSQLp += " where Comp_ID = " + Parametro("Comp_ID",0)
 
    var rsCIA = AbreTabla(sSQLp,1,0) 
        if (!rsCIA.EOF) {
            sTmpComodin06 = rsCIA.Fields.Item("Comp_RazonSocial").Value
            sTmpComodin05 = rsCIA.Fields.Item("Comp_Logo").Value
		    sTmpComodin04 = rsCIA.Fields.Item("Comp_Emailcontacto").Value   
		    sTmpComodin07 = rsCIA.Fields.Item("Comp_Telefono").Value               
        }
    rsCIA.Close() 
    
 }
