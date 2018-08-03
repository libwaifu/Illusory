TextifyChars::usage = "";
Textify::usage = "这里应该填这个函数的说明,如果要换行用\"\r\"\r就像这样";
TextArt::usage = "程序包的说明,这里抄一遍";
Begin["`TextArt`"];
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
	fnt = Style[#, FontFamily -> OptionValue[FontFamily], FontSize -> OptionValue[FontSize]]&;
	{gridWidth , gridHeight} = Max /@ Transpose[ImageDimensions@TextifyRasterizeMemory[fnt@#] & /@ chars];
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
Options[Textify] = {ColorNegate -> False, Colorize -> True, Text -> False, Magnify -> 1};
Textify[pics_List, opt__] := Map[Textify[#, opt]&, pics];
Textify[img_Image, chars_, OptionsPattern[]] := Module[
	{trueCharWidth, trueCharHeight, charWidth, charHeight, neg, pic, avg, diffs, best, charGrid},
	charWidth = Round[OptionValue[Magnify](trueCharWidth = chars["GridWidth"])];
	charHeight = Round[OptionValue[Magnify](trueCharHeight = chars["GridHeight"])];
	neg = If[OptionValue[ColorNegate], ColorNegate[img], img];
	pic = ImagePartition[ImageApply[# + Min[chars["CharsLight"]](1 - #)&, {ColorConvert[neg, "Grayscale"]}], {charWidth, charHeight}];
	avg = Map[ImageMeasurements[#, "Mean"]&, pic, {2}];
	diffs[column_, row_] := Table[chars["CharsLight"][[a]] - avg[[row, column]], {a, 1, Length[chars["CharsSet"]]}]^2;
	best[x_, y_] := chars["CharsSet"][[Position[diffs[x, y], Min[diffs[x, y]]][[1, 1]]]];
	charGrid = If[
		OptionValue[Colorize],
		TableForm[Table[Style[best[x, y], FontColor -> RGBColor[ImageMeasurements[ImagePartition[neg, {charWidth, charHeight}][[y, x]], "Mean"]]], {y, Length@pic}, {x, Length@First[pic]}], TableSpacing -> {0, 0}],
		TableForm[Table[Style[best[x, y], FontColor -> Black], {y, Length@pic}, {x, Length@First[pic]}], TableSpacing -> {0, 0}]
	];
	If[OptionValue[Text], Return[charGrid]];
	If[
		OptionValue[ColorNegate],
		ColorNegate[Rasterize[Style[TableForm[Map[Pane[#, {trueCharWidth, trueCharHeight}, Alignment -> Center]&, charGrid, {3}], TableSpacing -> {0, 1}], FontFamily -> chars["Font"], FontSize -> chars["FontSize"]]]],
		Rasterize[Style[TableForm[Map[Pane[#, {trueCharWidth, trueCharHeight}, Alignment -> Center]&, charGrid, {3}], TableSpacing -> {0, 1}], FontFamily -> chars["Font"], FontSize -> chars["FontSize"]]]
	]
];
ExampleFunction[2] = "我就是个示例函数,什么功能都没有";
End[] ;
SetAttributes[
	{Textify, TextifyChars},
	{Protected, ReadProtected}
];
EndPackage[];