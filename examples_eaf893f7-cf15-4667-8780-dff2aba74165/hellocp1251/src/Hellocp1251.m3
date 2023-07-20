

MODULE Hellocp1251 EXPORTS Main;
(* Each module must have a name, which is declared in the "MODULE"
   statement. By convention, the main module for an executable 
   program exports the interface "Main", as does the "Hello" module here.

   Each module can also import interfaces exported by other modules.
   This is how you reuse code from libraries or your own modules. 
   Here, we have imported interface "IO" which is a simple 
   input/output interface.

   From the browser, you can learn what the imported interfaces do
   by following the link associated with their name. *)

IMPORT IO;

(* The main body of a module or the initialization section includes
   statements that are executed at the begining of the program. 
   In this case, we are the main module, and all we do is print 
   "Hello World!" on standard output.

    Demo of using:
D:\cm3\src\examples\hellocp1251>chcp 1251
Active code page: 1251

D:\cm3\src\examples\hellocp1251>.\AMD64_NT\hellocp1251.exe

ÝÊÑ-ÃÐÀÔ? ÏËÞØ ÈÇÚßÒ. ÁÜ¨Ì ×ÓÆÄÛÉ ÖÅÍ ÕÂÎÙ!
Ýêñ-ãðàô? Ïëþø èçúÿò. Áü¸ì ÷óæäûé öåí õâîù!
ýêñ-ãðàô? ïëþø èçúÿò. áü¸ì ÷óæäûé öåí õâîù!

À    à-->À    à
Á    á-->Á    á
Â    â-->Â    â
Ã    ã-->Ã    ã
Ä    ä-->Ä    ä
Å    å-->Å    å
¨    ¸-->¨    ¸
Æ    æ-->Æ    æ
Ç    ç-->Ç    ç
È    è-->È    è
É    é-->É    é
Ê    ê-->Ê    ê
Ë    ë-->Ë    ë
Ì    ì-->Ì    ì
Í    í-->Í    í
Î    î-->Î    î
Ï    ï-->Ï    ï
Ð    ð-->Ð    ð
Ñ    ñ-->Ñ    ñ
Ò    ò-->Ò    ò
Ó    ó-->Ó    ó
Ô    ô-->Ô    ô
Õ    õ-->Õ    õ
Ö    ö-->Ö    ö
×    ÷-->×    ÷
Ø    ø-->Ø    ø
Ù    ù-->Ù    ù
Ú    ú-->Ú    ú
Û    û-->Û    û
Ü    ü-->Ü    ü
Ý    ý-->Ý    ý
Þ    þ-->Þ    þ
ß    ÿ-->ß    ÿ

D:\cm3\src\examples\hellocp1251>

*)

