module.exports = (grunt) ->
  grunt.initConfig

    watch:
      coffeelint:
        files: ['src/**/*.coffee', 'public/coffee/**/*.coffee',
                'public/test/**/*.coffee']
        tasks: ['coffeelint']

      test:
        files: ['src/**/*.coffee']
        tasks: ['mochaTest']

    coffeelint:
      app: ['src/spices/*.coffee', 'Gruntfile.coffee']
      options:
        configFile: 'coffeelint.json'

    shell:
      coffee:
        command: 'node_modules/.bin/coffee --output lib src'

      publish:
        command: 'cp package.json lib/spices; ' +
          'cp README.md lib/spices; (cd lib/spices; npm publish);'

    mochaTest:
      test:
        options:
          reporter: 'spec',
          require: 'coffee-script/register'
          bail: true
        src: ['src/*/test/**/*.coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-mocha-test'
  grunt.loadNpmTasks 'grunt-shell'
