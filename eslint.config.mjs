import { FlatCompat } from "@eslint/eslintrc"
import { dirname } from "path"
import { fileURLToPath } from "url"

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

const compat = new FlatCompat({
	baseDirectory: __dirname,
})

export default (async () => {
	const tsParser = (await import("@typescript-eslint/parser")).default
	const tsPlugin = (await import("@typescript-eslint/eslint-plugin")).default

	return [
		{
			ignores: ["**/*.js", "**/*.cjs", "**/*.mjs"],
			files: ["**/*"],
		},
		...compat.extends(
			"next/core-web-vitals",
			"plugin:@typescript-eslint/recommended",
			"plugin:react/recommended",
			"plugin:react-hooks/recommended",
			"plugin:prettier/recommended"
		),
		{
			languageOptions: {
				parser: tsParser,
				parserOptions: {
					project: "./tsconfig.json",
				},
			},
			plugins: {
				"@typescript-eslint": tsPlugin,
			},
			rules: {
				"@typescript-eslint/no-unused-vars": ["error"],
				"react/react-in-jsx-scope": "off",
				"react/jsx-filename-extension": [1, { extensions: [".tsx"] }],
			},
		},
	]
})()
