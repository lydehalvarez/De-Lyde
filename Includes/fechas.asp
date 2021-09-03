<%

var jDia
var jMes
var jAno
var jJul
var jGre
var jHora
var jHoraS
var jHoraenMinutos
var jHours
var jMinutos
var jSegundos

//Variables para la Auditoria
var jAudDia
var jAudMes
var jAudAno
var jAudJul
var jAudGre
var jAudHora
var jAudHoraS
var jAudHoraenMinutos
var jAudHours
var jAudMinutos
var jAudSegundos

function SyncFecha() {
	var fecha = new Date()
	var y = parseFloat(fecha.getFullYear())
	var m = parseFloat(fecha.getMonth()+1)
	var d = parseFloat(fecha.getDate())
	var uh = parseFloat(fecha.getHours())
	var um = parseFloat(fecha.getMinutes())
	var us = parseFloat(fecha.getSeconds())

   var extra = 100.0*y + m - 190002.5
   var rjd = 0
   rjd = 367.0*y
   rjd -= Math.floor(7.0*(y+Math.floor((m+9.0)/12.0))/4.0)
   rjd += Math.floor(275.0*m/9.0) 
   rjd += d
   rjd += (uh + (um + us/60.0)/60.)/24.0
   rjd += 1721013.5
   rjd -= 0.5*extra/Math.abs(extra)
   rjd += 0.5

   return  (rjd)
}

function GreAJul(sAno,sMes,sDia) {
//,sHora,sMinuto,sSegundo
   var y = parseFloat(sAno)
   var m =parseFloat(sMes)
   var d =parseFloat(sDia)
   var uh = 12 //sHora //  parseFloat(sHora)
   var um = 0 // sMinuto //  parseFloat(sMinuto)
   var us = 0 //sSegundo //  parseFloat(sSegundo)

    jGre = d+"/"+m+"/"+y
    jDia=d
    jMes=m
    jAno=y
   var extra = 100.0*y + m - 190002.5
   var rjd = 367.0*y
   rjd -= Math.floor(7.0*(y+Math.floor((m+9.0)/12.0))/4.0)
   rjd += Math.floor(275.0*m/9.0) 
   rjd += d
   rjd += (uh + (um + us/60.0)/60.)/24.0
   rjd += 1721013.5
   rjd -= 0.5*extra/Math.abs(extra)
   rjd += 0.5
   jJul = rjd
   return  rjd }
   
   function JulAGre(Numero) {
   var jd = parseFloat(Numero)
   jJul = Numero
   var jd0 = jd + 0.5
  
   var z = Math.floor(jd0)
   var f = jd0 - z

   var a = 0.0
   var alp = 0.0
   if ( z < 2299161 ) {
     a = z
   } else {
     alp = Math.floor((z - 1867216.25)/36524.25)
     a = z + 1.0 + alp - Math.floor(alp/4.0)
   }

   var b = a + 1524
   var c = Math.floor((b - 122.1)/365.25)
   var d = Math.floor(365.25*c)
   var e = Math.floor((b - d)/30.6001)

   var day = b - d - Math.floor(30.6001*e) + f

   var mon = 0
   if (e < 13.5) {
      mon = e - 1
   } else {
      mon = e - 13
   }

   var yr = 0
   if (mon > 2.5) {
      yr = c - 4716
   } else {
      yr = c - 4715
   }
	
	var dia =  Math.floor(day)+"/"+mon+"/"+yr
	jGre = dia
	jDia = Math.floor(day)
	jMes = mon
	jAno = yr
   //form.year.value = yr
   //form.month.value = mon
   //form.day.value = Math.floor(day)

   //var uth = Math.floor(24.0*(day - Math.floor(day)))
   //var utm = Math.floor(1440.0*(day - Math.floor(day) - uth/24.0))
   //var uts = 86400.0*(day - Math.floor(day) - uth/24.0 - utm/1440.0)

   return dia
   //form.uth.value = uth
   //form.utm.value = utm
   //form.uts.value = uts
}

