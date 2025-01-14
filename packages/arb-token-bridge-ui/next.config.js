// @ts-check type next.config.js

/**
 * @type {import('next').NextConfig}
 **/

module.exports = {
  output: 'standalone',
  distDir: 'build',
  productionBrowserSourceMaps: true,
  reactStrictMode: true,
  async headers() {
    return [
      {
        source: '/api/status',
        headers: [
          {
            key: 'Access-Control-Allow-Origin',
            value: 'https://portal.arbitrum.io'
          },
          {
            key: 'Access-Control-Allow-Methods',
            value: 'GET'
          }
        ]
      }
    ]
  },
  async redirects() {
    return [
      {
        source: '/:slug',
        destination: '/?destinationChain=:slug',
        permanent: true
      }
    ]
  }
}
