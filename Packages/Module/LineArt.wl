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
(* ::Text:: *)
(*这里应该填这个函数包的介绍*)
(* ::Section:: *)
(*函数说明*)
BeginPackage["LineArt`"];
LineWeb::usage = "";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
LineArt::usage = "程序包的说明,这里抄一遍";
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
Version$LineArt = "V1.0";
Update$LineArt = "2016-11-11";
(* ::Subsubsection:: *)
(*网状线图*)
LineWeb[img_Image, k_ : 100] := Block[
	{radon, halfL, invRadon, lines, w, h},
	If[k == 0, Return[img]];
	radon = Radon[ColorNegate@ColorConvert[img, "Grayscale"]];
	{w, h} = ImageDimensions[radon];
	halfL = Table[N@Sin[Pi i / h], {i, 0, h - 1}, {j, 0, w - 1}];
	invRadon = Image@Chop@InverseFourier[halfL Fourier[ImageData[radon]]];
	lines = ImageApply[With[{p = Clip[k #, {0, 1}]}, RandomChoice[{1 - p, p} -> {0, 1}]]&, invRadon];
	ColorNegate@ImageAdjust[InverseRadon[lines, ImageDimensions[img], Method -> None], 0, {0, k}]
];



(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{LineWeb},
	{Protected, ReadProtected}
];
EndPackage[]
