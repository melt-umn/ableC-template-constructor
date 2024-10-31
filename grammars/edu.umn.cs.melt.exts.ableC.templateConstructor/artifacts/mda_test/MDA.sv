grammar edu:umn:cs:melt:exts:ableC:templateConstructor:artifacts:mda_test;

{- This Silver specification does not generate a useful working 
   compiler, it only serves as a grammar for running the modular
   determinism analysis.
 -}

import edu:umn:cs:melt:ableC:host;

copper_mda testConcreteSyntax(ablecParser) {
  edu:umn:cs:melt:exts:ableC:constructor:concretesyntax;
  edu:umn:cs:melt:exts:ableC:templating:concretesyntax;
  edu:umn:cs:melt:exts:ableC:templateConstructor:concretesyntax;
}
