module

public import ALF.Authors


public inductive TheoremProver where
  | Lean4
  | Lean3
  | Coq
  | Agda
  | Isabelle
  | HOL4
  | HOL_Light
deriving Repr

public def TheoremProver.slug : TheoremProver → String
  | .Lean4 => "lean4"
  | .Lean3 => "lean3"
  | .Coq => "coq"
  | .Agda => "agda"
  | .Isabelle => "isabelle"
  | .HOL4 => "hol4"
  | .HOL_Light => "hol-light"

public def TheoremProver.name : TheoremProver → String
  | .Lean4 => "Lean 4"
  | .Lean3 => "Lean 3"
  | .Coq => "Rocq"
  | .Agda => "Agda"
  | .Isabelle => "Isabelle"
  | .HOL4 => "HOL4"
  | .HOL_Light => "HOL Light"


public inductive Tag where
  | propositional_logic
  | first_order_logic
  | higher_order_logic
  | arithmetic
  | incompleteness_theorem
  | set_theory
  | modal_logic
  | provability_logic
  | tableaux
  | sequent_calculus

public def Tag.slug : Tag → String
    | .propositional_logic => "propositional-logic"
    | .first_order_logic => "first-order-logic"
    | .higher_order_logic => "higher-order-logic"
    | .arithmetic => "arithmetic"
    | .incompleteness_theorem => "incompleteness-theorem"
    | .set_theory => "set-theory"
    | .modal_logic => "modal-logic"
    | .provability_logic => "provability-logic"
    | .tableaux => "tableaux"
    | .sequent_calculus => "sequent-calculus"

public def Tag.name : Tag → String
    | .propositional_logic => "Propositional Logic"
    | .first_order_logic => "First-Order Logic"
    | .higher_order_logic => "Higher-Order Logic"
    | .arithmetic => "Arithmetic"
    | .incompleteness_theorem => "Incompleteness Theorem"
    | .set_theory => "Set Theory"
    | .modal_logic => "Modal Logic"
    | .provability_logic => "Provability Logic"
    | .tableaux => "Tableaux"
    | .sequent_calculus => "Sequent Calculus"


public structure GitHubRepositoryURL where
  user: String
  repo: String

public def GitHubRepositoryURL.slug (url : GitHubRepositoryURL) : String := s!"{url.user}/{url.repo}"

public def GitHubRepositoryURL.toUrl (url : GitHubRepositoryURL) : String := s!"https://github.com/{url.user}/{url.repo}"


public structure OtherRepositoryURL where
  url : String


public structure Repository where
  authors: List Author
  tp : List TheoremProver
  tags : List Tag
  url : GitHubRepositoryURL
  description : Option String := none

public def Repository.slug (r : Repository) : String := r.url.slug

public def Repository.title (r : Repository) : String := s!"{r.url.user}/{r.url.repo}"


public structure Publication where
  title : String
  authors : List Author
  abstract : Option String := none
  year : Nat
  tp : List TheoremProver
  tags : List Tag
  doi : Option String := none
  repositories : List Repository

public def Publication.slug (p : Publication) : String := p.title


public inductive Bibliography
  | repo : Repository → Bibliography
  | pub  : Publication → Bibliography

instance : Coe Repository  Bibliography := ⟨.repo⟩
instance : Coe Publication Bibliography := ⟨.pub⟩

public def Bibliography.slug : Bibliography → String
  | .repo r => r.slug
  | .pub  p => p.slug


namespace Bibliography

public section

open Authors

def «znssong/SetTheory» : Repository where
  url := .mk "znssong" "SetTheory"
  tp := [.Lean4]
  authors := [«znssong»]
  tags := [.set_theory]
  description := "Formalization of Kunen's inconsistency theorem."

def «staroperator/mathematical-logic-in-lean» : Repository where
  url := .mk "staroperator" "mathematical-logic-in-lean"
  tp := [.Lean4]
  authors := [«staroperator»]
  tags := [
    .arithmetic,
    .incompleteness_theorem,
    .first_order_logic,
    .higher_order_logic
  ]
  description := r#"
- Gödel's completeness theorem
- Representation theorem in Robinson arithmetic
- Categoricity of second-order arithmetic and real numbers
- Quasi-categoricity of second-order arithmetic and real numbers
"#

