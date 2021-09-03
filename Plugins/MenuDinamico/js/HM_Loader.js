/*HM_Loader.js
* by Peter Belesis. v4.3 020610
* Copyright (c) 2002 Peter Belesis. All Rights Reserved.
*/
var HM_DOM = (document.getElementById) ? true : false;
var HM_NS4 = (document.layers) ? true : false;
var HM_IE = (document.all) ? true : false;
var HM_IE4 = HM_IE && !HM_DOM;
var HM_Mac = (navigator.appVersion.indexOf("Mac") != -1);
var HM_IE4M = HM_IE4 && HM_Mac;

var HM_Opera = (navigator.userAgent.indexOf("Opera")!=-1);
var HM_Konqueror = (navigator.userAgent.indexOf("Konqueror")!=-1);

var HM_IsMenu = !HM_Opera && !HM_IE4M && (HM_DOM || HM_NS4 || HM_IE4 || HM_Konqueror);

var HM_BrowserString = HM_NS4 ? "NS4" : HM_DOM ? "DOM" : "IE4";

if(window.event + "" == "undefined") event = null;
function HM_f_PopUp(){return false};
function HM_f_PopDown(){return false};
var popUp = HM_f_PopUp;
var popDown = HM_f_PopDown;

var HM_PG_MenuWidth = 350;
var HM_PG_FontFamily = "Verdana, Arial, Helvetica, sans-serif";
var HM_PG_FontSize = 9; 
var HM_PG_FontBold = 0;
var HM_PG_FontItalic = 0;
var HM_PG_FontColor = "#FFFFFF";
var HM_PG_FontColorOver = "#FFFFFF";
var HM_PG_BGColor = "#4A5E77";
var HM_PG_BGColorOver = "#5B7282";
var HM_PG_ItemPadding = 5; //ventana de menu 

var HM_PG_BorderWidth = 1; // borde de la ventana del menu
var HM_PG_BorderColor = "#FFFF00";
var HM_PG_BorderStyle = "ridge";
var HM_PG_SeparatorSize = 1;
var HM_PG_SeparatorColor = "#FFFF00";
var HM_PG_ImageSrc = "/Plugins/MenuDinamico/Img/HM_More_black_right.gif";
var HM_PG_ImageSrcLeft = "/Plugins/MenuDinamico/Img/HM_More_black_left.gif";
var HM_PG_ImageSrcOver = "/Plugins/MenuDinamico/Img/HM_More_white_right.gif";
var HM_PG_ImageSrcLeftOver = "/Plugins/MenuDinamico/Img/HM_More_white_left.gif";
var HM_PG_ImageSize = 1;  // menu desplegable
var HM_PG_ImageHorizSpace = 0;
var HM_PG_ImageVertSpace = 20;

var HM_PG_KeepHilite = true; 
var HM_PG_ClickStart = 1;
var HM_PG_ClickKill = false;
var HM_PG_ChildOverlap = 20;
var HM_PG_ChildOffset = 10;
var HM_PG_ChildPerCentOver = null;
var HM_PG_TopSecondsVisible = .5;
var HM_PG_ChildSecondsVisible = .3;
var HM_PG_StatusDisplayBuild =1;
var HM_PG_StatusDisplayLink = 1;
var HM_PG_UponDisplay = null;
var HM_PG_UponHide = null;
var HM_PG_RightToLeft = false;

var HM_PG_CreateTopOnly = 1;
var HM_PG_ShowLinkCursor = 1;
var HM_PG_NSFontOver = true;

var HM_PG_ScrollEnabled = true;
var HM_PG_ScrollBarHeight = 14;
var HM_PG_ScrollBarColor = "";
var HM_PG_ScrollImgSrcTop = "/Plugins/MenuDinamico/Img/HM_More_black_top.gif";
var HM_PG_ScrollImgSrcBot = "/Plugins/MenuDinamico/Img/HM_More_black_bot.gif";
var HM_PG_ScrollImgWidth = 9;
var HM_PG_ScrollImgHeight = 5;
var HM_PG_ScrollBothBars = true;


//4.3
var HM_PG_HoverTimeTop  = 1; // tiempo para mostrar el popup
var HM_PG_HoverTimeTree = 1;

//	HM_PG_isFrames = true;      // <-- IMPORTANT
//	HM_PG_navFrLoc = "nav";    // <-- frameset-specific
//	HM_PG_mainFrName = "main";  // <-- variables

var HM_a_TreesToBuild = [5];




//4.3
var HM_GL_HoverTimeTop  = 1000;
var HM_GL_HoverTimeTree = 1000;

// the following function is included to illustrate the improved JS expression handling of
// the left_position and top_position parameters introduced in 4.0.9
// and modified in 4.1.3 to account for IE6 standards-compliance mode
// you may delete if you have no use for it

function HM_f_CenterMenu(topmenuid) {
    var MinimumPixelLeft = 0;
    var TheMenu = HM_DOM ? document.getElementById(topmenuid) : window[topmenuid];
    var TheMenuWidth = HM_DOM ? parseInt(TheMenu.style.width) : HM_IE4 ? TheMenu.style.pixelWidth : TheMenu.clip.width;
    var TheWindowWidth = HM_IE ? (HM_DOM ? HM_Canvas.clientWidth : document.body.clientWidth) : window.innerWidth;
    return Math.max(parseInt((TheWindowWidth-TheMenuWidth) / 2),MinimumPixelLeft);
}

if(HM_IsMenu) {
    document.write("<SCR" + "IPT LANGUAGE='JavaScript1.2' SRC='/Plugins/MenuDinamico/js//HM_Arrays.js' TYPE='text/javascript'><\/SCR" + "IPT>");
    document.write("<SCR" + "IPT LANGUAGE='JavaScript1.2' SRC='/Plugins/MenuDinamico/js//HM_Script"+ HM_BrowserString +".js' TYPE='text/javascript'><\/SCR" + "IPT>");
}

//end
