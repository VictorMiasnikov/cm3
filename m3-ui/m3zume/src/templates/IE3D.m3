(* Copyright (C) 1995, Digital Equipment Corporation.       *)
(* All rights reserved.                                     *)
(* See the file COPYRIGHT for a full description.           *)
(*                                                          *)
(* Last modified on Thu Feb  9 09:00:07 PST 1995 by kalsow  *)
(*      modified on Mon Nov 29 08:07:34 PST 1993 by najork  *)
(*      modified on Wed Feb 17 16:46:47 PST 1993 by johnh   *)
(*      modified on Tue Jun  9 00:41:25 1992 by mhb         *)

(*********************************************************************
|*  NOTE: This file is generated automatically from the event
|*        definition file #(_ALGNAME_).evt.
|*********************************************************************)

<* PRAGMA LL *>

MODULE #(_ALGNAME_)IE;

$Algorithm
$AlgorithmClass
$Thread
$View
$Zeus
$ZeusClass
$#(_ALGNAME_)AlgClass
$#(_ALGNAME_)ViewClass
$#(_ALGNAME_)3DViewClass
#(_IMPORTS_)

<* FATAL Zeus.Error, Zeus.Locked *>
(* If you get either of these errors, contact a Zeus implementor. *)

TYPE
#{
  #(_EVENT_)Args = BRANDED REF RECORD
#{
    #(_ARGNAME_): #(_ARGTYPE_);
#}
  END;

#}

(*  Zeus calls the following to invoke vbt v's event handler: *)

PROCEDURE OEDispatcher(v: ZeusClass.T; evt: REFANY) RAISES {Thread.Alerted} =
  <* LL <= VBT.mu *>
  (* LL = {} if event style is output, LL = VBT.mu if event style is update. *)
  BEGIN
    TYPECASE v OF
    | #(_ALGNAME_)ViewClass.T (view) =>
      TYPECASE evt OF
#{_OUTPUT
      | #(_EVENT_)Args(var#(_EVENT_)Args) =>
          view.oe#(_EVENT_) (
#{
              var#(_EVENT_)Args.#(_ARGNAME_)
#|
                ,
#}
              )
#}
#{_UPDATE
      | #(_EVENT_)Args(var#(_EVENT_)Args) =>
          view.ue#(_EVENT_) (
#{
              var#(_EVENT_)Args.#(_ARGNAME_)
#|
                ,
#}
              )
#}
      ELSE <* ASSERT FALSE *>
      END;
    | #(_ALGNAME_)3DViewClass.T (view) =>
      TYPECASE evt OF
#{_OUTPUT
      | #(_EVENT_)Args(var#(_EVENT_)Args) =>
          view.oe#(_EVENT_) (
#{
              var#(_EVENT_)Args.#(_ARGNAME_)
#|
                ,
#}
              )
#}
#{_UPDATE
      | #(_EVENT_)Args(var#(_EVENT_)Args) =>
          view.ue#(_EVENT_) (
#{
              var#(_EVENT_)Args.#(_ARGNAME_)
#|
                ,
#}
              )
#}
      ELSE <* ASSERT FALSE *>
      END;
    ELSE (* this view isn't a #(_ALGNAME_)3DViewClass or
            a #(_ALGNAME_)3DViewClass, so just ignore *)
    END
  END OEDispatcher;

PROCEDURE FEDispatcher(v: ZeusClass.T; evt: REFANY) =
  <* LL = VBT.mu *>
  BEGIN
    TYPECASE v OF
    | #(_ALGNAME_)AlgClass.T (alg) =>
      TYPECASE evt OF
#{_FEEDBACK
      | #(_EVENT_)Args(var#(_EVENT_)Args) =>
          alg.fe#(_EVENT_) (
#{
              var#(_EVENT_)Args.#(_ARGNAME_)
#|
                ,
#}
              )
#}
      ELSE <* ASSERT FALSE *>
      END;
    ELSE (* this alg isn't a #(_ALGNAME_)AlgClass, so just ignore *)
    END
  END FEDispatcher;


#{_OUTPUT
PROCEDURE #(_EVENT_) (
      initiator: Algorithm.T;
      #(_ARGSTR_)
    ) RAISES {Thread.Alerted} =
  <* LL = {} *>
  VAR zumeArgRec := NEW(#(_EVENT_)Args
#{
               , #(_ARGNAME_) := #(_ARGNAME_)
#}
      );
      alg := NARROW(initiator, #(_ALGNAME_)AlgClass.T);
  BEGIN
    LOCK alg.evtMu DO
      INC(alg.eventDataRec.ctOf#(_EVENT_));
      alg.stopAtEvent := alg.eventDataRec.stopAt#(_EVENT_);
      alg.waitAtEvent := alg.eventDataRec.waitAt#(_EVENT_);
      Zeus.Dispatch(initiator, Zeus.EventStyle.Output, #(_EVENTPRIO_),
                    "#(_EVENT_)", OEDispatcher, zumeArgRec);
    END;
  END #(_EVENT_);

#}
#{_UPDATE
PROCEDURE #(_EVENT_) (
      initiator: Algorithm.T;
      #(_ARGSTR_)
    ) RAISES {Thread.Alerted} =
  <* LL = VBT.mu *>
  VAR zumeArgRec := NEW(#(_EVENT_)Args
#{
               , #(_ARGNAME_) := #(_ARGNAME_)
#}
      );
  BEGIN
    Zeus.Dispatch(initiator, Zeus.EventStyle.Update, #(_EVENTPRIO_),
                  "#(_EVENT_)", OEDispatcher, zumeArgRec);
  END #(_EVENT_);

#}

#{_FEEDBACK
PROCEDURE #(_EVENT_) (
      initiator: View.T;
      #(_ARGSTR_)
    ) RAISES {Thread.Alerted} =
  <* LL = VBT.mu *>
  VAR zumeArgRec := NEW(#(_EVENT_)Args
#{
               , #(_ARGNAME_) := #(_ARGNAME_)
#}
      );
  BEGIN
    Zeus.Dispatch(initiator, Zeus.EventStyle.Notify, #(_EVENTPRIO_),
                  "#(_EVENT_)", FEDispatcher, zumeArgRec);
  END #(_EVENT_);

#}

BEGIN
END #(_ALGNAME_)IE.