def «YnirPaz/PCF-Theory» : Repository where
  url := .mk "YnirPaz" "PCF-Theory"
  tp := [.Lean4]
  authors := [«YnirPaz»]
  tags := [.set_theory]
  description := "A formalization of PCF theory in Lean."

def «caitlindabrera/Sahlqvist» : Repository where
  url := .mk "caitlindabrera" "Sahlqvist"
  tp := [.Coq]
  authors := [«caitlindabrera»]
  tags := [.modal_logic]
  description := "Formalization of Sahlqvist's theorem in Coq."

def «D'Abrera Goré 2018» : Publication where
  title := "Verified synthesis of (very simple) Sahlqvist correspondents via Coq"
  tp := [.Coq]
  authors := [«caitlindabrera», «Rajeev Goré»]
  abstract := r#"
We provide an account of our formalisation of Sahlqvist's global correspondence theorem
for the very simple Sahlqvist class in the proof-assistant Coq.
We constructed our own encodings of modal, first-order and second-order fragments
and provide corresponding libraries containing numerous lemmata required for the proof of (very simple) Sahlqvist's theorem.
Moreover, we extracted from the constructive Coq proof code a verified program in Haskell
that computes the first-order correspondent given a very simple Sahlqvist modal formula.
We believe this verified program is the first of its kind in this area
and we hope that this first case study will pave the way for future formalisation work to be done in correspondence theory and beyond.
"#
  tags := [.modal_logic]
  year := 2018
  repositories := [«caitlindabrera/Sahlqvist»]

def «u5943321/Modal-Logic» : Repository where
  url := .mk "u5943321" "Modal-Logic"
  tp := [.HOL4]
  authors := [«u5943321»]
  tags := [.modal_logic]
  description := "Formalized modal logic based on _Modal Logic_ based on P. Blackburn et al."

def «Xu Norrish 2020» : Publication where
  title := "Mechanised Modal Model Theory"
  tp := [.HOL4]
  authors := [«u5943321», «Michael Norrish»]
  abstract := r#"
In this paper, we discuss the mechanisation of some fundamental propositional modal model theory.
The focus on models is novel: previous work in mechanisations of modal logic have centered on proof systems and applications in model-checking.
We have mechanised a number of fundamental results from the first two chapters of a standard textbook (Blackburn et al.).
Among others, one important result, the Van Benthem characterisation theorem, characterises the connection between modal logic and first order logic.
This latter captures the desired saturation property of ultraproduct models on countably incomplete ultrafilters.
"#
  tags := [.modal_logic]
  year := 2020
  doi := "10.1007/978-3-030-51074-9"
  repositories := [«u5943321/Modal-Logic»]

def «jrh13/hol-light/GL» : Repository where
  url := .mk "jrh13" "hol-light"
  tp := [.HOL_Light]
  authors := [«Marco Maggesi», «Cosimo Perini Brogi»]
  tags := [
    .modal_logic,
    .provability_logic
  ]
  description := "Modal completeness for the provability logic GL in HOL Light"

def «Maggesi Perini-Brogi 2021» : Publication where
  title := "A Formal Proof of Modal Completeness for Provability Logic"
  tp := [.HOL_Light]
  authors := [«Marco Maggesi», «Cosimo Perini Brogi»]
  abstract := r#"
This work presents a formalized proof of modal completeness for Godel-Lob provability logic (GL) in the HOL Light theorem prover.
We describe the code we developed, and discuss some details of our implementation.
In particular, we show how we adapted the proof in the Boolos' monograph according to the formal language and tools at hand.
The strategy we develop here overcomes the technical difficulty due to the non-compactness of GL, and simplify the implementation.
Moreover, it can be applied to other normal modal systems with minimal changes.
"#
  tags := [
    .modal_logic,
    .provability_logic
  ]
  year := 2021
  doi := "10.4230/LIPICS.ITP.2021.26"
  repositories := [«jrh13/hol-light/GL»]

def «Maggesi Perini-Brogi 2023» : Publication where
  title := "Mechanising Gödel-Löb Provability Logic in HOL Light"
  tp := [.HOL_Light]
  authors := [«Marco Maggesi», «Cosimo Perini Brogi»]
  abstract := r#"
