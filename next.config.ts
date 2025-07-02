import type { NextConfig } from "next"

// Environment variables validation
const appEnv = process.env["APP_ENV"]
const isProduction = appEnv === "production"

// Security headers (OWASP recommended)
const securityHeaders = [
	{ key: "X-Content-Type-Options", value: "nosniff" },
	{ key: "X-Frame-Options", value: "SAMEORIGIN" },
	{ key: "X-XSS-Protection", value: "1; mode=block" },
	{ key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
	{ key: "Strict-Transport-Security", value: "max-age=63072000; includeSubDomains; preload" },
	{ key: "Permissions-Policy", value: "camera=(), microphone=(), geolocation=()" },
	{ key: "Content-Security-Policy", value: "default-src 'self'" },
]

const nextConfig: NextConfig = {
	output: isProduction ? "standalone" : undefined,
	reactStrictMode: true,
	poweredByHeader: false,
	trailingSlash: false, // or true, based on your routing preference
	compiler: {
		removeConsole: isProduction,
	},

	async headers() {
		return [
			{
				source: "/(.*)",
				headers: securityHeaders,
			},
		]
	},
}

export default nextConfig