BEGIN

  IO.Put ("                                           \n");
  IO.Put ("ÝÊÑ-ÃÐÀÔ? ÏËÞØ ÈÇÚßÒ. ÁÜ¨Ì ×ÓÆÄÛÉ ÖÅÍ ÕÂÎÙ!\n");
  IO.Put ("Ýêñ-ãðàô? Ïëþø èçúÿò. Áü¸ì ÷óæäûé öåí õâîù!\n");
  IO.Put ("ýêñ-ãðàô? ïëþø èçúÿò. áü¸ì ÷óæäûé öåí õâîù!\n");
  IO.Put ("                                           \n");

  
  IO.PutChar('À'); IO.Put ("    "); IO.PutChar('à'); IO.Put ("-->");  IO.PutChar(W'À'); IO.Put ("    "); IO.PutChar(W'à'); IO.Put ("\n");
  IO.PutChar('Á'); IO.Put ("    "); IO.PutChar('á'); IO.Put ("-->");  IO.PutChar(W'Á'); IO.Put ("    "); IO.PutChar(W'á'); IO.Put ("\n");
  IO.PutChar('Â'); IO.Put ("    "); IO.PutChar('â'); IO.Put ("-->");  IO.PutChar(W'Â'); IO.Put ("    "); IO.PutChar(W'â'); IO.Put ("\n");
  IO.PutChar('Ã'); IO.Put ("    "); IO.PutChar('ã'); IO.Put ("-->");  IO.PutChar(W'Ã'); IO.Put ("    "); IO.PutChar(W'ã'); IO.Put ("\n");
  IO.PutChar('Ä'); IO.Put ("    "); IO.PutChar('ä'); IO.Put ("-->");  IO.PutChar(W'Ä'); IO.Put ("    "); IO.PutChar(W'ä'); IO.Put ("\n");
  IO.PutChar('Å'); IO.Put ("    "); IO.PutChar('å'); IO.Put ("-->");  IO.PutChar(W'Å'); IO.Put ("    "); IO.PutChar(W'å'); IO.Put ("\n");
  IO.PutChar('¨'); IO.Put ("    "); IO.PutChar('¸'); IO.Put ("-->");  IO.PutChar(W'¨'); IO.Put ("    "); IO.PutChar(W'¸'); IO.Put ("\n");
  IO.PutChar('Æ'); IO.Put ("    "); IO.PutChar('æ'); IO.Put ("-->");  IO.PutChar(W'Æ'); IO.Put ("    "); IO.PutChar(W'æ'); IO.Put ("\n");
  IO.PutChar('Ç'); IO.Put ("    "); IO.PutChar('ç'); IO.Put ("-->");  IO.PutChar(W'Ç'); IO.Put ("    "); IO.PutChar(W'ç'); IO.Put ("\n");
  IO.PutChar('È'); IO.Put ("    "); IO.PutChar('è'); IO.Put ("-->");  IO.PutChar(W'È'); IO.Put ("    "); IO.PutChar(W'è'); IO.Put ("\n");
  IO.PutChar('É'); IO.Put ("    "); IO.PutChar('é'); IO.Put ("-->");  IO.PutChar(W'É'); IO.Put ("    "); IO.PutChar(W'é'); IO.Put ("\n");
  IO.PutChar('Ê'); IO.Put ("    "); IO.PutChar('ê'); IO.Put ("-->");  IO.PutChar(W'Ê'); IO.Put ("    "); IO.PutChar(W'ê'); IO.Put ("\n");
  IO.PutChar('Ë'); IO.Put ("    "); IO.PutChar('ë'); IO.Put ("-->");  IO.PutChar(W'Ë'); IO.Put ("    "); IO.PutChar(W'ë'); IO.Put ("\n");
  IO.PutChar('Ì'); IO.Put ("    "); IO.PutChar('ì'); IO.Put ("-->");  IO.PutChar(W'Ì'); IO.Put ("    "); IO.PutChar(W'ì'); IO.Put ("\n");
  IO.PutChar('Í'); IO.Put ("    "); IO.PutChar('í'); IO.Put ("-->");  IO.PutChar(W'Í'); IO.Put ("    "); IO.PutChar(W'í'); IO.Put ("\n");
  IO.PutChar('Î'); IO.Put ("    "); IO.PutChar('î'); IO.Put ("-->");  IO.PutChar(W'Î'); IO.Put ("    "); IO.PutChar(W'î'); IO.Put ("\n");
  IO.PutChar('Ï'); IO.Put ("    "); IO.PutChar('ï'); IO.Put ("-->");  IO.PutChar(W'Ï'); IO.Put ("    "); IO.PutChar(W'ï'); IO.Put ("\n");
  IO.PutChar('Ð'); IO.Put ("    "); IO.PutChar('ð'); IO.Put ("-->");  IO.PutChar(W'Ð'); IO.Put ("    "); IO.PutChar(W'ð'); IO.Put ("\n");
  IO.PutChar('Ñ'); IO.Put ("    "); IO.PutChar('ñ'); IO.Put ("-->");  IO.PutChar(W'Ñ'); IO.Put ("    "); IO.PutChar(W'ñ'); IO.Put ("\n");
  IO.PutChar('Ò'); IO.Put ("    "); IO.PutChar('ò'); IO.Put ("-->");  IO.PutChar(W'Ò'); IO.Put ("    "); IO.PutChar(W'ò'); IO.Put ("\n");
  IO.PutChar('Ó'); IO.Put ("    "); IO.PutChar('ó'); IO.Put ("-->");  IO.PutChar(W'Ó'); IO.Put ("    "); IO.PutChar(W'ó'); IO.Put ("\n");
  IO.PutChar('Ô'); IO.Put ("    "); IO.PutChar('ô'); IO.Put ("-->");  IO.PutChar(W'Ô'); IO.Put ("    "); IO.PutChar(W'ô'); IO.Put ("\n");
  IO.PutChar('Õ'); IO.Put ("    "); IO.PutChar('õ'); IO.Put ("-->");  IO.PutChar(W'Õ'); IO.Put ("    "); IO.PutChar(W'õ'); IO.Put ("\n");
  IO.PutChar('Ö'); IO.Put ("    "); IO.PutChar('ö'); IO.Put ("-->");  IO.PutChar(W'Ö'); IO.Put ("    "); IO.PutChar(W'ö'); IO.Put ("\n");
  IO.PutChar('×'); IO.Put ("    "); IO.PutChar('÷'); IO.Put ("-->");  IO.PutChar(W'×'); IO.Put ("    "); IO.PutChar(W'÷'); IO.Put ("\n");
  IO.PutChar('Ø'); IO.Put ("    "); IO.PutChar('ø'); IO.Put ("-->");  IO.PutChar(W'Ø'); IO.Put ("    "); IO.PutChar(W'ø'); IO.Put ("\n");
  IO.PutChar('Ù'); IO.Put ("    "); IO.PutChar('ù'); IO.Put ("-->");  IO.PutChar(W'Ù'); IO.Put ("    "); IO.PutChar(W'ù'); IO.Put ("\n");
  IO.PutChar('Ú'); IO.Put ("    "); IO.PutChar('ú'); IO.Put ("-->");  IO.PutChar(W'Ú'); IO.Put ("    "); IO.PutChar(W'ú'); IO.Put ("\n");
  IO.PutChar('Û'); IO.Put ("    "); IO.PutChar('û'); IO.Put ("-->");  IO.PutChar(W'Û'); IO.Put ("    "); IO.PutChar(W'û'); IO.Put ("\n");
  IO.PutChar('Ü'); IO.Put ("    "); IO.PutChar('ü'); IO.Put ("-->");  IO.PutChar(W'Ü'); IO.Put ("    "); IO.PutChar(W'ü'); IO.Put ("\n");
  IO.PutChar('Ý'); IO.Put ("    "); IO.PutChar('ý'); IO.Put ("-->");  IO.PutChar(W'Ý'); IO.Put ("    "); IO.PutChar(W'ý'); IO.Put ("\n");
  IO.PutChar('Þ'); IO.Put ("    "); IO.PutChar('þ'); IO.Put ("-->");  IO.PutChar(W'Þ'); IO.Put ("    "); IO.PutChar(W'þ'); IO.Put ("\n");
  IO.PutChar('ß'); IO.Put ("    "); IO.PutChar('ÿ'); IO.Put ("-->");  IO.PutChar(W'ß'); IO.Put ("    "); IO.PutChar(W'ÿ'); IO.Put ("\n");
                                                                                                            
END Hellocp1251.

(* Don't forget to include the module name in the last "END" in your
   program. *)
