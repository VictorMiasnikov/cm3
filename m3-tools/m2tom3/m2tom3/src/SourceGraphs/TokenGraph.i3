INTERFACE TokenGraph;

(***************************************************************************)
(**                  This file is part of m2tom3
       (C) 1991-1994 Lehrstuhl fuer Informatik III, RWTH Aachen
                         All Rights Reserved
*)
(** Created by:  Reiner Nix                                                *)

(** pk
    1.1
    1994/11/30 15:09:20
    TokenGraph.i3,v
# Revision 1.1  1994/11/30  15:09:20  pk
# Release Version 2.00.
#
*)
(***************************************************************************)

(** --- TokenGraph -------------------------------------------------------------
  * This abstract data type module represents a token graph, which bases on a
  * SimpleGraph. The handling of multiple token streams is added. Token
  * streams are build on tokens, token edges and token anchors.
  * ----------------------------------------------------------------------------
  **)

IMPORT BaseGraph AS Super;
IMPORT Token, TokenAnchor;
IMPORT BaseGraph;


EXCEPTION
  NoAnchor;
  NotInStream;


TYPE
  T <: Public;

  Public =
    Super.T OBJECT
    METHODS
      insertAnchor (anchor: TokenAnchor.T) RAISES {BaseGraph.NodeInGraph};
                    (* Inserts an already created anchor to this graph.
                       Anchors can only added once otherwise you get the
                       exception BaseGraph.NodeInGraph. *)

      findAnchor (token: Token.T): TokenAnchor.T
                  RAISES {BaseGraph.NodeNotInGraph};
                  (* Searchs the anchor to a given token.  The token must
                     be in the graph, otherwise you get exception
                     BaseGraph.NodeNotInGraph.  If no anchor can be found
                     you get NIL. *)

      appendToken (anchor  : TokenAnchor.T;
                   token   : Token.T;
                   previous: Token.T         := NIL)
                   RAISES {NoAnchor, NotInStream, BaseGraph.NodeInGraph,
                           BaseGraph.NodeNotInGraph};
                   (* Inserts an already created token to this graph and
                      stream identified by anchor.  If you don't specify a
                      previous token the new token is appended behind all
                      other tokens in this stream.  It is a checked error
                      to specify no anchor (exception NoAnchor), anchor or
                      previous not beeing in the graph (exception
                      BaseGraph.NodeNotInGraph), if previous exists and is
                      not in the stream indentified by your anchor
                      (exception NotInStream) or if your token is already
                      in the graph (BaseGraph.NodeInGraph) *)


      prependToken (anchor: TokenAnchor.T;
                    token : Token.T;
                    follow: Token.T         := NIL)
                    RAISES {NoAnchor, NotInStream, BaseGraph.NodeInGraph,
                            BaseGraph.NodeNotInGraph};
                    (* Inserts an already created token to this graph and
                       stream before the follow token.  See appendToken for
                       further details. *)


      getFirstToken (anchor: TokenAnchor.T; language: Token.Language):
                     Token.T RAISES {NoAnchor, BaseGraph.NodeNotInGraph};
                     (* Retrieves the first token of the given stream
                        matching your language.  If no token is found
                        you'll get the result NIL.  It is a checked error
                        to specify no anchor (exception NoAnchor) or if
                        your anchor isn't in the graph (exception
                        BaseGraph.NodeNotInGraph). *)


      getNextToken (source: Token.T; language: Token.Language): Token.T
                    RAISES {BaseGraph.NodeNotInGraph};
                    (* Retrieves the token following the source token
                       matching the specified language.  If either source
                       is NIL or no token is found, you'll get the result
                       NIL.  It is a checked error if your source node is
                       not member of the given graph (exception
                       BaseGraph.NodeNotInGraph) *)


      getPrevToken (source: Token.T; language: Token.Language): Token.T
                    RAISES {BaseGraph.NodeNotInGraph};
                    (* Retrieves the token before source matching the
                       specified language.  See getNextToken for further
                       details. *)
    END;

END TokenGraph.
