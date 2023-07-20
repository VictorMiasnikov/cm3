

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

���-����? ���� �����. �ܨ� ������ ��� ����!
���-����? ���� �����. ���� ������ ��� ����!
���-����? ���� �����. ���� ������ ��� ����!

�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �
�    �-->�    �

D:\cm3\src\examples\hellocp1251>

*)

BEGIN

  IO.Put ("                                           \n");
  IO.Put ("���-����? ���� �����. �ܨ� ������ ��� ����!\n");
  IO.Put ("���-����? ���� �����. ���� ������ ��� ����!\n");
  IO.Put ("���-����? ���� �����. ���� ������ ��� ����!\n");
  IO.Put ("                                           \n");

  
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
  IO.PutChar('�'); IO.Put ("    "); IO.PutChar('�'); IO.Put ("-->");  IO.PutChar(W'�'); IO.Put ("    "); IO.PutChar(W'�'); IO.Put ("\n");
                                                                                                            
END Hellocp1251.

(* Don't forget to include the module name in the last "END" in your
   program. *)
