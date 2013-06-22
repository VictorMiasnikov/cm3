(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.11
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtSplashScreen;

FROM QtPixmap IMPORT QPixmap;
FROM QtColor IMPORT QColor;
FROM QtWidget IMPORT QWidget;
FROM QtNamespace IMPORT WindowTypes;


TYPE T = QSplashScreen;


TYPE
  QSplashScreen <: QSplashScreenPublic;
  QSplashScreenPublic =
    QWidget BRANDED OBJECT
    METHODS
      init_0 (pixmap: QPixmap; f: WindowTypes; ): QSplashScreen;
      init_1 (pixmap: QPixmap; ): QSplashScreen;
      init_2 (): QSplashScreen;
      init_3 (parent: QWidget; pixmap: QPixmap; f: WindowTypes; ):
              QSplashScreen;
      init_4       (parent: QWidget; pixmap: QPixmap; ): QSplashScreen;
      init_5       (parent: QWidget; ): QSplashScreen;
      setPixmap    (pixmap: QPixmap; );
      pixmap       (): QPixmap;
      finish       (w: QWidget; );
      repaint      ();
      showMessage  (message: TEXT; alignment: INTEGER; color: QColor; );
      showMessage1 (message: TEXT; alignment: INTEGER; );
      showMessage2 (message: TEXT; );
      clearMessage ();
      destroyCxx   ();
    END;


END QtSplashScreen.
