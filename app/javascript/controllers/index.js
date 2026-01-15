// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application"

// Stimulusコントローラーを自動で読み込むための設定 (Webpack用)
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"
const context = require.context(".", true, /_controller\.js$/)
application.load(definitionsFromContext(context))
