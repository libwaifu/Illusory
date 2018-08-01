(* ::Package:: *)
(* ::Title:: *)
(*Stereogram 模块*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(*Establish from GalAster's template*)
(**)
(*Author: 我是作者*)
(*Creation Date: 2018-7-30*)
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
BeginPackage["Stereogram`"];
StereogramEncode::usage = "";
StereogramDecode::usage = "";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
ExNumber::usage = "程序包的说明,这里抄一遍";
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
(* ::Subsubsection:: *)
(*StereogramEncode*)
StereogramShift[maxshift_][pattern_Image, depth_Image] := Block[
	{array, pos, shifted, width, height},
	{width, height} = {1 / 2, 1} ImageDimensions[pattern];
	array = maxshift Transpose@ImageData[depth, DataReversed -> True];
	pos = Function[position , (position + {Extract[array, Ceiling[position]], 0})];
	shifted = ImageTransformation[pattern, pos,
		Resampling -> "Cubic", Padding -> "Periodic",
		DataRange -> All, PlotRange -> {{0, width}, {0, height}}
	];
	ImageAssemble[{{ImageTake[pattern, All, {-width, -1}], shifted}}]
];
(*算法参考: *)
(*https://www.wolfram.com/language/11/image-and-signal-processing/visualize-and-synthesize-stereograms.html?product=mathematica*)
StereogramEncode[pattern_Image, depth_Image, maxshift_Integer : 24] := Module[
	{W, H, w, h, depthMap, patternStrip, ips},
	{w, h} = ImageDimensions[pattern];
	{W, H} = ImageDimensions[depth];
	depthMap = ImageCrop[ImageClip@ColorConvert[depth, "Grayscale"], {Ceiling[W, w], Full}];
	patternStrip = ImageCrop[ImageAssemble@Transpose@{ConstantArray[pattern, {Ceiling[H / h]}]}, {w, H}];
	ips = Map[
		Function[ strip , ImageTake[strip, All, {w / 2 + 1, -1}]],
		FoldList[
			StereogramShift[maxshift],
			patternStrip,
			Flatten@ImagePartition[depthMap, {1 / 2, 1} ImageDimensions[patternStrip]]
		]
	];
	ImageCrop[ImageAssemble@List@ips, {W, H}]
];

(* ::Subsubsection:: *)
(*StereogramDecode*)
StereogramDecode[img_Image, shift_Integer] := With[
	{ics = ImageDisplacements[{ImageTake[img, All, {shift + 1, -1}], ImageTake[img, All, {1, -shift - 1}]}]},
	Image[Function[depth, 1600depth / (160 + depth)][Map[Norm, RandomChoice@ics, {2}]]] // ImageAdjust
];


(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{ },
	{Protected, ReadProtected}
];
EndPackage[]
