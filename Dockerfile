# syntax=docker/dockerfile:1
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Dependency stage
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FROM node:20-alpine AS base

# Dependency stage
FROM base AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml* ./
RUN corepack enable pnpm && pnpm i --frozen-lockfile


# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Builder stage
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FROM base AS builder
WORKDIR /app

ENV APP_ENV=production

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN corepack enable pnpm && pnpm build

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Runner stage
# Production image, copy all the files and run Next.js
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FROM node:20-alpine AS runner
WORKDIR /app

ENV APP_ENV=production
ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

# Install dumb-init directly in the runner stage
RUN apk add --no-cache dumb-init

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

USER nextjs

# Use dumb-init for proper signal handling
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Start the Next.js server
CMD ["node", "server.js"]
