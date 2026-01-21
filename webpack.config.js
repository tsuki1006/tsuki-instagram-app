const path    = require("path")
const webpack = require("webpack")

module.exports = {
  mode: "development",
  devtool: "source-map",

  entry: {  // エントリポイント
    application: "./app/javascript/application.js",
    article:     "./app/javascript/article.js",
    comment:     "./app/javascript/comment.js",
    profile:     "./app/javascript/profile.js"
  },

  output: {
    filename: "[name].js",
    sourceMapFilename: "[file].map",
    chunkFormat: "module",
    path: path.resolve(__dirname, "app/assets/builds"),
  },

  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ],

  resolve: {

    modules: [
      path.resolve(__dirname, 'app/javascript'), // 1. アプリケーションの JS ルート
      'node_modules'                             // 2. それで見つからなければ node_modules
    ],

    alias: {  // インポートを簡潔にするためのエイリアス
      jquery: path.resolve(__dirname, 'node_modules/jquery'),
      },

    symlinks: false  // symlinkを辿らない（WSL/Windows間のパス混乱防止）
  },
}