module

public structure Author where
  handle: String -- unique id for this namespace use handle or realname.
  realname: Option String := none
  github: Option String := none

namespace Authors

public def «SnO2WMaN» : Author where
  handle := "SnO2WMaN"
  realname := "Mashu Noguchi"
  github := "sno2wman"

public def «iehality» : Author where
  handle := "Palalansoukî"
  realname := "Shogo Saito"
  github := "iehality"

public def «staroperator» : Author where
  handle := "staroperator"
  realname := "Dexin Zhang"
  github := "staroperator"

public def «caitlindabrera» : Author where
  handle := "caitlindabrera"
  realname := "Caitlin D'Abrera"
  github := "caitlindabrera"

public def «minchaowu» : Author where
  handle := "minchaowu"
  realname := "Minchao Wu"
  github := "minchaowu"

public def «Rajeev Goré» : Author where
  handle := "Rajeev Goré"
  realname := "Rajeev Goré"

public def «ianshil» : Author where
  handle := "ianshil"
  realname := "Ian Shillito"
  github := "ianshil"

public def «Revantha Ramanayake» : Author where
  handle := "Revantha Ramanayake"
  realname := "Revantha Ramanayake" 

end Authors
