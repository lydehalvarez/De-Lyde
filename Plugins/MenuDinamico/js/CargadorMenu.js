/*HM_Loader.js
* by Peter Belesis. v4.3 020610
* Copyright (c) 2002 Peter Belesis. All Rights Reserved.
*/

HM_DOM = (document.getElementById) ? true : false;
HM_NS4 = (document.layers) ? true : false;
HM_IE = (document.all) ? true : false;
HM_IE4 = HM_IE && !HM_DOM;
HM_Mac = (navigator.appVersion.indexOf("Mac") != -1);
HM_IE4M = HM_IE4 && HM_Mac;

HM_Opera = (navigator.userAgent.indexOf("Opera")!=-1); 
HM_Konqueror = (navigator.userAgent.indexOf("Konqueror")!=-1);

HM_IsMenu = !HM_Opera && !HM_IE4M && (HM_DOM || HM_NS4 || HM_IE4 || HM_Konqueror);

HM_BrowserString = HM_NS4 ? "NS4" : HM_DOM ? "DOM" : "IE4";

if(window.event + "" == "undefined") event = null;
function HM_f_PopUp(){return false};
function HM_f_PopDown(){return false};
popUp = HM_f_PopUp;
popDown = HM_f_PopDown;

HM_PG_MenuWidth = 180;
HM_PG_FontFamily = "Verdana, Arial, Helvetica, sans-serif";
HM_PG_FontSize = 9; 
HM_PG_FontBold = 0;
HM_PG_FontItalic = 0;
HM_PG_FontColor = "#FFFFFF";
HM_PG_FontColorOver = "#FFFFFF";
HM_PG_BGColor = "#4A5E77";
HM_PG_BGColorOver = "#5B7282";
HM_PG_ItemPadding = 5; //ventana de menu 

HM_PG_BorderWidth = 0; // borde de la ventana del menu
HM_PG_BorderColor = "#BB0000";   //#4A5E77
HM_PG_BorderStyle = "ridge";
HM_PG_SeparatorSize = 0;
HM_PG_SeparatorColor = "#BB0000";   //#4A5E77
HM_PG_ImageSrc = "/Plugins/MenuDinamico/Img/HM_More_black_right.gif";
HM_PG_ImageSrcLeft = "/Plugins/MenuDinamico/Img/HM_More_black_left.gif";
HM_PG_ImageSrcOver = "/Plugins/MenuDinamico/Img/HM_More_white_right.gif";
HM_PG_ImageSrcLeftOver = "/Plugins/MenuDinamico/Img/HM_More_white_left.gif";

HM_PG_ImageSize = 1;  // menu desplegable
HM_PG_ImageHorizSpace = 0;
HM_PG_ImageVertSpace = 20;

HM_PG_KeepHilite = true; 
HM_PG_ClickStart = 1;
HM_PG_ClickKill = false;
HM_PG_ChildOverlap = 20;
HM_PG_ChildOffset = 10;
HM_PG_ChildPerCentOver = null;
HM_PG_TopSecondsVisible = .5;
HM_PG_ChildSecondsVisible = .3;
HM_PG_StatusDisplayBuild =1;
HM_PG_StatusDisplayLink = 1;
HM_PG_UponDisplay = null;
HM_PG_UponHide = null;
HM_PG_RightToLeft = false;

HM_PG_CreateTopOnly = 1;
HM_PG_ShowLinkCursor = 1;
HM_PG_NSFontOver = true;

HM_PG_ScrollEnabled = true;
HM_PG_ScrollBarHeight = 14;
HM_PG_ScrollBarColor = "";
HM_PG_ScrollImgSrcTop = "/Plugins/MenuDinamico/Img/HM_More_black_top.gif";
HM_PG_ScrollImgSrcBot = "/Plugins/MenuDinamico/img/HM_More_black_bot.gif";
HM_PG_ScrollImgWidth = 9;
HM_PG_ScrollImgHeight = 5;
HM_PG_ScrollBothBars = true;


//4.3
HM_PG_HoverTimeTop  = 1; // tiempo para mostrar el popup
HM_PG_HoverTimeTree = 1;

//	HM_PG_isFrames = true;      // <-- IMPORTANT
//	HM_PG_navFrLoc = "nav";    // <-- frameset-specific
//	HM_PG_mainFrName = "main";  // <-- variables

HM_a_TreesToBuild = [5];




//4.3
HM_GL_HoverTimeTop  = 1000;
HM_GL_HoverTimeTree = 1000;

// the following function is included to illustrate the improved JS expression handling of
// the left_position and top_position parameters introduced in 4.0.9
// and modified in 4.1.3 to account for IE6 standards-compliance mode
// you may delete if you have no use for it

function HM_f_CenterMenu(topmenuid) {
    MinimumPixelLeft = 0;
    TheMenu = HM_DOM ? document.getElementById(topmenuid) : window[topmenuid];
    TheMenuWidth = HM_DOM ? parseInt(TheMenu.style.width) : HM_IE4 ? TheMenu.style.pixelWidth : TheMenu.clip.width;
    TheWindowWidth = HM_IE ? (HM_DOM ? HM_Canvas.clientWidth : document.body.clientWidth) : window.innerWidth;
    return Math.max(parseInt((TheWindowWidth-TheMenuWidth) / 2),MinimumPixelLeft);
}



//end
