(* open Ppxlib *)

type plugin_args = (Ppxlib.longident * Ppxlib.expression) list

type 'a decl_info = string list * string * 'a MidiAst.typ

module Make(AstHelpers : GTHELPERS_sig.S) = struct
open AstHelpers

class virtual ['a] t = object
  method virtual plugin_name : string

  method virtual default_inh : loc:loc -> Ppxlib.type_declaration -> type_arg

  (* synthethized attribute for whole type declaration *)
  method virtual default_syn  : loc:loc -> Ppxlib.type_declaration -> type_arg
  method virtual syn_of_param : loc:loc -> string -> type_arg
  method virtual inh_of_param : Ppxlib.type_declaration -> string -> type_arg

  (* The parameters that the plugin class will have in its definition.
   * Add ['extra] manually if needed *)
  method virtual plugin_class_params: Ppxlib.type_declaration ->  type_arg list

  (* Arguments of inherit class field that will be generated using the types
   * applied in the RHS of type definition *)
  method virtual prepare_inherit_typ_params_for_alias: loc:loc ->
    Ppxlib.type_declaration -> Ppxlib.core_type list -> Typ.t list

  method virtual extra_class_sig_members: Ppxlib.type_declaration -> Ctf.t list
  method virtual extra_class_str_members: Ppxlib.type_declaration -> Cf.t list


  (* These methods will be implemented in plugin.ml *)
  method virtual do_single_sig :
    loc:loc ->
    is_rec:bool ->
    Ppxlib.type_declaration ->
    Sig.t list
  method virtual do_single :
    loc:loc ->
    is_rec:bool ->
    Ppxlib.type_declaration ->
    Str.t list

  method virtual make_trans_function_name: Ppxlib.type_declaration -> string
  method virtual make_trans_function_typ : loc:loc -> Ppxlib.type_declaration -> Typ.t

  method virtual do_mutals :
    loc:loc ->
    is_rec:bool ->
    Ppxlib.type_declaration list -> Str.t list
end

end
