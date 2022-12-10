module.exports = {
  publicPath: './',
  outputDir: '../ui',
  filenameHashing: false,
  productionSourceMap: false,
  chainWebpack: (config) => {
    config.optimization.delete('splitChunanon');
    config.externals({
      moment: 'moment',
    });
  },
};
