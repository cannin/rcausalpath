//cd /Users/user/default/workspace/zeptosensPkg/zeptosensPkg/inst/java/; groovysh -cp ./causalpath.jar

import org.panda.causalpath.run.CausalityAnalysisSingleMethodInterface

generateCausalityGraph(
"/Users/user/default/workspace/zeptosensPkg/zeptosensPkg/inst/targetScoreData/antibodyMap.txt",
"AntibodyLabel",
"Gene_Symbol",
"Sites",
"Effect",
"/var/folders/px/xmt4dh652qd8q02hgb6144dh0000gn/T//RtmpzYXVUb/file3d361dc42464",
"change",
0.001,
"compatible",
true,
0,
0,
false,
"/Users/user/default/workspace/zeptosensPkg/zeptosensPkg/inst/chibeExample/other",
"/Users/user/.paxtoolsRCache/"
);

/*
String platformFile,
String idColumn,
String symbolsColumn,
String sitesColumn,
String effectColumn,
String valuesFile,
String valueColumn,
double valueThreshold,
String graphType,
boolean siteMatchStrict,
int siteMatchProximityThreshold,
int siteEffectProximityThreshold,
boolean geneCentric,
String outputFilePrefix,
String customNetworkDirectory
*/