function Separa(sFecha) {
	if (sFecha != "") {
		jGre = String(sFecha)
		sFecha= String(sFecha)
		//Response.Write("jGre="+jGre+"<br>" )
		jDia = sFecha.substring(0,sFecha.indexOf("/"))
		//Response.Write("jDia="+jDia +"<br>" )
		var paso = sFecha.substring(sFecha.indexOf("/")+1,10)
		//Response.Write("paso="+paso +"<br>" )
		jMes = paso.substring(0,paso.indexOf("/"))
		//Response.Write("jMes="+jMes +"<br>" )
		jAno = paso.substring(paso.indexOf("/")+1, 10)
		//Response.Write("jAno="+jAno +"<br>" )
		jJul = GreAJul(jAno,jMes,jDia)

//DRP	9/Jul/03	Si viene vacia la fecha, regresaba NaN el jJul, por eso este cambio
		if (isNaN(jJul)) { jJul = 0 }
		//Response.Write("jJul="+jJul +"<br>" )
		//Response.Write("______________________________________<br>" )
	}
	else {
		jJul = 0
	}
}

 function Hoy() {
 	var fecha = new Date()
	jAno = fecha.getFullYear()
	jMes = fecha.getMonth()+1
	jDia = fecha.getDate()

	
	jGre= jDia + "/" + jMes + "/" + jAno
	jJul= GreAJul(jAno,jMes,jDia)
	
	jHours = fecha.getHours()
	jMinutos = fecha.getMinutes()
	jSegundos = fecha.getSeconds()

	var sAMPM = "";
	(jSegundos < 10) ? jSegundos = "0" + jSegundos : jSegundos;
	(jMinutos < 10) ? jMinutos = "0" + jMinutos : jMinutos;
	(jHours < 12) ? sAMPM = "AM" : sAMPM = "PM";
	(jHours > 12) ? jHours = jHours - 12 : jHours;
	(jHours == 0) ? jHours = 12 : jHours;
	
	jHora = jHours + ":" + jMinutos + " " + sAMPM;
	jHoraS = jHours + ":" + jMinutos + ":" + jSegundos + " " + sAMPM;
	jHoraenMinutos = eval(jHours * 60) + jMinutos
 }



 function HoyAuditoria() {
 	var fechaAud = new Date()
	jAudAno = fechaAud.getFullYear()
	jAudMes = fechaAud.getMonth()+1
	jAudDia = fechaAud.getDate()

	
	jAudGre= jAudDia + "/" + jAudMes + "/" + jAudAno
	jAudJul= GreAJul(jAudAno,jAudMes,jAudDia)
	
	jAudHours = fechaAud.getHours()
	jAudMinutos = fechaAud.getMinutes()
	jAudSegundos = fechaAud.getSeconds()

	var sAudAMPM = "";
	(jAudSegundos < 10) ? jAudSegundos = "0" + jAudSegundos : jAudSegundos;
	(jAudMinutos < 10) ? jAudMinutos = "0" + jAudMinutos : jAudMinutos;
	(jAudHours < 12) ? sAudAMPM = "am" : sAudAMPM = "pm";
	(jAudHours > 12) ? jAudHours = jAudHours - 12 : jAudHours;
	(jAudHours == 0) ? jAudHours = 12 : jAudHours;
	
	jAudHora = jAudHours + ":" + jAudMinutos + " " + sAudAMPM;
	jAudHoraS = jAudHours + ":" + jAudMinutos + "." + jAudSegundos + " " + sAudAMPM;
	jAudHoraenMinutos = eval(jAudHours * 60) + jAudMinutos
 }


 //======================NECESARIA PARA LAS PENDEJAS DE UNO jd
 
function JulAGre(Numero) {
   var jd = parseFloat(Numero)
   jJul = Numero
   var jd0 = jd + 0.5
  
   var z = Math.floor(jd0)
   var f = jd0 - z

   var a = 0.0
   var alp = 0.0
   if ( z < 2299161 ) {
     a = z
   } else {
     alp = Math.floor((z - 1867216.25)/36524.25)
     a = z + 1.0 + alp - Math.floor(alp/4.0)
   }

   var b = a + 1524
   var c = Math.floor((b - 122.1)/365.25)
   var d = Math.floor(365.25*c)
   var e = Math.floor((b - d)/30.6001)

   var day = b - d - Math.floor(30.6001*e) + f

   var mon = 0
   if (e < 13.5) {
      mon = e - 1
   } else {
      mon = e - 13
   }

   var yr = 0
   if (mon > 2.5) {
      yr = c - 4716
   } else {
      yr = c - 4715
   }
	
	var dia =  Math.floor(day)+"/"+mon+"/"+yr
	jGre = dia
	jDia = Math.floor(day)
	jMes = mon
	jAno = yr
   //form.year.value = yr
   //form.month.value = mon
   //form.day.value = Math.floor(day)

   //var uth = Math.floor(24.0*(day - Math.floor(day)))
   //var utm = Math.floor(1440.0*(day - Math.floor(day) - uth/24.0))
   //var uts = 86400.0*(day - Math.floor(day) - uth/24.0 - utm/1440.0)

   return dia
   //form.uth.value = uth
   //form.utm.value = utm
   //form.uts.value = uts
}
  

%>