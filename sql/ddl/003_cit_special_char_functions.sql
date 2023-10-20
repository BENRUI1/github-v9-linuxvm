set define off

CREATE OR REPLACE function cit_special_char_remove(vcText IN VARCHAR2) RETURN VARCHAR2
is
vcOut  VARCHAR2(32000);
begin
vcOut := ltrim(rtrim(replace(replace(replace(replace(replace(replace(replace(vcText, chr(16), ''), chr(160), ''), chr(9), ''), chr(10), ''), chr(13), ''), chr(160), ''), '"','') ));
RETURN(vcOut);
end;
/

grant all on cit_special_char_remove to public;

CREATE OR REPLACE function cit_special_char_xml(vcText IN VARCHAR2) RETURN VARCHAR2
is
vcOut  VARCHAR2(32000);
begin
vcOut := vcText;
vcOut := REPLACE(vcOut, '&', '&#38;');
vcOut := REPLACE(vcOut, '€', '&#128;');
vcOut := REPLACE(vcOut, '‚', '&#130;');
vcOut := REPLACE(vcOut, 'ƒ', '&#131;');
vcOut := REPLACE(vcOut, '„', '&#132;');
vcOut := REPLACE(vcOut, '…', '&#133;');
vcOut := REPLACE(vcOut, '†', '&#134;');
vcOut := REPLACE(vcOut, '‡', '&#135;');
vcOut := REPLACE(vcOut, 'ˆ', '&#136;');
vcOut := REPLACE(vcOut, '‰', '&#137;');
vcOut := REPLACE(vcOut, 'Š', '&#138;');
vcOut := REPLACE(vcOut, '‹', '&#139;');
vcOut := REPLACE(vcOut, 'Œ', '&#140;');
vcOut := REPLACE(vcOut, 'Ž', '&#142;');
vcOut := REPLACE(vcOut, '‘', '&#145;');
vcOut := REPLACE(vcOut, '’', '&#146;');
vcOut := REPLACE(vcOut, '“', '&#147;');
vcOut := REPLACE(vcOut, '”', '&#148;');
vcOut := REPLACE(vcOut, '•', '&#149;');
vcOut := REPLACE(vcOut, '–', '&#150;');
vcOut := REPLACE(vcOut, '—', '&#151;');
vcOut := REPLACE(vcOut, '˜', '&#152;');
vcOut := REPLACE(vcOut, '™', '&#153;');
vcOut := REPLACE(vcOut, 'š', '&#154;');
vcOut := REPLACE(vcOut, '›', '&#155;');
vcOut := REPLACE(vcOut, 'œ', '&#156;');
vcOut := REPLACE(vcOut, 'ž', '&#158;');
vcOut := REPLACE(vcOut, 'Ÿ', '&#159;');
vcOut := REPLACE(vcOut, '¡', '&#161;');
vcOut := REPLACE(vcOut, '¢', '&#162;');
vcOut := REPLACE(vcOut, '£', '&#163;');
vcOut := REPLACE(vcOut, '¤', '&#164;');
vcOut := REPLACE(vcOut, '¥', '&#165;');
vcOut := REPLACE(vcOut, '¦', '&#166;');
vcOut := REPLACE(vcOut, '§', '&#167;');
vcOut := REPLACE(vcOut, '¨', '&#168;');
vcOut := REPLACE(vcOut, '©', '&#169;');
vcOut := REPLACE(vcOut, 'ª', '&#170;');
vcOut := REPLACE(vcOut, '«', '&#171;');
vcOut := REPLACE(vcOut, '¬', '&#172;');
vcOut := REPLACE(vcOut, '­', '&#173;');
vcOut := REPLACE(vcOut, '®', '&#174;');
vcOut := REPLACE(vcOut, '¯', '&#175;');
vcOut := REPLACE(vcOut, '°', '&#176;');
vcOut := REPLACE(vcOut, '±', '&#177;');
vcOut := REPLACE(vcOut, '²', '&#178;');
vcOut := REPLACE(vcOut, '³', '&#179;');
vcOut := REPLACE(vcOut, '´', '&#180;');
vcOut := REPLACE(vcOut, 'µ', '&#181;');
vcOut := REPLACE(vcOut, '¶', '&#182;');
vcOut := REPLACE(vcOut, '·', '&#183;');
vcOut := REPLACE(vcOut, '¸', '&#184;');
vcOut := REPLACE(vcOut, '¹', '&#185;');
vcOut := REPLACE(vcOut, 'º', '&#186;');
vcOut := REPLACE(vcOut, '»', '&#187;');
vcOut := REPLACE(vcOut, '¼', '&#188;');
vcOut := REPLACE(vcOut, '½', '&#189;');
vcOut := REPLACE(vcOut, '¾', '&#190;');
vcOut := REPLACE(vcOut, '¿', '&#191;');
vcOut := REPLACE(vcOut, 'À', '&#192;');
vcOut := REPLACE(vcOut, 'Á', '&#193;');
vcOut := REPLACE(vcOut, 'Â', '&#194;');
vcOut := REPLACE(vcOut, 'Ã', '&#195;');
vcOut := REPLACE(vcOut, 'Ä', '&#196;');
vcOut := REPLACE(vcOut, 'Å', '&#197;');
vcOut := REPLACE(vcOut, 'Æ', '&#198;');
vcOut := REPLACE(vcOut, 'Ç', '&#199;');
vcOut := REPLACE(vcOut, 'È', '&#200;');
vcOut := REPLACE(vcOut, 'É', '&#201;');
vcOut := REPLACE(vcOut, 'Ê', '&#202;');
vcOut := REPLACE(vcOut, 'Ë', '&#203;');
vcOut := REPLACE(vcOut, 'Ì', '&#204;');
vcOut := REPLACE(vcOut, 'Í', '&#205;');
vcOut := REPLACE(vcOut, 'Î', '&#206;');
vcOut := REPLACE(vcOut, 'Ï', '&#207;');
vcOut := REPLACE(vcOut, 'Ð', '&#208;');
vcOut := REPLACE(vcOut, 'Ñ', '&#209;');
vcOut := REPLACE(vcOut, 'Ò', '&#210;');
vcOut := REPLACE(vcOut, 'Ó', '&#211;');
vcOut := REPLACE(vcOut, 'Ô', '&#212;');
vcOut := REPLACE(vcOut, 'Õ', '&#213;');
vcOut := REPLACE(vcOut, 'Ö', '&#214;');
vcOut := REPLACE(vcOut, '×', '&#215;');
vcOut := REPLACE(vcOut, 'Ø', '&#216;');
vcOut := REPLACE(vcOut, 'Ù', '&#217;');
vcOut := REPLACE(vcOut, 'Ú', '&#218;');
vcOut := REPLACE(vcOut, 'Û', '&#219;');
vcOut := REPLACE(vcOut, 'Ü', '&#220;');
vcOut := REPLACE(vcOut, 'Ý', '&#221;');
vcOut := REPLACE(vcOut, 'Þ', '&#222;');
vcOut := REPLACE(vcOut, 'ß', '&#223;');
vcOut := REPLACE(vcOut, 'à', '&#224;');
vcOut := REPLACE(vcOut, 'á', '&#225;');
vcOut := REPLACE(vcOut, 'â', '&#226;');
vcOut := REPLACE(vcOut, 'ã', '&#227;');
vcOut := REPLACE(vcOut, 'ä', '&#228;');
vcOut := REPLACE(vcOut, 'å', '&#229;');
vcOut := REPLACE(vcOut, 'æ', '&#230;');
vcOut := REPLACE(vcOut, 'ç', '&#231;');
vcOut := REPLACE(vcOut, 'è', '&#232;');
vcOut := REPLACE(vcOut, 'é', '&#233;');
vcOut := REPLACE(vcOut, 'ê', '&#234;');
vcOut := REPLACE(vcOut, 'ë', '&#235;');
vcOut := REPLACE(vcOut, 'ì', '&#236;');
vcOut := REPLACE(vcOut, 'í', '&#237;');
vcOut := REPLACE(vcOut, 'î', '&#238;');
vcOut := REPLACE(vcOut, 'ï', '&#239;');
vcOut := REPLACE(vcOut, 'ð', '&#240;');
vcOut := REPLACE(vcOut, 'ñ', '&#241;');
vcOut := REPLACE(vcOut, 'ò', '&#242;');
vcOut := REPLACE(vcOut, 'ó', '&#243;');
vcOut := REPLACE(vcOut, 'ô', '&#244;');
vcOut := REPLACE(vcOut, 'õ', '&#245;');
vcOut := REPLACE(vcOut, 'ö', '&#246;');
vcOut := REPLACE(vcOut, '÷', '&#247;');
vcOut := REPLACE(vcOut, 'ø', '&#248;');
vcOut := REPLACE(vcOut, 'ù', '&#249;');
vcOut := REPLACE(vcOut, 'ú', '&#250;');
vcOut := REPLACE(vcOut, 'û', '&#251;');
vcOut := REPLACE(vcOut, 'ü', '&#252;');
vcOut := REPLACE(vcOut, 'ý', '&#253;');
vcOut := REPLACE(vcOut, 'þ', '&#254;');
vcOut := REPLACE(vcOut, 'ÿ', '&#255;');
vcOut := REPLACE(vcOut, 'Ž', '&#381;');
vcOut := REPLACE(vcOut, 'ž', '&#382;');
RETURN(vcOut);
end;
/

