# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Build stage
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FROM node:20-alpine AS builder

WORKDIR /app

COPY . .

RUN corepack enable && pnpm install --frozen-lockfile
RUN pnpm build

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Run stage
# Production image, copy all the files and run Next.js
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FROM node:20-alpine AS runner

WORKDIR /app
ENV NODE_ENV production
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

USER nextjs
EXPOSE 3000

CMD ["node", "server.js"]