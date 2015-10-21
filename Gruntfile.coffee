currentVersion = 'v0.2.0'
module.exports = (grunt) ->

    grunt.config.init

        'mocha-chai-sinon':
            spec:
                src: [
                    'spec/**/*.coffee'
                ]
                options:
                    ui: 'bdd'
                    reporter: 'spec'
                    require: 'coffee-script/register'

            single:
                src: [
                    grunt.option('file') ? 'spec/lib/jp-wrap.coffee'
                ]
                options:
                    ui: 'bdd'
                    reporter: 'spec'
                    require: 'coffee-script/register'


        browserify:
            dist:
                files:
                    'dist/jp-wrap.web.js': 'src/web.js'

        uglify:
            dist:
                files:
                    'dist/jp-wrap.min.js' : 'dist/jp-wrap.web.js'


        coffee:
            dist:
                expand: true
                cwd: 'src/'
                src: ['**/*.coffee']
                dest: 'dist/'
                ext: '.js'
                extDot: 'first'
                options:
                    bare: true

        yuidoc:
            options:
                paths: [ 'src' ]
                syntaxtype: 'coffee'
                extension: '.coffee'

            master:
                options:
                    outdir: 'doc'



    grunt.registerTask 'pack', ->

        done = @async()

        { pack } = require('titaniumifier').packer

        packed = pack __dirname, {}, ->
            Promise = packed.constructor
            fs = require 'fs'
            Promise.props(packed).then (v) ->
                fs.writeFileSync __dirname + '/dist/jp-wrap.packed.js', v.source
                done()


    grunt.loadNpmTasks 'grunt-mocha-chai-sinon'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-yuidoc'

    grunt.registerTask 'default', 'mocha-chai-sinon:spec'
    grunt.registerTask 'single', 'mocha-chai-sinon:single'
    grunt.registerTask 'build', ['coffee:dist', 'browserify', 'uglify', 'pack']