We introduce our implementation in HOL Light of the metatheory for Godel-Lob provability logic (GL),
covering soundness and completeness w.r.t. possible world semantics and featuring a prototype of a theorem prover for GL itself.
The strategy we develop here to formalise the modal completeness proof overcomes the technical difficulty due to the non-compactness of GL
and is an adaptation-according to the formal language and tools at hand-of the proof given in George Boolos' 1995 monograph.
Our theorem prover for GL relies then on this formalisation, is implemented as a tactic of HOL Light that mimics the proof search in the labelled sequent calculus G3KGL,
and works as a decision algorithm for the provability logic:
if the algorithm positively terminates, the tactic succeeds in producing a HOL Light theorem stating that the input formula is a theorem of GL;
if the algorithm negatively terminates, the tactic extracts a model falsifying the input formula.
We discuss our code for the formal proof of modal completeness and the design of our proof search algorithm.
Furthermore, we propose some examples of the latter's interactive and automated use.
"#
  tags := [
    .modal_logic,
    .provability_logic
  ]
  year := 2023
  doi := "10.1007/s10817-023-09677-z"
  repositories := [«jrh13/hol-light/GL»]

def «FormalizedFormalLogic/Foundation» : Repository where
  url := .mk "FormalizedFormalLogic" "Foundation"
  tp := [.Lean4]
  authors := [«iehality», «SnO2WMaN»]
  tags := [
    .propositional_logic,
    .first_order_logic,
    .arithmetic,
    .incompleteness_theorem,
    .set_theory,
    .modal_logic,
    .provability_logic
  ]
  description := r#"
Lean4 formalization for overall of mathematical logic.
Including:
  - (classical | intuitionistic | intermediate) propositional logic
  - (classical | intuitionistic) first-order predicate logic / arithmetic / set theory
    - Gödel's Completeness Theorem
    - Gentzen's Haupstatz (Cut-elimination theorem)
    - Gödel's incomplteness theorem
    - Consistency of ZFC
  - modal logic
    - Gödel-McKinsey-Tarski's theorem and modal companion
  - provability logic
    - Solovay's arithmetic completeness theorem
"#

def «FormalizedFormalLogic/NonClassicalModalLogic» : Repository where
  url := .mk "FormalizedFormalLogic" "NonClassicalModalLogic"
  tp := [.Lean4]
  authors := [«SnO2WMaN»]
  tags := [.modal_logic]
  description := "Lean4 Formalization of Non-classical modal logic: (intuitionistic | constructive) modal logic."

def «ruplet/formalization-of-bounded-arithmetic» : Repository where
  url := .mk "ruplet" "formalization-of-bounded-arithmetic"
  tp := [.Lean4]
  authors := [«ruplet»]
  tags := [.arithmetic]
  description := "Formalizing bounded arithmetic and proof complexity and proof extraction."

def «flypitch/flypitch» : Repository where
  url := .mk "flypitch" "flypitch"
  tp := [.Lean3]
  authors := [«Jesse Michael Han», «Floris van Doorn»]
  tags := []
  description := "A formal proof of the independence of the continuum hypothesis."

def «Bailitis 2024» : Publication where
  title := "Löb's Theorem and Provability Predicates in Coq"
  tp := [.Coq]
  authors := [«Janis Bailitis»]
  tags := [.incompleteness_theorem]
  year := 2024
  repositories := []

def «Bailitis Kirst Forster 2025» : Publication where
  title := "Löb's Theorem and Provability Predicates in Rocq"
  tp := [.Coq]
  authors := [«Janis Bailitis», «Dominik Kirst», «Yannick Forster»]
  tags := [.incompleteness_theorem]
  year := 2025
  repositories := []

def «bbentzen/mpl» : Repository where
  url := .mk "bbentzen" "mpl"
  tp := [.Lean3]
  authors := [«bbentzen»]
  tags := [.modal_logic]
  description := "A Henkin-style completeness proof for the modal logic S5"

def «bbentzen/ipl» : Repository where
  url := .mk "bbentzen" "ipl"
  tp := [.Lean3]
  authors := [«bbentzen», «Huayu Guo», «Dongheng Chen»]
  tags := [.propositional_logic]
  description := "Verified completeness in Henkin-style for intuitionistic propositional logic"

def «Bentzen 2021» : Publication where
  title := "A Henkin-Style Completeness Proof for the Modal Logic S5"
  tp := [.Lean3]
  authors := [«bbentzen»]
  abstract := r#"
