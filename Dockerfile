FROM oven/bun:1 AS build
WORKDIR /app
COPY . .
RUN bun install --frozen-lockfile && bun run build

FROM node:20-alpine
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./
COPY server-wrapper.js ./
ENV NODE_ENV=production PORT=3000
EXPOSE 3000
CMD ["node", "server-wrapper.js"]
