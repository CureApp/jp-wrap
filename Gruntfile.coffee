currentVersion = 'v0.0.0'
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





    grunt.loadNpmTasks 'grunt-mocha-chai-sinon'
    grunt.loadNpmTasks 'grunt-contrib-coffee'

    grunt.registerTask 'default', 'mocha-chai-sinon:spec'
    grunt.registerTask 'single', 'mocha-chai-sinon:single'
    grunt.registerTask 'build', ['coffee:dist']
