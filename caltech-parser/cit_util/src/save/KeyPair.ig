GENERIC INTERFACE KeyPair(Key1, Key2);
(* generic interface used to construct pairs as table keys *)
IMPORT Word;

CONST 
  Brand = "KeyPair(" & Key1.Brand & "," & Key2.Brand & ")";

TYPE
  T = RECORD k1 : Key1.T; k2 : Key2.T; END;

PROCEDURE Equal(READONLY a , b : T) : BOOLEAN;

PROCEDURE Hash(READONLY a : T) : Word.T;

END KeyPair.
