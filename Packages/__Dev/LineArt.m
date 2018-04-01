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
BeginPackage["Illusory`LineArt`"];
LineWebPainting::usage = "这里应该填这个函数的说明,如果要换行用\"\r\"\r就像这样";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
LineArt$Version = "V1.0";
LineArt$Environment = "V11.0+";
LineArt$LastUpdate = "2016-11-11";
LineArt::usage = "程序包的说明,这里抄一遍";
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
(* ::Subsubsection:: *)
(*网状线图*)
LineWebPainting[img_, k_ : 100] := Block[{radon, lhalf, inverseDualRadon, lines},
	If[k === 0, Return[img]];
	radon = Radon[ColorNegate@ColorConvert[img, "Grayscale"]];
	{w, h} = ImageDimensions[radon];
	lhalf = Table[N@Sin[\[Pi] i / h], {i, 0, h - 1}, {j, 0, w - 1}];
	inverseDualRadon = Image@Chop@InverseFourier[lhalf Fourier[ImageData[radon]]];
	lines = ImageApply[With[{p = Clip[k #, {0, 1}]}, RandomChoice[{1 - p, p} -> {0, 1}]]&, inverseDualRadon];
	ColorNegate@ImageAdjust[InverseRadon[lines, ImageDimensions[img], Method -> None], 0, {0, k}]];



(* ::Subsubsection:: *)
(*傅里叶图*)



(* ::Subsection::Closed:: *)
(*附加设置*)
End[] ;

EndPackage[];
