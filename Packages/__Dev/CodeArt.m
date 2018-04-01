(* ::Package:: *)
(* ::Title:: *)
(*CodeArt(代码艺术)*)
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
BeginPackage["Illusory`CodeArt`"];
QRPainting::usage = "这里应该填这个函数的说明,如果要换行用\"\r\"\r就像这样";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
CodeArt$Version = "V1.0";
CodeArt$Environment = "V11.0+";
CodeArt$LastUpdate = "2016-11-11";
CodeArt::usage = "程序包的说明,这里抄一遍";
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
(* ::Subsubsection:: *)
(*功能块 1*)
QRPainting[aim_, text_ : "https://github.com/GalAster/Illusory"] := Block[
	{img, d, tgi, f, cg, dat, color},
	img = ImageData@ColorConvert[BarcodeImage[text, {"QR", "H"}, 50], "LAB"];
	d = Length@img;
	tgi = ImageAdjust@ImageResize[aim, Most@Dimensions@img];

	color[Lmat_, A_, B_] := Map[{.8# + .2, A, B}&, Lmat, {2}];
	f[0, {_?(# >= .9&), _, _}] := color[1 - DiskMatrix[0, 3], 0, 0];
	f[1, {_?(# < .1&), _, _}] := color[DiskMatrix[0, 3], 0, 0];
	f[x_, {L_, A_, B_}] := color[Partition[Insert[RandomSample[1 - UnitStep[Range@8 - Floor[L * 10] + x]], x, 5], 3], A, B];
	f[x_List, LAB_List] := f @@@ Thread@{x, LAB};

	cg[m_] := ArrayFlatten@Map[ConstantArray[#, {3, 3}]&, m, {2}];
	dat = ArrayFlatten[f[img[[;;, ;;, 1]], ImageData[ColorConvert[tgi, "LAB"]][[;;, ;;, ;; 3]]]];
	(dat[[Span[24#1], Span[24#2]]] = cg[img[[Span[8#1], Span[8#2]]]])& @@@ {{1, 1}, {1, -1}, {-1, 1}};
	dat[[22 ;; 3d - 21, 19 ;; 21]] = Transpose[dat[[19 ;; 21, 22 ;; 3d - 21]] = cg[{{#, 0, 0}& /@ Mod[Range[d - 14], 2]}]];
	Image[dat, ColorSpace -> "LAB", ImageSize -> Large]
];


(* ::Subsubsection:: *)
(*功能块 2*)
ExampleFunction[2] = "我就是个示例函数,什么功能都没有";


(* ::Subsection::Closed:: *)
(*附加设置*)
End[] ;

EndPackage[];
