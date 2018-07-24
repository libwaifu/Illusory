module.exports = {
	dest: 'docs/.build',
	locales: {
		'/': {
			lang: 'zh-CN',
			title: 'Illusory',
			description: 'Illusory!'
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
					'/Start/Design.md',
					'/Start/Guide.md'
				]
			}
		]
	}
};
