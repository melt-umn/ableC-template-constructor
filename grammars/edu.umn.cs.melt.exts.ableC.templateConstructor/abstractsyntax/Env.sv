grammar edu:umn:cs:melt:exts:ableC:templateConstructor:abstractsyntax;

synthesized attribute templateConstructors::Scopes<TemplateConstructor> occurs on Env;
synthesized attribute templateConstructorContribs::Contribs<TemplateConstructor> occurs on Defs, Def;

aspect production emptyEnv
top::Env ::=
{
  production attribute globalTemplateConstructors::[(String, TemplateConstructor)] with ++;
  globalTemplateConstructors := [];

  top.templateConstructors = addScope(globalTemplateConstructors, emptyScope());
}
aspect production addDefsEnv
top::Env ::= d::Defs  e::Env
{
  top.templateConstructors = addGlobalScope(gd.templateConstructorContribs, addScope(d.templateConstructorContribs, e.templateConstructors));
}
aspect production openScopeEnv
top::Env ::= e::Env
{
  top.templateConstructors = openScope(e.templateConstructors);
}
aspect production globalEnv
top::Env ::= e::Env
{
  top.templateConstructors = globalScope(e.templateConstructors);
}
aspect production nonGlobalEnv
top::Env ::= e::Env
{
  top.templateConstructors = nonGlobalScope(e.templateConstructors);
}
aspect production functionEnv
top::Env ::= e::Env
{
  top.templateConstructors = functionScope(e.templateConstructors);
}

aspect production nilDefs
top::Defs ::=
{
  top.templateConstructorContribs = [];
}
aspect production consDefs
top::Defs ::= h::Def  t::Defs
{
  top.templateConstructorContribs = h.templateConstructorContribs ++ t.templateConstructorContribs;
}

aspect default production
top::Def ::=
{
  top.templateConstructorContribs = [];
}

production templateConstructorDef
top::Def ::= s::String  c::TemplateConstructor
{
  top.templateConstructorContribs = [(s, c)];
}

fun lookupTemplateConstructor [TemplateConstructor] ::= n::String e::Env =
  lookupScope(n, e.templateConstructors);