grant all on cit_special_char_xml to public;

CREATE OR REPLACE function cit_special_char_html(vcText IN VARCHAR2) RETURN VARCHAR2
is
vcOut  VARCHAR2(32000);
begin
vcOut := vcText;
vcOut := REPLACE(vcOut, '&', '&#38;');
vcOut := REPLACE(vcOut, '€', '&euro;');
vcOut := REPLACE(vcOut, '‚', '&sbquo;');
vcOut := REPLACE(vcOut, 'ƒ', '&fnof;');
vcOut := REPLACE(vcOut, '„', '&bdquo;');
vcOut := REPLACE(vcOut, '…', '&hellip;');
vcOut := REPLACE(vcOut, '†', '&dagger;');
vcOut := REPLACE(vcOut, '‡', '&Dagger;');
vcOut := REPLACE(vcOut, 'ˆ', '&circ;');
vcOut := REPLACE(vcOut, '‰', '&permil;');
vcOut := REPLACE(vcOut, 'Š', '&Scaron;');
vcOut := REPLACE(vcOut, '‹', '&lsaquo;');
vcOut := REPLACE(vcOut, 'Œ', '&OElig;');
vcOut := REPLACE(vcOut, 'Ž', '&Zcaron;');
vcOut := REPLACE(vcOut, '‘', '&lsquo;');
vcOut := REPLACE(vcOut, '’', '&rsquo;');
vcOut := REPLACE(vcOut, '“', '&ldquo;');
vcOut := REPLACE(vcOut, '”', '&rdquo;');
vcOut := REPLACE(vcOut, '•', '&bull;');
vcOut := REPLACE(vcOut, '–', '&ndash;');
vcOut := REPLACE(vcOut, '—', '&mdash;');
vcOut := REPLACE(vcOut, '˜', '&tilde;');
vcOut := REPLACE(vcOut, '™', '&trade;');
vcOut := REPLACE(vcOut, 'š', '&scaron;');
vcOut := REPLACE(vcOut, '›', '&rsaquo;');
vcOut := REPLACE(vcOut, 'œ', '&oelig;');
vcOut := REPLACE(vcOut, 'ž', '&zcaron;');
vcOut := REPLACE(vcOut, 'Ÿ', '&yuml;');
vcOut := REPLACE(vcOut, '¡', '&iexcl;');
vcOut := REPLACE(vcOut, '¢', '&cent;');
vcOut := REPLACE(vcOut, '£', '&pound;');
vcOut := REPLACE(vcOut, '¤', '&curren;');
vcOut := REPLACE(vcOut, '¥', '&yen;');
vcOut := REPLACE(vcOut, '¦', '&brvbar;');
vcOut := REPLACE(vcOut, '§', '&sect;');
vcOut := REPLACE(vcOut, '¨', '&uml;');
vcOut := REPLACE(vcOut, '©', '&copy;');
vcOut := REPLACE(vcOut, 'ª', '&ordf;');
vcOut := REPLACE(vcOut, '«', '&laquo;');
vcOut := REPLACE(vcOut, '¬', '&not;');
vcOut := REPLACE(vcOut, '­', '&shy;');
vcOut := REPLACE(vcOut, '®', '&reg;');
vcOut := REPLACE(vcOut, '¯', '&macr;');
vcOut := REPLACE(vcOut, '°', '&deg;');
vcOut := REPLACE(vcOut, '±', '&plusmn;');
vcOut := REPLACE(vcOut, '²', '&sup2;');
vcOut := REPLACE(vcOut, '³', '&sup3;');
vcOut := REPLACE(vcOut, '´', '&acute;');
vcOut := REPLACE(vcOut, 'µ', '&micro;');
vcOut := REPLACE(vcOut, '¶', '&para;');
vcOut := REPLACE(vcOut, '·', '&middot;');
vcOut := REPLACE(vcOut, '¸', '&cedil;');
vcOut := REPLACE(vcOut, '¹', '&sup1;');
vcOut := REPLACE(vcOut, 'º', '&ordm;');
vcOut := REPLACE(vcOut, '»', '&raquo;');
vcOut := REPLACE(vcOut, '¼', '&frac14;');
vcOut := REPLACE(vcOut, '½', '&frac12;');
vcOut := REPLACE(vcOut, '¾', '&frac34;');
vcOut := REPLACE(vcOut, '¿', '&iquest;');
vcOut := REPLACE(vcOut, 'À', '&Agrave;');
vcOut := REPLACE(vcOut, 'Á', '&Aacute;');
vcOut := REPLACE(vcOut, 'Â', '&Acirc;');
vcOut := REPLACE(vcOut, 'Ã', '&Atilde;');
vcOut := REPLACE(vcOut, 'Ä', '&Auml;');
vcOut := REPLACE(vcOut, 'Å', '&Aring;');
vcOut := REPLACE(vcOut, 'Æ', '&AElig;');
vcOut := REPLACE(vcOut, 'Ç', '&Ccedil;');
vcOut := REPLACE(vcOut, 'È', '&Egrave;');
vcOut := REPLACE(vcOut, 'É', '&Eacute;');
vcOut := REPLACE(vcOut, 'Ê', '&Ecirc;');
vcOut := REPLACE(vcOut, 'Ë', '&Euml;');
vcOut := REPLACE(vcOut, 'Ì', '&Igrave;');
vcOut := REPLACE(vcOut, 'Í', '&Iacute;');
vcOut := REPLACE(vcOut, 'Î', '&Icirc;');
vcOut := REPLACE(vcOut, 'Ï', '&Iuml;');
vcOut := REPLACE(vcOut, 'Ð', '&ETH;');
vcOut := REPLACE(vcOut, 'Ñ', '&Ntilde;');
vcOut := REPLACE(vcOut, 'Ò', '&Ograve;');
vcOut := REPLACE(vcOut, 'Ó', '&Oacute;');
vcOut := REPLACE(vcOut, 'Ô', '&Ocirc;');
vcOut := REPLACE(vcOut, 'Õ', '&Otilde;');
vcOut := REPLACE(vcOut, 'Ö', '&Ouml;');
vcOut := REPLACE(vcOut, '×', '&times;');
vcOut := REPLACE(vcOut, 'Ø', '&Oslash;');
vcOut := REPLACE(vcOut, 'Ù', '&Ugrave;');
vcOut := REPLACE(vcOut, 'Ú', '&Uacute;');
vcOut := REPLACE(vcOut, 'Û', '&Ucirc;');
vcOut := REPLACE(vcOut, 'Ü', '&Uuml;');
vcOut := REPLACE(vcOut, 'Ý', '&Yacute;');
vcOut := REPLACE(vcOut, 'Þ', '&THORN;');
vcOut := REPLACE(vcOut, 'ß', '&szlig;');
vcOut := REPLACE(vcOut, 'à', '&agrave;');
vcOut := REPLACE(vcOut, 'á', '&aacute;');
vcOut := REPLACE(vcOut, 'â', '&acirc;');
vcOut := REPLACE(vcOut, 'ã', '&atilde;');
vcOut := REPLACE(vcOut, 'ä', '&auml;');
vcOut := REPLACE(vcOut, 'å', '&aring;');
vcOut := REPLACE(vcOut, 'æ', '&aelig;');
vcOut := REPLACE(vcOut, 'ç', '&ccedil;');
vcOut := REPLACE(vcOut, 'è', '&egrave;');
vcOut := REPLACE(vcOut, 'é', '&eacute;');
vcOut := REPLACE(vcOut, 'ê', '&ecirc;');
vcOut := REPLACE(vcOut, 'ë', '&euml;');
vcOut := REPLACE(vcOut, 'ì', '&igrave;');
vcOut := REPLACE(vcOut, 'í', '&iacute;');
vcOut := REPLACE(vcOut, 'î', '&icirc;');
vcOut := REPLACE(vcOut, 'ï', '&iuml;');
vcOut := REPLACE(vcOut, 'ð', '&eth;');
vcOut := REPLACE(vcOut, 'ñ', '&ntilde;');
vcOut := REPLACE(vcOut, 'ò', '&ograve;');
vcOut := REPLACE(vcOut, 'ó', '&oacute;');
vcOut := REPLACE(vcOut, 'ô', '&ocirc;');
vcOut := REPLACE(vcOut, 'õ', '&otilde;');
vcOut := REPLACE(vcOut, 'ö', '&ouml;');
vcOut := REPLACE(vcOut, '÷', '&divide;');
vcOut := REPLACE(vcOut, 'ø', '&oslash;');
vcOut := REPLACE(vcOut, 'ù', '&ugrave;');
vcOut := REPLACE(vcOut, 'ú', '&uacute;');
vcOut := REPLACE(vcOut, 'û', '&ucirc;');
vcOut := REPLACE(vcOut, 'ü', '&uuml;');
vcOut := REPLACE(vcOut, 'ý', '&yacute;');
vcOut := REPLACE(vcOut, 'þ', '&thorn;');
vcOut := REPLACE(vcOut, 'ÿ', '&yuml;');
RETURN(vcOut);
end;
/

grant all on cit_special_char_html to public;

CREATE OR REPLACE function cit_special_char_unicode(vcText IN VARCHAR2) RETURN VARCHAR2
is
  v_unicode varchar2(5);
  i number;
  vcWork varchar2(32000);
  vcOut varchar2(32000);
begin
  i := 1;
  vcWork := replace(vcText, chr(38), chr(38) || '#38;');
  vcOut := '';
  while i <= length(vcWork)
  loop
    v_unicode := asciistr(substr(vcWork,i,1));
    if length (v_unicode) = 1
    then
      vcOut := vcOut || v_unicode;
    else
      vcOut := vcOut || chr(38) || replace(v_unicode,'\','#x') || ';';
    end if;
    i := i + 1;
  end loop;
  return(vcOut);
end;
/

grant all on cit_special_char_unicode to public;