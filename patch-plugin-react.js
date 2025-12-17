const fs = require('fs');
const path = require('path');

// 读取插件文件
const pluginPath = path.join(__dirname, 'node_modules', '.pnpm', '@vitejs+plugin-react@4.7.0__d054a23b96f036048e050013ca170b9c', 'node_modules', '@vitejs', 'plugin-react', 'dist', 'index.cjs');
let content = fs.readFileSync(pluginPath, 'utf8');

// 修改 loadPlugin 函数，让它在无法加载插件时返回 null，而不是抛出错误
const newLoadPlugin = `function loadPlugin(path) {
	const cached = loadedPlugin.get(path);
	if (cached) return cached;
	const promise = import(path).then((module$1) => {
		const value = module$1.default || module$1;
		loadedPlugin.set(path, value);
		return value;
	}).catch(() => {
		// 无法加载插件时返回 null，而不是抛出错误
		return null;
	});
	loadedPlugin.set(path, promise);
	return promise;
}`;

content = content.replace(/function loadPlugin\(path\) {[^}]+}/s, newLoadPlugin);

// 修改 transform 函数，过滤掉 null 插件
const newTransform = `if (useFastRefresh) {
	const refreshPlugin = await loadPlugin("react-refresh/babel");
	if (refreshPlugin) plugins.push([refreshPlugin, { skipEnvCheck: true }]);
}
if (opts.jsxRuntime === "classic" && isJSX) {
	if (!isProduction) {
		const selfPlugin = await loadPlugin("@babel/plugin-transform-react-jsx-self");
		const sourcePlugin = await loadPlugin("@babel/plugin-transform-react-jsx-source");
		if (selfPlugin) plugins.push(selfPlugin);
		if (sourcePlugin) plugins.push(sourcePlugin);
	}
}`;

content = content.replace(/if \(useFastRefresh\) plugins\.push\(\[await loadPlugin\("react-refresh\/babel"\), \{ skipEnvCheck: true \} \]\);
		if \(opts\.jsxRuntime === "classic" && isJSX\) {
			if \(!isProduction\) plugins\.push\(await loadPlugin\("@babel\/plugin-transform-react-jsx-self"\), await loadPlugin\("@babel\/plugin-transform-react-jsx-source"\)\);
		}/s, newTransform);

// 写入修改后的文件
fs.writeFileSync(pluginPath, content);

console.log('插件修改成功！');
