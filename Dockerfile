FROM --platform=$BUILDPLATFORM node:20-alpine AS base

ARG NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID
ARG NEXT_PUBLIC_SEPOLIA_RPC_URL=https://ethereum-sepolia-rpc.publicnode.com

FROM base AS builder

# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat

WORKDIR /app
COPY . .
RUN yarn --frozen-lockfile
ENV NEXT_TELEMETRY_DISABLED=1
RUN yarn build

FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production

# Copy only the necessary files for production
COPY --from=builder /app/packages/arb-token-bridge-ui/build/standalone ./
COPY --from=builder /app/packages/arb-token-bridge-ui/public ./packages/arb-token-bridge-ui/public
COPY --from=builder /app/packages/arb-token-bridge-ui/build/static ./packages/arb-token-bridge-ui/build/static

# NOTE: set HOSTNAME=0.0.0.0 to listen on all interfaces, and PORT to change port
CMD ["node", "packages/arb-token-bridge-ui/server.js"]