This paper presents a recent formalization of a Henkin-style completeness proof
for the propositional modal logic S5 using the Lean theorem prover.
The proof formalized is close to that of Hughes and Cresswell,
but the system, based on a different choice of axioms,
is better described as a Mendelson system augmented with axiom schemes
for K, T, S4, and B, and the necessitation rule as a rule of inference.
The language has the false and implication as the only primitive logical connectives
and necessity as the only primitive modal operator.
The full source code is available online and has been typechecked with Lean 3.4.2.
"#
  tags := [.modal_logic]
  year := 2021
  doi := "10.1007/978-3-030-89391-0_25"
  repositories := [«bbentzen/mpl»]

def «minchaowu/ModalTab» : Repository where
  url := .mk "minchaowu" "ModalTab"
  tp := [.Lean3]
  authors := [«minchaowu»]
  tags := [
    .modal_logic,
    .tableaux
  ]
  description := "Verified decision procedures for modal logics"

def «Wu Goré 2019» : Publication where
  title := "Verified Decision Procedures for Modal Logics"
  tp := [.Lean3]
  authors := [«minchaowu», «Rajeev Goré»]
  tags := [
    .modal_logic,
    .tableaux
  ]
  year := 2019
  doi := "10.4230/LIPICS.ITP.2019.31"
  repositories := [«minchaowu/ModalTab»]

def «ianshil/CE_GLS» : Repository where
  url := .mk "ianshil" "CE_GLS"
  tp := [.Coq]
  authors := [«ianshil»]
  tags := [
    .modal_logic,
    .provability_logic,
    .sequent_calculus
  ]
  description := "Cut-elimination via backward proof-search for GLS"

def «Goré Ramanayake Shillito 2021» : Publication where
  title := "Cut-Elimination for Provability Logic by Terminating Proof-Search: Formalised and Deconstructed Using Coq"
  tp := [.Coq]
  authors := [«Rajeev Goré», «Revantha Ramanayake», «ianshil»]
  abstract := r#"
Recently, Brighton gave another cut-admissibility proof for the standard set-based sequent calculus GLS for modal provability logic GL.
One of the two induction measures that Brighton uses is novel: the maximum height of regress trees in an auxiliary calculus called RGL.
Tautology elimination is established rather than direct cut-admissibility, and at some points the input derivation appears to be ignored in favour of a derivation obtained by backward proof-search.
By formalising the GLS calculus and the proofs in Coq, we show that:
(1) the use of the novel measure is problematic under the usual interpretation of the Gentzen comma as set union, and a multiset-based sequent calculus provides a more natural formulation;
(2) the detour through tautology elimination is unnecessary; and
(3) we can use the same induction argument without regress trees to obtain a direct proof of cut-admissibility that is faithful to the input derivation.
"#
  tags := [
    .modal_logic,
    .provability_logic,
    .sequent_calculus
  ]
  year := 2021
  doi := "10.1007/978-3-030-86059-2_18"
  repositories := [«ianshil/CE_GLS»]

end

end Bibliography

open Bibliography in

public def bibliography : List Bibliography := ([
  «Bailitis 2024»,
  «Bailitis Kirst Forster 2025»,
  «bbentzen/ipl»,
  «bbentzen/mpl»,
  «Bentzen 2021»,
  «caitlindabrera/Sahlqvist»,
  «D'Abrera Goré 2018»,
  «flypitch/flypitch»,
  «FormalizedFormalLogic/Foundation»,
  «FormalizedFormalLogic/NonClassicalModalLogic»,
  «Goré Ramanayake Shillito 2021»,
  «ianshil/CE_GLS»,
  «jrh13/hol-light/GL»,
  «Maggesi Perini-Brogi 2021»,
  «Maggesi Perini-Brogi 2023»,
  «minchaowu/ModalTab»,
  «ruplet/formalization-of-bounded-arithmetic»,
  «staroperator/mathematical-logic-in-lean»,
  «u5943321/Modal-Logic»,
  «Wu Goré 2019»,
  «Xu Norrish 2020»,
  «YnirPaz/PCF-Theory»,
  «znssong/SetTheory»,
  ] : List Bibliography)
  |>.mergeSort (fun a b => String.le a.slug.toLower b.slug.toLower)
