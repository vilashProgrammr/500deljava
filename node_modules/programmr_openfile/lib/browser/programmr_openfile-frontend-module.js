"use strict";
/**
 * Generated using theia-extension-generator
 */
Object.defineProperty(exports, "__esModule", { value: true });
var programmr_openfile_contribution_1 = require("./programmr_openfile-contribution");
var browser_1 = require("@theia/core/lib/browser");
var inversify_1 = require("inversify");
exports.default = new inversify_1.ContainerModule(function (bind) {
    // add your contribution bindings here
    bind(browser_1.FrontendApplicationContribution).to(programmr_openfile_contribution_1.Programmr_openfileCommandContribution);
});
//# sourceMappingURL=programmr_openfile-frontend-module.js.map