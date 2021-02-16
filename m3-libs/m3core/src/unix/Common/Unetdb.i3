(* Copyright (C) 1990, Digital Equipment Corporation.         *)
(* All rights reserved.                                       *)
(* See the file COPYRIGHT for a full description.             *)

UNSAFE INTERFACE Unetdb;

FROM Ctypes IMPORT int, char_star, char_star_star, const_char_star;
IMPORT Uin;

TYPE
(* This is a portable idealized form that need not match the
underlying platform. This is sorted by size and then by name. *)
  struct_hostent = RECORD
    h_addr_list:  char_star_star;
    h_aliases:    char_star_star;
    h_name:       char_star;
    h_addrtype:   int; (* underlying implementation varies here *)
    h_length:     int; (* underlying implementation varies here *)
  END;
  struct_hostent_star = UNTRACED REF struct_hostent;

(*CONST*)
<*EXTERNAL "Unetdb__TRY_AGAIN"*>   VAR TRY_AGAIN:   int;
<*EXTERNAL "Unetdb__NO_RECOVERY"*> VAR NO_RECOVERY: int;
<*EXTERNAL "Unetdb__NO_ADDRESS"*>  VAR NO_ADDRESS:  int;

(* These are thin C wrappers that do not quite match the underlying
   function, but are very close.
success:
    native struct is copied into provided struct, and pointer to provided
    struct returned
failure:
    null returned

Despite the result buffer provided, the functions are no more thread safe
than their underlying implementation.
*)

<*EXTERNAL Unetdb__gethostbyname*>
PROCEDURE gethostbyname (name: const_char_star;
                         result: struct_hostent_star): struct_hostent_star;

<*EXTERNAL Unetdb__gethostbyaddr*>
PROCEDURE gethostbyaddr (addr: const_char_star; len: int; type: int;
                         result: struct_hostent_star): struct_hostent_star;

TYPE
  socklen_t = int; (* this should be Utypes.socklen_t but it breaks. *)

  addrinfo_t = RECORD
    ai_flags: int;
    ai_family: int;
    ai_socktype: int;
    ai_protocol: int;
    ai_addrlen: socklen_t;
    ai_addr: UNTRACED REF Uin.struct_sockaddr;
    ai_canonname: char_star;
    ai_next: UNTRACED REF addrinfo_t;
  END;

<*EXTERNAL*>
PROCEDURE getaddrinfo(name: const_char_star;
                      service: const_char_star;
                      hints: UNTRACED REF addrinfo_t;
                      VAR res: UNTRACED REF addrinfo_t): int;

<*EXTERNAL*>
PROCEDURE freeaddrinfo(addrinfo: UNTRACED REF addrinfo_t);

<*EXTERNAL*>
PROCEDURE getnameinfo(addr : (*const*) UNTRACED REF Uin.struct_sockaddr;
                      addrlen : socklen_t;
                      host : char_star;
                      hostlen : socklen_t;
                      serv : char_star;
                      servlen : socklen_t;
                      flags : int) : int ;

<*EXTERNAL*>
PROCEDURE gai_strerror(err : int) : char_star;

END Unetdb.
