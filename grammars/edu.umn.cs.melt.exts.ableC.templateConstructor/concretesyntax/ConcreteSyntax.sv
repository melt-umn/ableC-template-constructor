grammar edu:umn:cs:melt:exts:ableC:templateConstructor:concretesyntax;

imports silver:langutil;

imports edu:umn:cs:melt:ableC:concretesyntax;

imports edu:umn:cs:melt:ableC:abstractsyntax:env;
imports edu:umn:cs:melt:ableC:abstractsyntax:host;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction;

imports edu:umn:cs:melt:exts:ableC:templateConstructor:abstractsyntax;
imports edu:umn:cs:melt:exts:ableC:templating:concretesyntax:instKeyword;
imports edu:umn:cs:melt:exts:ableC:templating:concretesyntax:templateArguments;
imports edu:umn:cs:melt:exts:ableC:constructor:concretesyntax;

concrete productions top::PrimaryExpr_c
| 'new' id::Identifier_c '<' targs::TemplateArguments_c '>' '(' args::ArgumentExprList_c ')'
  { top.ast = newTemplateExpr(id.ast, targs.ast, foldExpr(args.ast)); }
| 'new' id::Identifier_c '<' targs::TemplateArguments_c '>' '(' ')'
  { top.ast = newTemplateExpr(id.ast, targs.ast, nilExpr()); }
| 'new' id::TypeIdName_c '<' targs::TemplateArguments_c '>' '(' args::ArgumentExprList_c ')'
  { top.ast = newTemplateExpr(id.ast, targs.ast, foldExpr(args.ast)); }
| 'new' id::TypeIdName_c '<' targs::TemplateArguments_c '>' '(' ')'
  { top.ast = newTemplateExpr(id.ast, targs.ast, nilExpr()); }
