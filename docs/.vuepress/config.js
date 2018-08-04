module.exports = {
	dest: 'docs/.build',
	locales: {
		'/': {
			lang: 'zh-CN',
			title: 'Illusory',
			description: 'Mathematica 视觉盛宴!'
		}
	},
	themeConfig: {
		repo: 'GalAster/Illusory',
		editLinks: true,
		docsDir: 'docs',
		markdown: {
			lineNumbers: true
		},
		sidebar: [
			{
				title: '开发文档',
				children: [
					'/Start/',
					'/Start/Developer.md',
					'/Start/Editor.md',
					'/Start/EditorAdv.md'
				]
			},
			{
				title: 'TextArt 模块',
				children: [
					'/TextArt/'
				]
			},
			{
				title: 'LineArt 模块',
				children: [
					'/LineArt/'
				]
			},
			{
				title: 'PolyArt 模块',
				children: [
					'/PolyArt/'
				]
			},
			{
				title: 'Stereogram 模块',
				children: [
					'/Stereogram/'
				]
			}
		]
	},
	serviceWorker: true,
	configureWebpack: {
		resolve: {
			alias: {
				'@pkg': 'Packages/Module'
			}
		}
	}
};
