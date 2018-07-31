module.exports = {
	dest: 'docs/.build',
	locales: {
		'/': {
			lang: 'zh-CN',
			title: 'Illusory',
			description: '视觉盛宴!'
		}
	},
	serviceWorker: true,
	themeConfig: {
		repo: 'GalAster/Illusory',
		editLinks: true,
		docsDir: 'docs',
		markdown: {
			lineNumbers: true
		},
		sidebar: [
			{
				title: '简介',
				children: [
					'/Start/',
					'/Start/Developer.md',
					'/Start/Editor.md'
				]
			}
		]
	}
};
