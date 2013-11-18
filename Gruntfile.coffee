module.exports  = ( grunt ) ->

  # Project config
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      build:
        src:  'build/js/<%= pkg.name %>.js',
        dest: 'build/js/<%= pkg.name %>.min.js'

    coffee:
      compile:
        files:
          'build/js/<%= pkg.name %>.js': ['src/*.coffee']

    mocha_phantomjs:
      options:
        reporter: 'dot'
      all: ['test/**/*.html']

    coffeelint:
      app: 'src/*.coffee'

    coffee_jshint:
      options: []
      source:
        src: 'src/*.coffee'
      specs:
        src: 'test/spec/*.coffee'

    sass:
      dist:
        files: ['build/main.css': 'src/*.sass']

    watch:
      scripts:
        files: [
          'src/*.coffee',
          'test/spec/*.coffee'
        ]
        tasks: [
          'compile',
          'inspection'
        ]

  # Load plugins
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-mocha-phantomjs'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-coffee-jshint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-sass'

  # Define tasks
  grunt.registerTask 'default', [
    'compile',
    'inspection'
  ]

  grunt.registerTask 'compile', [
    'coffee',
    'uglify',
    'sass'
  ]

  grunt.registerTask 'inspection', [
    'coffeelint',
    'coffee_jshint'
  ]

  # Test task
  grunt.registerTask 'test', [
    'compile',
    'mocha_phantomjs'
  ]
