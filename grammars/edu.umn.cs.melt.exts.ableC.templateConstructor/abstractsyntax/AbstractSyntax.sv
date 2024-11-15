grammar edu:umn:cs:melt:exts:ableC:templateConstructor:abstractsyntax;

imports silver:langutil;
imports silver:langutil:pp;
imports silver:rewrite as s;

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
  top.pp = pp"bindTemplateConstructor<${ppImplode(pp", ", targs.pps)}>(${ppImplode(pp", ", args.pps)}) in ${result}";
  targs.substEnv = s:fail();
  -- This should not actually matter, for computing argDecls.
  -- TODO: Is there a reason to properly supply the expected template arguments here?
  targs.paramKinds = [];
  forwards to letExpr(
    -- TODO: There is a missing equation in the prolog extension if the order is reversed here:
    -- consDecl(bindExprsDecls(freshName("a"), @args), @targs.argDecls),
    appendDecls(@targs.argDecls, consDecl(bindExprsDecls(freshName("a"), @args), nilDecl())),
    @result);
}

production callTemplateConstructor implements TemplateConstructor
top::Expr ::= targs::TemplateArgNames args::Exprs fn::Name
{
  forwards to templateDirectCallExpr(@fn, @targs, @args);
}
