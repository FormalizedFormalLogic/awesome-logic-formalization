module

public import ALF.Authors


public inductive TheoremProver where
  | Lean4
  | Lean3
  | Coq
  | Agda
  | Isabelle
  | HOL
  | HOL_Light
deriving Repr

public def TheoremProver.slug : TheoremProver → String
  | .Lean4 => "lean4"
  | .Lean3 => "lean3"
  | .Coq => "coq"
  | .Agda => "agda"
  | .Isabelle => "isabelle"
  | .HOL => "hol"
  | .HOL_Light => "hol_light"

public def TheoremProver.name : TheoremProver → String
  | .Lean4 => "Lean 4"
  | .Lean3 => "Lean 3"
  | .Coq => "Rocq"
  | .Agda => "Agda"
  | .Isabelle => "Isabelle"
  | .HOL => "HOL"
  | .HOL_Light => "HOL-light"


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

public def GitHubRepositoryURL.toUrl (url : GitHubRepositoryURL) : String := s!"https://github.com/{url.user}/{url.repo}"


public structure OtherRepositoryURL where
  url : String


public structure Repository where
  authors: List Author
  tp : List TheoremProver
  tags : List Tag
  url : GitHubRepositoryURL
  description : Option String := none

public def Repository.slug (r : Repository) : String := r.url.repo

public def Repository.title (r : Repository) : String := s!"{r.url.user}/{r.url.repo}"


public structure Publication where
  title : String
  authors : List Author
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

namespace Bibliography

public section

open Authors

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
  description := "
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
    "

def «minchaowu/ModalTab» : Repository where
  url := .mk "minchaowu" "ModalTab"
  tp := [.Lean3]
  authors := [«minchaowu»]
  tags := [
    .modal_logic,
    .tableaux
  ]
  description := "Lean4 formalization for modal logic tableau method."

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
  tags := [
    .modal_logic,
    .provability_logic,
    .sequent_calculus
  ]
  year := 2021
  doi := "10.4230/LIPICS.ITP.2021.17"
  repositories := [«ianshil/CE_GLS»]

end

end Bibliography

open Bibliography in

public def bibliography : List Bibliography := [
  «FormalizedFormalLogic/Foundation»,
  «minchaowu/ModalTab»,
  «Wu Goré 2019»,
  «ianshil/CE_GLS»,
  «Goré Ramanayake Shillito 2021»
]
