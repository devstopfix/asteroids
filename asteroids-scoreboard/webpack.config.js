const path = require('path');
const webpack = require('webpack');

const PATHS = {
    src: path.resolve(__dirname, 'src'),
    bin: path.resolve(__dirname, 'bin')
};

module.exports = {
    entry: [
        // 'webpack-dev-server/client?http://0.0.0.0:3030', // WebpackDevServer host and port
        // 'webpack/hot/only-dev-server', // "only" prevents reload on syntax errors
        PATHS.src
    ],
    output: {
        path: PATHS.bin,
        filename: 'bundle.js'
    },
    module: {
        loaders: [
            {
                test: /\.js$/,
                loaders: ['babel'],
                include: PATHS.src,
                exclude: /(node_modules|bower_components)/
            },
            {
                test: /\.less$/,
                loaders: ['style', 'css', 'less'],
                include: PATHS.app
            },
            {
                test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: 'url-loader?limit=10000&mimetype=application/font-woff'
            },
            {
                test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: 'file-loader'
            }
        ]
    },
    devtool: 'inline-source-map',
    devServer: {
        contentBase: PATHS.bin,

        historyApiFallback: false,
        hot: true,
        inline: true,
        progress: true,

        // Display only errors to reduce the amount of output.
        stats: 'errors-only',

        host: process.env.HOST || 'localhost',
        port: process.env.PORT || 3032
    },
    plugins: [
        new webpack.HotModuleReplacementPlugin()
    ]
};
