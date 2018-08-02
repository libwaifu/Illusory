(* ::Package:: *)
(* ::Title:: *)
(*LineArt(线条艺术)*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(*Establish from GalAster's template*)
(**)
(*Author: GalAster*)
(*Creation Date: 2017.11.11*)
(*Copyright:CC4.0 BY+NA+NC*)
(**)
(*该软件包遵从CC协议:署名、非商业性使用、相同方式共享*)
(**)
(*这里应该填这个函数的介绍*)
(* ::Section:: *)
(*函数说明*)
BeginPackage["PolyArt`"];
LineWebPainting::usage = "这里应该填这个函数的说明,如果要换行用\"\r\"\r就像这样";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
LineArt::usage = "程序包的说明,这里抄一遍";
Begin["`Private`"];
Version$PolyArt = "V1.0";
Update$PolyArt = "2016-11-11";
(* ::Subsection::Closed:: *)
(*主体代码*)
(* ::Subsubsection:: *)
(*多边形画风*)
TriPainting[i_Image, n_ : 1000] := Block[
	{x, y, pt, pts},
	{x, y} = ImageDimensions[i];
	pt = Reverse /@ RandomChoice[Flatten@ImageData@GradientFilter[i, 2] -> Tuples@{Range[y, 1, -1], Range[x]}, n];
	pts = Join[pt, {{0, 0}, {x, 0}, {x, y}, {0, y}}];
	Graphics[With[
		{col = RGBColor@ImageValue[i, Mean @@ #]},
		{EdgeForm@col, col, #}]& /@ MeshPrimitives[DelaunayMesh@pts, 2]
	]
];
PloyPainting[img_, n_ : 1000] := Block[
	{x, y, gr, pt},
	{x, y} = ImageDimensions[img];
	gr = ListDensityPlot[
		Transpose@{RandomReal[x, n], RandomReal[y, n], RandomReal[1, n]},
		InterpolationOrder -> 0, Frame -> False, Mesh -> All,
		AspectRatio -> Automatic
	];
	pt = Polygon[#[[1]]]& /@ Cases[Normal@gr, _Polygon, Infinity];
	Graphics[With[
		{col = RGBColor@ImageValue[img, Mean @@ #]},
		{EdgeForm@col, col, #}]& /@ pt, AspectRatio -> ImageAspectRatio[img]
	]
];
(*PloyPainting[图片,{精细度,畸变度,网格}]*)
PloyPainting[img_, {n_, m_ : 1, mesh_ : None}] := Block[
	{im, pts, dat},
	im = ImageAdjust[ImageResize[img, n]];
	dat = Apply[RGBColor, Flatten[Transpose[Reverse[ImageData[im]]], 1], {1}];
	pts = Flatten[Table[{x, y} + RandomReal[m{-1, 1}], {x, 1, n}, {y, 1, n}], 1];
	ListDensityPlot[
		Flatten /@ Transpose[{pts, Range[1, n^2]}],
		InterpolationOrder -> 0, Mesh -> mesh,
		MeshStyle -> Thickness[Small], Frame -> False,
		ColorFunction -> dat
	]
];
Dither[pts_, dith_] := pts + .25 dith RandomReal[{-1, 1}, {Length@pts, 2}];
GlassPainting[img_, m_ : 1000, n_ : 5] := Block[
	{bounds, num, seeds, vrnMesh, polygons},
	bounds = Transpose@{{0, 0}, ImageDimensions@img};
	num = ImageValuePositions[EdgeDetect[img], White];
	seeds = RandomSample[num, Min[m, Length@num]];
	vrnMesh = VoronoiMesh[Dither[seeds, .01], bounds];
	polygons = Table[{
		EdgeForm[Black],
		FaceForm[RGBColor[PixelValue[img, Mean @@ pol]]], pol}, {pol,
		MeshPrimitives[Nest[VoronoiMesh[Mean @@@ MeshPrimitives[#, 2], bounds]&, vrnMesh, n], 2]
	}];
	Graphics@polygons
];
PointPainting[img_, n_ : 10000] := Block[
	{etf, sdf, map, mapdata, data, w, h, ch, spots},
	etf = EntropyFilter[img, 12] // ImageAdjust;
	sdf = ColorConvert[StandardDeviationFilter[img, 5], "GrayScale"] // ImageAdjust;
	map = ImageAdd[sdf, etf] // ImageAdjust;
	mapdata = ImageData[map];
	data = ImageData[img];
	{w, h} = ImageDimensions[img];
	ch = RandomChoice[(Flatten[mapdata] + 0.1)^1.7 -> Join @@ Table[{i, j}, {i, h}, {j, w}], n];
	spots = Reverse@SortBy[{data[[#1, #2]], {#2, -#1}, 15(1.1 - mapdata[[#1, #2]])^1.8}& @@@ ch, Last];
	Graphics[{RGBColor[#1], Disk[#2, #3]}& @@@ spots, Background -> GrayLevel[0.75], PlotRange -> {{1, w}, {1, -h}}]
];
TranslateObject[p_, {x_, y_}] := Map[{x, y} + #&, p, {2}];
HouseHexPolygon[s_, 0] := Polygon[s * {{1 / 2, -1}, {3 / 2, 0}, {3 / 2, 1}, {-1 / 2, 1}, {-3 / 2, 0}, {-3 / 2, -1}}];
HouseHexPolygon[s_, 1] := Polygon[s * {{1, 1 / 2}, {0, 3 / 2}, {-1, 3 / 2}, {-1, -1 / 2}, {0, -3 / 2}, {1, -3 / 2}}];
HouseHexGrid[s_, imax_, jmax_] := Block[
	{imod, jmod, k, m},
	Flatten[Table[imod = Mod[2i, 5];
	jmod = Mod[2i + 3, 5];
	k = Range[0, Floor[(jmax - imod) / 5]];
	m = Range[0, Floor[(jmax - jmod) / 5]];
	{
		Table[TranslateObject[HouseHexPolygon[s, 0], s * {i + 1 / 2, j}], {j, jmod + 1 / 2 + 5 * m}],
		Table[TranslateObject[HouseHexPolygon[s, 1], s * {i, j}], {j, imod + 5 * k}]
	}, {i, 0, imax}], 2]
];
HouseHexGridPerturbed[s_, h_, v_, r_] := Block[
	{poly = Map[Round[#, 10.^-10]&, HouseHexGrid[N[s], h, v], {2}], pts, len, rules},
	pts = DeleteDuplicates[Flatten[poly[[All, 1]], 1]];
	len = Length[pts];
	rules = Dispatch[Thread[pts -> Range[len]]];
	GraphicsComplex[pts + RandomReal[{-r, r}, {len, 2}], RandomSample[poly] /. rules]
];
(*HexPainting[图像,粒度,纹理]*)
HexPainting[image_, s_, t_ : 0] := Block[
	{d, dim, g, centroids, colours, rr, gg, bb, greys},
	d = Reverse[ImageData[image]];dim = Dimensions[d];
	g = HouseHexGridPerturbed[s, Floor[dim[[2]] / s - 3], Floor[dim[[1]] / s - 3], 0];
	centroids = Apply[Mean[g[[1, #]]]&, g[[2]], 1];
	colours = Apply[RGBColor, Extract[d, Map[Reverse, Round[centroids + s / 2]]], 1];
	greys = colours /. RGBColor[rr_, gg_, bb_] -> 0.299rr + 0.587gg + 0.114bb;
	g[[2]] = Transpose[{colours, g[[2]]}][[Ordering[greys]]];
	If[t == 1,
		Graphics[{EdgeForm[{Thickness[0.0003], Black}], GraphicsComplex[g[[1]], g[[2]]]}],
		Graphics[{GraphicsComplex[g[[1]], g[[2]]]}]
	]
];


(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{ },
	{Protected, ReadProtected}
];
EndPackage[]
