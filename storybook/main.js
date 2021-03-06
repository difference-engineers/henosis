/* eslint-disable import/no-commonjs */
/* eslint-disable import/no-nodejs-modules */
const {resolve} = require("path");

module.exports = {
  stories: ["../@henosis/**/story.js"],
  addons: [
    "@storybook/addon-a11y/register",
    "@storybook/addon-knobs/register",
    {
      name: "@storybook/addon-storysource",
      options: {
        rule: {
          test: [/story\.js?$/u],
          include: [resolve(__dirname, "..", "apps", "browser", "lib")],
        },
      },
    },
  ],
};
