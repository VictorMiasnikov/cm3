MODULE Main;

PROCEDURE NotConstL(a: LONGINT): LONGINT =
  BEGIN
    RETURN a;
  END NotConstL;

BEGIN
  <* ASSERT FIRST(LONGINT) = (FIRST(LONGINT) DIV NotConstL(1L)) *>
  <* ASSERT LAST(LONGINT) = (LAST(LONGINT) DIV NotConstL(1L)) *>
END Main.