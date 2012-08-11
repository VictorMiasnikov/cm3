(*********************************************************************)
(*                                                                   *)
(* TrackerPositionTstPRX.i3                                          *)
(* -- autogenerated by SOCodeGen --                                  *)
(* Thu Dec 21 08:02:15 EST 1995                                      *)
(*                                                                   *)
(*********************************************************************)

INTERFACE TrackerPositionTstPRX;

IMPORT TrackerPositionTstF, TrackerPositionTst, SharedObj, TrackerPositionTst2F, EmbProxiedObj;

VAR

 MkProxy_TrackerPositionTst_T : PROCEDURE(x: TrackerPositionTst.T) := NIL;
 MkProxy_TrackerPositionTst_T_CB : PROCEDURE(x: TrackerPositionTstCB.TrackerPositionTst_T) := NIL;

 MkProxy_TrackerPositionTst_U : PROCEDURE(x: TrackerPositionTst.U) := NIL;
 MkProxy_TrackerPositionTst_U_CB : PROCEDURE(x: TrackerPositionTstCB.TrackerPositionTst_U) := NIL;

TYPE
 CBProxy_TrackerPositionTst_T = EmbProxiedObj.Proxy OBJECT
  METHODS
   pre_anyChange(READONLY obj: TrackerPositionTst.T);
   post_anyChange(READONLY obj: TrackerPositionTst.T);
   pre_init( READONLY obj: TrackerPositionTst.T): BOOLEAN;
   post_init( READONLY obj: TrackerPositionTst.T): BOOLEAN;
   pre_set( READONLY obj: TrackerPositionTst.T;
   READONLY val: TrackerPositionTst.Data): BOOLEAN;
   post_set( READONLY obj: TrackerPositionTst.T;
   READONLY val: TrackerPositionTst.Data): BOOLEAN;
  END;


TYPE
 CBProxy_TrackerPositionTst_U = EmbProxiedObj.Proxy OBJECT
  METHODS
   pre_anyChange(READONLY obj: TrackerPositionTst.U);
   post_anyChange(READONLY obj: TrackerPositionTst.U);
   pre_set( READONLY obj: TrackerPositionTst.U;
   READONLY val: TrackerPositionTst.Data): BOOLEAN;
   post_set( READONLY obj: TrackerPositionTst.U;
   READONLY val: TrackerPositionTst.Data): BOOLEAN;
  END;


END TrackerPositionTstPRX.