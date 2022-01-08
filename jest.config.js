module.exports = {
  moduleFileExtensions: [
    "js", "json", "vue"
  ],
  "transform": {
    "^.+\\.js$": "babel-jest",
    "^.+\\.vue$": "@vue/vue2-jest"
  },
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/app/javascript/$1",
    "@mixins": "@/mixins"
  },
  collectCoverage: true,
  collectCoverageFrom: ["**/app/javascript/**/*.{js, vue}", "!**/node_modules/**"],
  coverageDirectory: "coverage",
  coverageReporters: ['html'],
  testMatch: ["**/test/javascript/**/*.spec.js"],
  testEnvironment: "jsdom",
}
