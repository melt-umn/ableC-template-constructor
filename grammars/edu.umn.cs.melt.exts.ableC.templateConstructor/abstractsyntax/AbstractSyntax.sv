grammar edu:umn:cs:melt:exts:ableC:templateConstructor:abstractsyntax;

imports silver:langutil;
imports silver:langutil:pp;

imports edu:umn:cs:melt:ableC:abstractsyntax:env;
imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;

imports edu:umn:cs:melt:exts:ableC:templating:abstractsyntax;

production newTemplateExpr
top::Expr ::= id::Name targs::TemplateArgNames args::Exprs
{
  top.pp = pp"new ${id.pp}<${ppImplode(pp", ", targs.pps)}>(${ppImplode(pp", ", args.pps)})";
  id.env = top.env;

  local fwrdProd::TemplateConstructor =
    case lookupTemplateConstructor(id.name, top.env) of
    | [] -> bindTemplateConstructor(errorExpr([errFromOrigin(id, s"Undefined template constructor ${id.name}")]))
    | [c] -> c
    | _ :: _ -> bindTemplateConstructor(errorExpr([errFromOrigin(id, s"Ambiguous template constructor ${id.name}")]))
    end;
  
  forwards to fwrdProd(@targs, @args);
}

dispatch TemplateConstructor = Expr ::= targs::TemplateArgNames args::Exprs;

production bindTemplateConstructor implements TemplateConstructor
top::Expr ::= targs::TemplateArgNames args::Exprs result::Expr
{
  forwards to letExpr(
    consDecl(bindExprsDecls(freshName("a"), @args), @targs.argDecls),
    @result);
}

production callTemplateConstructor implements TemplateConstructor
top::Expr ::= targs::TemplateArgNames args::Exprs fn::Name
{
  forwards to templateDirectCallExpr(@fn, @targs, @args);
}
