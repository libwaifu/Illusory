(* ::Package:: *)
(* ::Title:: *)
(*Example(样板包)*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(*Establish from GalAster's template*)
(**)
(*Author: 我是作者*)
(*Creation Date: 我是创建日期*)
(*Copyright:CC4.0 BY+NA+NC*)
(* ::Program:: *)
(*该项许可协议规定*)
(*1.只要您注明该作作者的姓名并在以该作的作品为基础创作的新作品上适用同一类型的许可协议*)
(*  就可基于非商业目的对我的作品重新编排、节选或者以我的作品为基础进行创作*)
(*2.基于我的作品创作的所有新作品都要适用同一类型的许可协议*)
(*3.任何以我的原作为基础创作的演绎作品自然同样都不得进行商业性使用*)
(* ::Text:: *)
(*这里应该填这个函数包的介绍*)
(* ::Section:: *)
(*函数说明*)
BeginPackage["TextArt`"];
TextifyChars::usage = "";
Textify::usage = "这里应该填这个函数的说明,如果要换行用\"\r\"\r就像这样";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
TextArt::usage = "程序包的说明,这里抄一遍";
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
(* ::Subsubsection:: *)
(*Textify*)
TextifyRasterizeMemory[expr__] := TextifyRasterizeMemory[expr] = Rasterize[expr];
TextifyCleanMemory[] := With[
	{},
	Clear[TextifyRasterizeMemory];
	TextifyRasterizeMemory[expr_] := TextifyRasterizeMemory[expr] = Rasterize[expr];
];
Options[TextifyChars] = {FontFamily -> "Source Sans Pro", FontSize -> 12, RasterSize -> 50, ClearAll -> False};
TextifyChars[lang_String, opt___] := Module[
	{chars = Alphabet[lang]},
	If[ListQ@chars, Textify[chars, opt], Textify[Alphabet[], opt]]
];
TextifyChars[chars_List, OptionsPattern[]] := Module[
	{fnt, gridWidth, gridHeight, light},
	If[ClearAll, TextifyCleanMemory[]];
	(*Chars used in output that are not part of the alphabets*)
	fnt = Style[#, FontFamily -> OptionValue[FontFamily], FontSize -> OptionValue[FontSize]]&;
	(*calculates the dimensions of characters*)
	{gridWidth , gridHeight} = Max /@ Transpose[ImageDimensions@TextifyRasterizeMemory[fnt@#] & /@ chars];
	(*creates a table of the brightness levels of chars*)
	light = ImageMeasurements[ColorConvert[TextifyRasterizeMemory[Pane[fnt@#, {gridWidth, gridHeight}, Alignment -> Center], ImageSize -> OptionValue[RasterSize]], "Grayscale"], "Mean"]& /@ chars;
	<|
		"CharsSet" -> chars,
		"CharsLight" -> light,
		"GridWidth" -> gridWidth,
		"GridHeight" -> gridHeight,
		"Font" -> OptionValue[FontFamily],
		"FontSize" -> OptionValue[FontSize]
	|>
];
(*参考实现*)
(*http://community.wolfram.com/groups/-/m/t/1381000*)
Options[Textify] = {ColorNegate -> False, Colorize -> True, Text -> False, Magnify -> 1};
Textify[pics_List, opt__] := Map[Textify[#, opt]&, pics];
Textify[img_Image, chars_, OptionsPattern[]] := Module[
	{trueCharWidth, trueCharHeight, charWidth, charHeight, neg, pic, avg, diffs, best, charGrid},
	charWidth = Round[OptionValue[Magnify](trueCharWidth = chars["GridWidth"])];
	charHeight = Round[OptionValue[Magnify](trueCharHeight = chars["GridHeight"])];
	neg = If[OptionValue[ColorNegate], ColorNegate[img], img];
	(*creates a partitioned black and white, bleached image*)
	pic = ImagePartition[ImageApply[# + Min[chars["CharsLight"]](1 - #)&, {ColorConvert[neg, "Grayscale"]}], {charWidth, charHeight}];
	(*calculates the average brightness for each piece of the image*)
	avg = Map[ImageMeasurements[#, "Mean"]&, pic, {2}];
	(*names a function that calculates the differences between a piece of the image and all chars*)
	diffs[column_, row_] := Table[chars["CharsLight"][[a]] - avg[[row, column]], {a, 1, Length[chars["CharsSet"]]}]^2;
	(*picks the character whose difference is the smallest*)
	best[x_, y_] := chars["CharsSet"][[Position[diffs[x, y], Min[diffs[x, y]]][[1, 1]]]];
	(*creates a column of rows of colored best fitting letters, colored or black*)
	charGrid = If[
		OptionValue[Colorize],
		TableForm[Table[Style[best[x, y], FontColor -> RGBColor[ImageMeasurements[ImagePartition[neg, {charWidth, charHeight}][[y, x]], "Mean"]]], {y, Length@pic}, {x, Length@First[pic]}], TableSpacing -> {0, 0}],
		TableForm[Table[Style[best[x, y], FontColor -> Black], {y, Length@pic}, {x, Length@First[pic]}], TableSpacing -> {0, 0}]
	];
	If[OptionValue[Text], Return[charGrid]];
	(*rasterize the column of strings*)
	If[
		OptionValue[ColorNegate],
		ColorNegate[Rasterize[Style[TableForm[Map[Pane[#, {trueCharWidth, trueCharHeight}, Alignment -> Center]&, charGrid, {3}], TableSpacing -> {0, 1}], FontFamily -> chars["Font"], FontSize -> chars["FontSize"]]]],
		Rasterize[Style[TableForm[Map[Pane[#, {trueCharWidth, trueCharHeight}, Alignment -> Center]&, charGrid, {3}], TableSpacing -> {0, 1}], FontFamily -> chars["Font"], FontSize -> chars["FontSize"]]]
	]
];





(* ::Subsubsection:: *)
(*功能块 2*)
ExampleFunction[2] = "我就是个示例函数,什么功能都没有";



(* ::Subsection::Closed:: *)
(*附加设置*)
End[] ;
SetAttributes[
	{Textify, TextifyChars},
	{Protected, ReadProtected}
];
EndPackage[];
