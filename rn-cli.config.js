/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow
 * @format
 */
'use strict';
const path = require('path');
const getPolyfills = require('./rn-get-polyfills');

const fs = require('fs');
/**
 * This cli config is needed for development purposes, e.g. for running
 * integration tests during local development or on CI services.
 */

// In sdx repo we need to use metro-resources to handle all the rush symlinking
if (
  fs.existsSync(path.resolve(__dirname, '../../scripts/metro-resources.js'))
) {
  const sdxHelpers = require('../../scripts/metro-resources');

  module.exports = sdxHelpers.createConfig({
    extraNodeModules: {
      'react-native': __dirname,
    },
    roots: [path.resolve(__dirname)],
    projectRoot: __dirname,

    serializer: {
      getModulesRunBeforeMainModule: () => [
        require.resolve('./Libraries/Core/InitializeCore'),
      ],
      getPolyfills,
    },
    resolver: {
      hasteImplModulePath: require.resolve('./jest/hasteImpl'),
    },
    transformer: {
      assetRegistryPath: require.resolve('./Libraries/Image/AssetRegistry'),
    },
  });
} else {
  module.exports = {
    extraNodeModules: {
      'react-native': __dirname,
    },
    serializer: {
      getModulesRunBeforeMainModule: () => [
        require.resolve('./Libraries/Core/InitializeCore'),
      ],
      getPolyfills,
    },
    resolver: {
      hasteImplModulePath: require.resolve('./jest/hasteImpl'),
      platforms: ['win32', 'ios', 'macos', 'android', 'uwp', 'windesktop'],
    },
    transformer: {
      assetRegistryPath: require.resolve('./Libraries/Image/AssetRegistry'),
    },
  };
}
