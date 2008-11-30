module SPL.Compiler (compile, remove_cdebug, res) where

import SPL.Types
import SPL.Parser hiding (P (..), res)
import SPL.Code hiding (res)

comp (Sn x i) =
	CDebug i $ CNum x
comp (Sb x i) =
	CDebug i $ CBool x
comp (Sstr s i) =
	CDebug i $ CStr s
comp (Ss s i) =
	CDebug i $ CVal s
comp (Scall f (SynK a) i) =
	CDebug i $ CL (comp f) (K (map comp a))
comp (Scall f (SynS a) i) =
	CDebug i $ CL (comp f) (S a)
comp (Scall f (SynM a) i) =
	CDebug i $ CL (comp f) R
comp (Scall f SynL i) =
	CDebug i $ CL (comp f) L

compile = comp


r_d (CDebug _ c) = r_d c
r_d (CL c (K p)) =
	CL (r_d c) (K (map r_d p))
r_d (CL c (S a)) =
	CL (r_d c) (S a)
r_d (CL c R) =
	CL (r_d c) R
r_d (CL c L) =
	CL (r_d c) L
r_d o = o

remove_cdebug = r_d

{-tests = [
	(Sn 2, CNum 2)
	,(Sn 12, CNum 12)
	,(Ss "sum", CVal "sum")
	,(Scall (Ss "sum") (SynK [Ss "one"]), CL (CVal "sum") (K [CVal "one"]))
	,(Scall (Ss "sum") (SynK [Sn 11, Sn 22]), CL (CVal "sum") (K [CNum 11,CNum 22]))
	,(Scall (Ss "sum") (SynK [Sn 11, Scall (Ss "min") (SynK [Sn 22, Sn 33])]), CL (CVal "sum") (K [CNum 11,CL (CVal "min") (K [CNum 22,CNum 33])]))
	,(Scall (Ss "incr") (SynK [Scall (Ss "min") (SynK [Sn 22, Sn 33])]), CL (CVal "incr") (K [CL (CVal "min") (K [CNum 22,CNum 33])]))
	,(Scall (Scall (Ss "sum") (SynK [Sn 1])) (SynS ["a", "b"]), CL (CL (CVal "sum") (K [CNum 1])) (S ["a","b"]))
	,(Scall (Scall (Scall (Scall (Ss "sum") (SynK [Sn 1,Scall (Ss "min") (SynK [Sn 22,Ss "z"])])) (SynS ["a","b"])) (SynK [Scall (Ss "min") (SynK [Ss "z"])])) (SynS ["x","y"]), CL (CL (CL (CL (CVal "sum") (K [CNum 1,CL (CVal "min") (K [CNum 22,CVal "z"])])) (S ["a","b"])) (K [CL (CVal "min") (K [CVal "z"])])) (S ["x","y"]))
	,(Scall (Scall (Scall (Ss "sum") (SynK [Ss "a", Ss "b"])) (SynS ["a", "b"])) (SynK [Sn 12, Sn 22]), CL (CL (CL (CVal "sum") (K [CVal "a",CVal "b"])) (S ["a","b"])) (K [CNum 12,CNum 22]))
	,(Scall ((Scall (Scall (Scall (Ss "if") (SynK [Scall (Ss "less") (SynK [Ss "_",Sn 5]),Scall (Ss "sum") (SynK [Ss "_",Scall (Ss "_r") (SynK [Scall (Ss "sum") (SynK [Ss "_",Sn 1])])]),Ss "_"])) (SynS ["_"]))) (SynM [MarkR])) (SynK [Sn 1]), CNum 1)
--	,((Scall (Scall (Scall (Ss "if") (SynK [Scall (Ss "less") (SynK [Ss "_",Sn 5]),Scall (Ss "sum") (SynK [Ss "_",Scall (Ss "_r") (SynK [Scall (Ss "sum") (SynK [Ss "_",Sn 1])])]),Ss "_"])) (SynS ["_"]))) (SynM [MarkR]), CNum 1)
--	,((Scall (Scall (Scall (Ss "_") (SynK [Scall (Ss "list") (SynK [Sn 1,Sn 2,Sn 3,Sn 4,Sn 5])])) (SynS ["_"])) (SynK [Scall (Scall (Scall (Ss "if") (SynK [Scall (Ss "is_empty") (SynK [Ss "_"]),Ss "list",Scall (Scall (Ss "join") (SynK [Scall (Ss "_r") (SynK [Scall (Ss "filter") (SynK [Scall (Ss "le") (SynK [Ss "h"]),Ss "_"])]),Ss "h",Scall (Ss "join") (SynK [Scall (Ss "list") (SynK [Ss "h"]),Scall (Ss "_r") (SynK [Scall (Ss "filter") (SynK [Scall (Ss "more") (SynK [Ss "h"]),Ss "_"])])])])) (SynS ["h","t"]),Scall (Ss "head") (SynK [Ss "_"]),Scall (Ss "tail") (SynK [Ss "_"])])) (SynS ["_"])) (SynM [MarkR])])))
	]

mk_test (s, e) =
	(case compile s of
		P s2|e == s2 -> "ok - "
		P s2 -> "ce:\n"++"  cur: "++(show s2)++"\n  exp: "++(show e)
		N -> "ce - ") ++ "\n test:" ++ show s
-}
res = "res"


